//
//  PSDTO.m
//  PSDictionaryToObjectParser
//
//  Created by Tomasz Kwolek on 29.08.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSDTO.h"
#import <objc/runtime.h>

#pragma mark destination object

@interface DestinationObject : NSObject

@property (readonly,nonatomic) Class objectClass;
@property (readonly,nonatomic) NSUInteger propertyCount;

- (id)initWithClass:(Class)objectClass;

@end

@implementation DestinationObject

- (id)initWithClass:(Class)objectClass
{
    self = [super init];
    if (self) {
        _objectClass = objectClass;
        objc_property_t *properties = class_copyPropertyList(objectClass, &_propertyCount);
        free(properties);
    }
    return self;
}

@end

#pragma mark core

@interface PSDTO()

@property (strong,nonatomic) NSDictionary *typeMap;

@end

@implementation PSDTO

+ (PSDTO*)sharedInstance {
    static dispatch_once_t onceToken;
    static PSDTO *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super alloc] initUniqueInstance];
    });
    return sharedInstance;
}

- (PSDTO*)initUniqueInstance {
    self = [super init];
    if (self) {
        self.typeMap = @{@"d": @"__NSCFNumber",
                         @"f": @"__NSCFNumber",
                         @"i": @"__NSCFNumber",
                         @"l": @"__NSCFNumber",
                         @"c": @"__NSCFBoolean",
                         @"B": @"__NSCFBoolean"};
        _posibleDestinationObjects = [NSArray array];
    }
    return self;
}

- (void)addDestinationObject:(Class)objectClass
{
    for (DestinationObject *destinationObject in _posibleDestinationObjects) {
        if (destinationObject.objectClass == objectClass) {
#if DEBUG_DTO
            NSLog(@"destination object already added");
#endif
            return;
        }
    }
    
    NSMutableArray *posibleDestinations = [NSMutableArray arrayWithArray:_posibleDestinationObjects];
    [posibleDestinations addObject:[[DestinationObject alloc] initWithClass:objectClass]];
    
    NSSortDescriptor *paramCountSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"propertyCount" ascending:NO];
    [posibleDestinations sortedArrayUsingDescriptors:@[paramCountSortDescriptor]];
    _posibleDestinationObjects = posibleDestinations;
}

- (void)removeDestinationObject:(Class)objectClass
{
    NSMutableArray *posibleDestinations = [NSMutableArray arrayWithArray:_posibleDestinationObjects];
    
    for (NSInteger i = posibleDestinations.count-1; i >= 0; i--) {
        DestinationObject *destinationObject = posibleDestinations[ i ];
        if (destinationObject.objectClass == objectClass) {
            [posibleDestinations removeObjectAtIndex:i];
        }
    }
    
    
    
    _posibleDestinationObjects = posibleDestinations;
}

- (void)parseDictionary:(NSDictionary*)data onComplete:(void (^) (id object))successHandler onFaild:(void (^) (NSException *exception))faildHandler
{
    for (DestinationObject *destinationObject in _posibleDestinationObjects) {
        
        if ([self canParseDictionary:data toObjectOfKind:destinationObject.objectClass])
        {
            id object = [destinationObject.objectClass createWithPropertyListRepresentation:data];
            successHandler( object );
            return;
        }
    }
    NSException *exception = [NSException exceptionWithName:@"destination not found" reason:@"data doesn't match any objects" userInfo:nil];
    faildHandler( exception );
}

- (BOOL)canParseDictionary:(NSDictionary *)data toObjectOfKind:(Class)objectClass
{
    //get class properties
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(objectClass, &propertyCount);
    
    if (propertyCount > data.allKeys.count) {
#if DEBUG_DTO
        NSLog(@"object \"%@\" have more properties(%d) than dictionary(%d)",NSStringFromClass(objectClass),propertyCount,data.allKeys.count);
#endif
        return NO;
    }
    
    for (NSUInteger i = 0; i < propertyCount; i++)
    {
        objc_property_t property = properties[ i ];
        const char *propertyName = property_getName( property );
        if( propertyName )
        {
            NSString *type      = [PSDTO getPropertyType:property];
            NSString *name      = [NSString stringWithCString:propertyName
                                                     encoding:[NSString defaultCStringEncoding]];
            //check if propety name exist in dictionaty
            BOOL nameFound = NO;
            for (NSString *keyName in [data allKeys]) {
                if ([keyName isEqualToString:name]) {
                    nameFound = YES;
                    break;
                }
            }
            //check if type match
            if (nameFound) {
                
                if (![[data objectForKey:name] isKindOfClass:NSClassFromString(type)])
                {
                    BOOL typeConversionAvaiable = NO;
                    for (NSString *typeMapedKey in [_typeMap allKeys]) {
                        if ([typeMapedKey isEqualToString:type]) {
                            NSString *typeMapedValue = [_typeMap objectForKey:typeMapedKey];
                            if ([typeMapedValue isEqualToString:NSStringFromClass([[data objectForKey:name] class])]) {
                                typeConversionAvaiable = YES;
                                break;
                            }
                        }
                    }
                    if (!typeConversionAvaiable && [[data objectForKey:name] isKindOfClass:[NSDictionary class]]) {
                        Class destinationClass = NSClassFromString(type);
                        if ([destinationClass respondsToSelector:@selector(createWithPropertyListRepresentation:)]) {
                            typeConversionAvaiable = YES;
                        }
                        
                    }
                    if (!typeConversionAvaiable) {
#if DEBUG_DTO
                        NSLog(@"property \"%@\" of type \"%@\" missmatch with property of type \"%@\"",name,type,NSStringFromClass([[data objectForKey:name] class]));
#endif
                        return NO;
                    }
                }
            }else
            {
#if DEBUG_DTO
                NSLog(@"property \"%@\" in \"%@\" not found in dictionary",name,NSStringFromClass(objectClass));
#endif
                return NO;
            }
            
            
        }
        
    }
    free(properties);
    return YES;
}

//utils

+ (NSString*)getPropertyType:(objc_property_t)property
{
    const char *propertyType = getPropertyType(property);
    return [NSString stringWithCString:propertyType
                              encoding:[NSString defaultCStringEncoding]];
}

static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    //printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    return "";
}

@end
