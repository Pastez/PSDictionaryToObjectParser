//
//  SampleObjectA.h
//  PSDictionaryToObjectParser
//
//  15.11.2013
//  Copyright (C) 2013 Tomasz Kwolek (www.pastez.com).
//  44-100 Gliwice, Poland

//
//  DO WHAT THE FUCK YOU WANT TO.

#import <Foundation/Foundation.h>

@interface SampleObjectA : NSObject

@property (strong,nonatomic) NSString *name;
@property (readwrite,nonatomic) NSInteger age;
//@property (readwrite,nonatomic) BOOL age;
//@property (strong,nonatomic) NSNumber *age;
@property (readwrite,nonatomic) bool isMale;
@property (strong,nonatomic) NSArray *childrens;

@end
