//
//  NSObject+PSDTO.h
//  PSDictionaryToObjectParser
//
//  15.11.2013
//  Copyright (C) 2013 Tomasz Kwolek (www.pastez.com).
//  44-100 Gliwice, Poland

//
//  DO WHAT THE FUCK YOU WANT TO.

#import <Foundation/Foundation.h>

@interface NSObject (PSDTO)

- (id)propertyListRepresentation;
+ (instancetype)createWithPropertyListRepresentation:(id)plist;

@end
