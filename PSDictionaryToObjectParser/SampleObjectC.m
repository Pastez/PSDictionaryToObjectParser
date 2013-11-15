//
//  SampleObjectC.m
//  PSDictionaryToObjectParser
//
//  15.11.2013
//  Copyright (C) 2013 Tomasz Kwolek (www.pastez.com).
//  44-100 Gliwice, Poland

//
//  DO WHAT THE FUCK YOU WANT TO.

#import "SampleObjectC.h"

@implementation SampleObjectC

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)defaultValues
{
    NSDictionary *objA_dict = @{ @"name" : @"Pastez",
                                 @"age" : @27,
                                 @"isMale" : [NSNumber numberWithBool:YES],
                                 @"childrens" : @[@"jas",@"malgosia",@"dupa"]};
    
    NSDictionary *objB_dict = @{ @"someKey" : @"someKeyValue ok",
                                 @"unused" : @"shit"};
    
    self.objectA = [SampleObjectA createWithPropertyListRepresentation:objA_dict];
    self.objectB = [SampleObjectB createWithPropertyListRepresentation:objB_dict];
}

@end
