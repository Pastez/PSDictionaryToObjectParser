//
//  SampleObjectA.h
//  PSDictionaryToObjectParser
//
//  Created by Tomasz Kwolek on 29.08.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SampleObjectA : NSObject

@property (strong,nonatomic) NSString *name;
@property (readwrite,nonatomic) NSInteger age;
//@property (readwrite,nonatomic) BOOL age;
//@property (strong,nonatomic) NSNumber *age;
@property (readwrite,nonatomic) bool isMale;
@property (strong,nonatomic) NSArray *childrens;

@end
