//
//  PSDTOTests.m
//  PSDTOTests
//
//  Created by Tomasz Kwolek on 02.09.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSDTOTests.h"

#import "PSDTO.h"
#import "NSObject+PSDTO.h"
#import "SampleObjectA.h"
#import "SampleObjectB.h"
#import "SampleObjectC.h"

@interface PSDTOTests()

@property (assign,nonatomic) PSDTO *dto;
@property (strong,nonatomic) NSDictionary* sampleA_dict;
@property (strong,nonatomic) NSDictionary* sampleB_dict;
@property (strong,nonatomic) NSDictionary* sampleC_dict;

@end

@implementation PSDTOTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    self.dto = [PSDTO sharedInstance];
    [_dto addDestinationObject:[SampleObjectA class]];
    [_dto addDestinationObject:[SampleObjectB class]];
    [_dto addDestinationObject:[SampleObjectC class]];
    
    
    self.sampleA_dict = @{ @"name" : @"Pastez",
                           @"age" : @27,
                           @"isMale" : [NSNumber numberWithBool:YES],
                           @"childrens" : @[@"jas",@"malgosia",@"dupa"]};
    
    self.sampleB_dict = @{ @"someKey" : @"someValue",
                           @"dict" : @{@"key": @"value"}};
    
    self.sampleC_dict = @{@"objectA": _sampleA_dict,
                          @"objectB": _sampleB_dict};
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCreatingPSDTO
{
    
    STAssertNotNil(_dto, @"assigning dto fail");
    STAssertEqualObjects(_dto, [PSDTO sharedInstance], @"only one instance should be created");
}

- (void)testAddingDestinations
{
    int destinationsCount = _dto.posibleDestinationObjects.count;
    
    [_dto addDestinationObject:[PSDTOTests class]];
    destinationsCount++;
    STAssertTrue(_dto.posibleDestinationObjects.count == destinationsCount, @"destinations wasn't added");
    
    [_dto removeDestinationObject:[PSDTOTests class]];
    destinationsCount--;
    STAssertTrue(_dto.posibleDestinationObjects.count == destinationsCount, @"destination wasn't removed");
}

- (void)testIfParsingIsPossible
{
    STAssertFalse([_dto canParseDictionary:_sampleA_dict toObjectOfKind:[SampleObjectB class]], @"parsing shouldn't be possible");
    STAssertFalse([_dto canParseDictionary:_sampleA_dict toObjectOfKind:[SampleObjectC class]], @"parsing shouldn't be possible");
    
    STAssertFalse([_dto canParseDictionary:_sampleB_dict toObjectOfKind:[SampleObjectA class]], @"parsing shouldn't be possible");
    STAssertFalse([_dto canParseDictionary:_sampleB_dict toObjectOfKind:[SampleObjectC class]], @"parsing shouldn't be possible");
    
    STAssertFalse([_dto canParseDictionary:_sampleC_dict toObjectOfKind:[SampleObjectA class]], @"parsing shouldn't be possible");
    STAssertFalse([_dto canParseDictionary:_sampleC_dict toObjectOfKind:[SampleObjectB class]], @"parsing shouldn't be possible");
    
    STAssertTrue([_dto canParseDictionary:_sampleA_dict toObjectOfKind:[SampleObjectA class]], @"parse shoud be possible");
    STAssertTrue([_dto canParseDictionary:_sampleB_dict toObjectOfKind:[SampleObjectB class]], @"parse shoud be possible");
    STAssertTrue([_dto canParseDictionary:_sampleC_dict toObjectOfKind:[SampleObjectC class]], @"parse shoud be possible");
}

- (void)testParsingA
{
    SampleObjectA *a = [SampleObjectA createWithPropertyListRepresentation:_sampleA_dict];
    STAssertNotNil(a, @"object creation fail");
    NSDictionary *aDictionary = [a propertyListRepresentation];
    STAssertNotNil(aDictionary, @"property list shoud exist");
    STAssertTrue([aDictionary isEqualToDictionary:_sampleA_dict], @"dictionary shoud be equal to sampleA_dict");
}

- (void)testParsingC
{
    SampleObjectC *c = [SampleObjectC createWithPropertyListRepresentation:_sampleC_dict];
    STAssertNotNil(c, @"object creation fail");
    NSDictionary *cDictionary = [c propertyListRepresentation];
    STAssertNotNil(cDictionary, @"property list shoud exist");
    STAssertTrue([cDictionary isEqualToDictionary:_sampleC_dict], @"dictionary shoud be equal to sampleA_dict");
}

- (void)testMagicParsing
{
    NSDictionary __block *aDict;
    NSDictionary __block *bDict;
    NSDictionary __block *cDict;
    [_dto parseDictionary:_sampleA_dict onComplete:^(id object) {
        STAssertTrue([object isKindOfClass:[SampleObjectA class]], @"object shoud be kind of SampleObjectA");
        aDict = [object propertyListRepresentation];
        
        [_dto parseDictionary:_sampleB_dict onComplete:^(id object) {
            STAssertTrue([object isKindOfClass:[SampleObjectB class]], @"object shoud be kind of SampleObjectB");
            bDict = [object propertyListRepresentation];
            cDict = @{@"objectA": aDict,
                      @"objectB": bDict};
            
            [_dto parseDictionary:cDict onComplete:^(id object) {
                STAssertTrue([object isKindOfClass:[SampleObjectC class]], @"object shoud be kind of SampleObjectC");
                cDict = [object propertyListRepresentation];
                STAssertTrue([cDict isEqualToDictionary:_sampleC_dict], @"dictionary shoud be equal to sampleA_dict");
                
                
            } onFaild:^(NSException *exception) {
                STAssertNil(exception, @"exception (%@) shoud not occur parsing sample C", exception);
            }];
            
        } onFaild:^(NSException *exception) {
            STAssertNil(exception, @"exception (%@) shoud not occurm parsing sample B", exception);
        }];
        
    } onFaild:^(NSException *exception) {
        STAssertNil(exception, @"exception (%@) shoud not occur parsing sample A", exception);
    }];
    
    
    
    
}

@end
