//
//  SampleObjectC.m
//  PSDictionaryToObjectParser
//
//  Created by Tomasz Kwolek on 02.09.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

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
