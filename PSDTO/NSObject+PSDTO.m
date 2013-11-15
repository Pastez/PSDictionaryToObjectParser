//
//  NSObject+PSDTO.m
//  PSDictionaryToObjectParser
//
//  Created by Tomasz Kwolek on 02.09.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "NSObject+PSDTO.h"
#import "PSDTO.h"
#import <objc/runtime.h>

@implementation NSObject (PSDTO)

- (id)propertyListRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    
    for (NSUInteger i = 0; i < propertyCount; i++)
    {
        objc_property_t property = properties[ i ];
        const char *propertyName = property_getName( property );
        
        NSString *name = [NSString stringWithCString:propertyName encoding:[NSString defaultCStringEncoding]];
        id value = [self valueForKeyPath:name];
        if (value) {
            if ([value isKindOfClass:[NSString class]] ||
                [value isKindOfClass:[NSNumber class]] ||
                [value isKindOfClass:[NSData class]] ||
                [value isKindOfClass:[NSDate class]] ||
                [value isKindOfClass:[NSArray class]] ||
                [value isKindOfClass:[NSDictionary class]])
            {
                [dict setValue:value forKey:name];
            }else if( [value isKindOfClass:[NSObject class]] )
            {
                [dict setValue:[value propertyListRepresentation] forKeyPath:name];
            }
        
        }
    }
    
    free(properties);
    return dict;
}

+ (instancetype)createWithPropertyListRepresentation:(id)plist
{
    id obj = [[self alloc] init];
    
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    
    for (NSUInteger i = 0; i < propertyCount; i++)
    {
        objc_property_t property = properties[ i ];
        const char *propertyName = property_getName( property );
        NSString *name = [NSString stringWithCString:propertyName encoding:[NSString defaultCStringEncoding]];
        //NSString *type = [PSDTO getPropertyType:property];
        id value = [plist objectForKey:name];
        if (value) {
            [obj setValue:value forKeyPath:name];
        }
    }
    
    free(properties);
    return obj;
}

@end
