//
//  SampleObjectC.h
//  PSDictionaryToObjectParser
//
//  Created by Tomasz Kwolek on 02.09.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SampleObjectA.h"
#import "SampleObjectB.h"

@interface SampleObjectC : NSObject

@property (strong,nonatomic) SampleObjectA *objectA;
@property (strong,nonatomic) SampleObjectB *objectB;

- (void)defaultValues;

@end
