//
//  SampleObjectC.h
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
#import "SampleObjectA.h"
#import "SampleObjectB.h"

@interface SampleObjectC : NSObject

@property (strong,nonatomic) SampleObjectA *objectA;
@property (strong,nonatomic) SampleObjectB *objectB;

- (void)defaultValues;

@end
