//
//  NSObject+PSDTO.h
//  PSDictionaryToObjectParser
//
//  Created by Tomasz Kwolek on 02.09.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PSDTO)

- (id)propertyListRepresentation;
+ (instancetype)createWithPropertyListRepresentation:(id)plist;

@end
