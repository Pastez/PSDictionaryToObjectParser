//
//  PSDTO.h
//  PSDictionaryToObjectParser
//
//  Created by Tomasz Kwolek on 29.08.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "NSObject+PSDTO.h"

#define DEBUG_DTO   0

@interface PSDTO : NSObject

@property (readonly,strong,nonatomic) NSArray *posibleDestinationObjects;

+ (PSDTO*)sharedInstance;

- (void)addDestinationObject:(Class)objectClass;
- (void)removeDestinationObject:(Class)objectClass;
- (void)parseDictionary:(NSDictionary*)data onComplete:(void (^) (id object))successHandler onFaild:(void (^) (NSException *exception))faildHandler;
- (BOOL)canParseDictionary:(NSDictionary*)data toObjectOfKind:(Class)objectClass;

+ (NSString*)getPropertyType:(objc_property_t)property;

@end
