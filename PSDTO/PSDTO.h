//
//  PSDTO.h
//  PSDictionaryToObjectParser
//
//  15.11.2013
//  Copyright (C) 2013 Tomasz Kwolek (www.pastez.com).
//  44-100 Gliwice, Poland
//  Everyone is permitted to copy and distribute verbatim copies
//  of this license document, but changing it is not allowed.
//
//  Ok, the purpose of this license is simple
//  and you just
//
//  DO WHAT THE FUCK YOU WANT TO.

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
