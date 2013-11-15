//
//  PSViewController.m
//  PSDictionaryToObjectParser
//
//  15.11.2013
//  Copyright (C) 2013 Tomasz Kwolek (www.pastez.com).
//  44-100 Gliwice, Poland

//
//  DO WHAT THE FUCK YOU WANT TO.

#import "PSViewController.h"
#import "SampleObjectA.h"
#import "SampleObjectB.h"
#import "SampleObjectC.h"

@interface PSViewController ()

@property (assign,nonatomic) PSDTO *dto;

@end

@implementation PSViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dto = [PSDTO sharedInstance];
    // adding posible destination objects classes
    [_dto addDestinationObject:[SampleObjectA class]];
    [_dto addDestinationObject:[SampleObjectB class]];
    [_dto addDestinationObject:[SampleObjectC class]];

    // property list representation tests
#if 1
    SampleObjectC *objectC = [[SampleObjectC alloc] init];
    [objectC defaultValues];
    NSDictionary *objectCRepresentation = [objectC propertyListRepresentation];
    
    SampleObjectC *objectC_new = [SampleObjectC createWithPropertyListRepresentation:objectCRepresentation];
    NSDictionary *objectCNewRepresentation = [objectC_new propertyListRepresentation];
    
    NSAssert([objectCRepresentation isEqualToDictionary:objectCNewRepresentation], @"shoud be equal");
#endif
    
    // testing PSDTO magic parsing
#if 1
    NSDictionary *testA0 = @{ @"someKey" : @"someValue" };
    NSDictionary *testA1 = @{ @"name" : @"Pastez",
                              @"age" : @27,
                              @"isMale" : [NSNumber numberWithBool:YES],
                              @"childrens" : @[@"jas",@"malgosia",@"dupa"]};
    
    // can parse
    NSAssert([_dto canParseDictionary:testA0 toObjectOfKind:[SampleObjectA class]] == NO, @"shoud fail");
    NSAssert([_dto canParseDictionary:testA1 toObjectOfKind:[SampleObjectA class]] == YES, @"shoud parse");
    
    // test SampleObjectA
    [_dto parseDictionary:testA1 onComplete:^(id object)
    {
        NSAssert([object isKindOfClass:[SampleObjectA class]], @"shoud be SampleObjectA");
    } onFaild:^(NSException *exception)
    {
        NSLog(@"exception: %@",exception);
    }];
#endif
    
    // test SampleObjectC that contains A & B serialization
#if 1
    NSString *ocPath = [[NSBundle mainBundle] pathForResource:@"sampleObjectC" ofType:@"plist"];
    NSDictionary *objectCDictionary = [NSDictionary dictionaryWithContentsOfFile:ocPath];
    NSAssert([_dto canParseDictionary:objectCDictionary toObjectOfKind:[SampleObjectC class]],@"shoud be able to parse");
    [_dto parseDictionary:objectCDictionary onComplete:^(id object)
     {
         NSAssert([object isKindOfClass:[SampleObjectC class]], @"shoud be SampleObjectC");
         NSAssert([objectCDictionary isEqualToDictionary:[object propertyListRepresentation]], @"shoud be equal");
     } onFaild:^(NSException *exception)
     {
         NSLog(@"exception: %@",exception);
     }];
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
