//
//  SEGAppsFlyerIntegrationTests.m
//  SegmentAppsFlyeriOSTests
//
//  Created by Moris Gateno on 27/12/2022.
//  Copyright © 2022 Andrii Hahan. All rights reserved.
//

#import <XCTest/XCTest.h>
@import SegmentAppsFlyeriOS;
@import OCMock;

@interface SEGAppsFlyerIntegration()
+ (NSDecimalNumber *)extractRevenue:(NSDictionary *)dictionary withKey:(NSString *)revenueKey;
+ (NSString *)extractCurrency:(NSDictionary *)dictionary withKey:(NSString *)currencyKey;
- (void)track:(SEGTrackPayload *)payload;
- (void)onConversionDataSuccess:(nonnull NSDictionary *)conversionInfo;
- (instancetype)initWithSettings:(NSDictionary *)settings withAppsflyer:(AppsFlyerLib *)aAppsflyer;
+(NSString *) validateNil: (NSString *) value;
- (AppsFlyerLib *)appsflyerLib;
@end

@interface AppsFlyerLib()
@property(nonatomic) NSString *customDataString;
@end

@interface NSDictionary (Stringify)

- (NSString *)afsdk_stringify;

@end

@interface SEGAppsFlyerIntegrationTests : XCTestCase

@end

@implementation SEGAppsFlyerIntegrationTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}
//
//initWithSettings
//
//struct SEGAppsFlyerIntegration_initWithSettings_testCases{
//    NSDictionary * dictionaryInput;
//    NSMutableArray *boolExpectedArray;
//}SEGAppsFlyerIntegration_initWithSettings_testCases;

- (void)testSEGAppsFlyerIntegration_initWithSettings_happyFlow{
    NSDictionary * dictionaryInput = @{@"appsFlyerDevKey" : @"devKey",
                                       @"appleAppID" : @"appID",
                                       @"trackAttributionData" : @"123",
    };
    SEGAppsFlyerIntegration *integrationObject = [[SEGAppsFlyerIntegration alloc] initWithSettings:dictionaryInput withAnalytics:[[SEGAnalytics alloc] init] ];
    XCTAssertNotNil([integrationObject analytics]);
    AppsFlyerLib *appsflyerObject = [integrationObject appsflyer];
    XCTAssertNotNil(appsflyerObject);
    XCTAssertTrue([[appsflyerObject appsFlyerDevKey] isEqual:@"devKey"]);
    XCTAssertTrue([[appsflyerObject appleAppID] isEqual:@"appID"]);
    XCTAssertNotNil([appsflyerObject delegate]);
    XCTAssertNil([appsflyerObject deepLinkDelegate]);
    XCTAssertNil([integrationObject segDelegate]);
    XCTAssertNil([integrationObject segDLDelegate]);
    XCTAssertFalse([integrationObject manualMode]);
}

- (void)testSEGAppsFlyerIntegration_initWithSettings_nilFlow_noDevKey{
    NSDictionary * dictionaryInput = @{@"appleAppID" : @"appID",
                                       @"trackAttributionData" : @"123",
    };
    AppsFlyerLib * appsFlyerObject = [AppsFlyerLib new];
    SEGAppsFlyerIntegration * SEGAppsFlyerIntegrationObject = [SEGAppsFlyerIntegration new];
    id SEGAppsFlyerIntegrationMock = OCMPartialMock(SEGAppsFlyerIntegrationObject);
    OCMStub([SEGAppsFlyerIntegrationMock appsflyerLib]).andReturn(appsFlyerObject);
    SEGAppsFlyerIntegration * integrationObject = [SEGAppsFlyerIntegrationMock initWithSettings:dictionaryInput withAnalytics:nil];
    AppsFlyerLib *appsflyerObject = [integrationObject appsflyer];
    XCTAssertNotNil(appsflyerObject);
    XCTAssertTrue([[appsflyerObject appsFlyerDevKey] isEqual:@""]);
}

- (void)testSEGAppsFlyerIntegration_initWithSettings_nilFlow_noAppleID{
    NSDictionary * dictionaryInput = @{@"appsFlyerDevKey" : @"devKey",
                                       @"trackAttributionData" : @"123",
    };
    AppsFlyerLib * appsFlyerObject = [AppsFlyerLib new];
    SEGAppsFlyerIntegration * SEGAppsFlyerIntegrationObject = [SEGAppsFlyerIntegration new];
    id SEGAppsFlyerIntegrationMock = OCMPartialMock(SEGAppsFlyerIntegrationObject);
    OCMStub([SEGAppsFlyerIntegrationMock appsflyerLib]).andReturn(appsFlyerObject);
    
    SEGAppsFlyerIntegration *integrationObject = [SEGAppsFlyerIntegrationMock initWithSettings:dictionaryInput withAnalytics:nil];
    AppsFlyerLib *appsflyerObject = [integrationObject appsflyer];
    XCTAssertNotNil(appsflyerObject);
    XCTAssertTrue([[appsflyerObject appleAppID] isEqual:@""]);
}

-(void)testSEGAppsFlyerIntegration_initWithSettings_nilFlow_noTrackingAttributionData{
    NSDictionary * dictionaryInput = @{@"appsFlyerDevKey" : @"devKey",
                                       @"appleAppID" : @"appID"
    };
    AppsFlyerLib * appsFlyerObject = [AppsFlyerLib new];
    SEGAppsFlyerIntegration * SEGAppsFlyerIntegrationObject = [SEGAppsFlyerIntegration new];
    id SEGAppsFlyerIntegrationMock = OCMPartialMock(SEGAppsFlyerIntegrationObject);
    OCMStub([SEGAppsFlyerIntegrationMock appsflyerLib]).andReturn(appsFlyerObject);
    
    SEGAppsFlyerIntegration *integrationObject = [SEGAppsFlyerIntegrationMock initWithSettings:dictionaryInput withAnalytics:nil];
    AppsFlyerLib *appsflyerObject = [integrationObject appsflyer];
    XCTAssertNotNil(appsflyerObject);
    XCTAssertNil([appsflyerObject delegate]);
}

-(void)testSEGAppsFlyerIntegration_initWithSettings_nilFlow_nilSettings{
    AppsFlyerLib * appsFlyerObject = OCMClassMock([AppsFlyerLib class]);
    SEGAppsFlyerIntegration * SEGAppsFlyerIntegrationObject = [SEGAppsFlyerIntegration new];
    id SEGAppsFlyerIntegrationMock = OCMPartialMock(SEGAppsFlyerIntegrationObject);
    OCMStub([SEGAppsFlyerIntegrationMock appsflyerLib]).andReturn(appsFlyerObject);
    
    NSDictionary * dictionaryInput = nil;
    SEGAppsFlyerIntegration *integrationObject = [SEGAppsFlyerIntegrationObject initWithSettings:dictionaryInput withAnalytics:nil];
    AppsFlyerLib *appsflyerObject = [integrationObject appsflyer];
    XCTAssertNotNil(appsflyerObject);
    XCTAssertNil([appsflyerObject delegate]);
}


- (void)testSEGAppsFlyerIntegration_initWithSettings_negativeFlow_devKeyIsANumber{
    NSDictionary * dictionaryInput = @{@"appsFlyerDevKey" : @(123),
                                       @"appleAppID" : @"appID",
                                       @"trackAttributionData" : @"123"
    };
    
    AppsFlyerLib * appsFlyerObject = [AppsFlyerLib new];;
    SEGAppsFlyerIntegration * SEGAppsFlyerIntegrationObject = [SEGAppsFlyerIntegration new];
    id SEGAppsFlyerIntegrationMock = OCMPartialMock(SEGAppsFlyerIntegrationObject);
    OCMStub([SEGAppsFlyerIntegrationMock appsflyerLib]).andReturn(appsFlyerObject);
    
    SEGAppsFlyerIntegration *integrationObject = [SEGAppsFlyerIntegrationMock initWithSettings:dictionaryInput withAnalytics:nil];
    AppsFlyerLib *appsflyerObject = [integrationObject appsflyer];
    XCTAssertNotNil(appsflyerObject);
    XCTAssertNotNil([appsflyerObject delegate]);
}


//
//initWithSettings andDelegate
//
- (void)testSEGAppsFlyerIntegration_initWithSettingsAndDelegate_happyFlow{
    
    SEGAppsFlyerIntegration *integrationObject = [[SEGAppsFlyerIntegration alloc] initWithSettings:nil withAnalytics:nil andDelegate:self];
    XCTAssertNotNil([integrationObject segDelegate]);
    XCTAssertTrue([[integrationObject segDelegate] isEqual:self]);
}

- (void)testSEGAppsFlyerIntegration_initWithSettingsAndDelegate_nilFlow{
    SEGAppsFlyerIntegration *integrationObject = [[SEGAppsFlyerIntegration alloc] initWithSettings:nil withAnalytics:nil andDelegate:nil];
    XCTAssertNil([integrationObject segDelegate]);
}

//
//initWithSettings andDelegate andDeepLinkDelegate andManualMode
//
- (void)testSEGAppsFlyerIntegration_initWithSettingsAndDelegateandDeepLinkDelegateandManualMode_happyFlow{
    
    SEGAppsFlyerIntegration *integrationObject = [[SEGAppsFlyerIntegration alloc] initWithSettings:nil withAnalytics:nil andDelegate:self andDeepLinkDelegate:self andManualMode:false];
    XCTAssertNotNil([integrationObject segDelegate]);
    XCTAssertTrue([[integrationObject segDelegate] isEqual:self]);
    XCTAssertNotNil([integrationObject segDLDelegate]);
    XCTAssertTrue([[integrationObject segDLDelegate] isEqual:self]);
    XCTAssertFalse([integrationObject manualMode]);
    integrationObject = [[SEGAppsFlyerIntegration alloc] initWithSettings:nil withAnalytics:nil andDelegate:nil andDeepLinkDelegate:self andManualMode:true];
    XCTAssertTrue([integrationObject manualMode]);
}

- (void)testSEGAppsFlyerIntegration_initWithSettingsAndDelegateandDeepLinkDelegateandManualMode_nilFlow{
    
    SEGAppsFlyerIntegration *integrationObject = [[SEGAppsFlyerIntegration alloc] initWithSettings:nil withAnalytics:nil andDelegate:nil andDeepLinkDelegate:nil andManualMode:nil];
    XCTAssertNil([integrationObject segDLDelegate]);
    XCTAssertNil([integrationObject segDelegate]);
    XCTAssertFalse([integrationObject manualMode]);
}

//
//initWithSettings andDelegate aAppsflyer
//
- (void)testSEGAppsFlyerIntegration_initWithSettingsaAppsflyer_happyFlow{
    NSDictionary * dictionaryInput = @{@"appsFlyerDevKey" : @"devKey",
                                       @"appleAppID" : @"appID",
                                       @"trackAttributionData" : @"123",
    };
    AppsFlyerLib * appsFlyerObject =[[AppsFlyerLib alloc] init];
    SEGAppsFlyerIntegration *integrationObject = [[SEGAppsFlyerIntegration alloc] initWithSettings:dictionaryInput withAppsflyer:appsFlyerObject];
    XCTAssertTrue([[[integrationObject appsflyer] appsFlyerDevKey] isEqual:@"devKey"]);
    XCTAssertTrue([[[integrationObject appsflyer] appleAppID] isEqual:@"appID"]);
    XCTAssertNotNil([[integrationObject appsflyer] delegate]);
    XCTAssertTrue([[[integrationObject appsflyer] delegate] isEqual:integrationObject]);
    XCTAssertNil([[integrationObject appsflyer] deepLinkDelegate]);
}

- (void)testSEGAppsFlyerIntegration_initWithSettingsaAppsflyer_nilFlow{
    SEGAppsFlyerIntegration *integrationObject = [[SEGAppsFlyerIntegration alloc] initWithSettings:nil withAppsflyer:nil];
    XCTAssertNil([integrationObject appsflyer]);
    XCTAssertNil([integrationObject settings]);
}

//
// identify
//

-(void)testSEGAppsFlyerIntegration_identify_happyFlow{
    NSDictionary * settings = @{@"appsFlyerDevKey" : @"devKey",
                                       @"appleAppID" : @"appID",
                                       @"trackAttributionData" : @"123",
    };
    SEGAppsFlyerIntegration *integrationObject = [[SEGAppsFlyerIntegration alloc] initWithSettings:settings withAnalytics:nil];
    NSMutableDictionary * traits = @{@"email":@"moris@apps.com", @"firstName":@"Moris", @"lastName":@"Gateno", @"username":@"moris98",  @"currencyCode":@"1312"};
    SEGIdentifyPayload * payload = [[SEGIdentifyPayload alloc] initWithUserId:@"moris" anonymousId:nil traits:traits context:@{} integrations:@{}];
    [integrationObject identify:payload];
    XCTAssertTrue([[[integrationObject appsflyer] currencyCode] isEqual:@"1312"]);
    XCTAssertTrue([[[integrationObject appsflyer] customerUserID] isEqual:@"moris"]);
    NSString * customData = [[integrationObject appsflyer] customDataString];

    NSString * stringified = [@{@"email":@"moris@apps.com", @"firstName":@"Moris", @"lastName":@"Gateno", @"username":@"moris98"} afsdk_stringify];
    XCTAssertTrue([stringified isEqual:customData]);
}

-(void)testSEGAppsFlyerIntegration_identify_nilFlow{
    NSDictionary * settings = @{@"appsFlyerDevKey" : @"devKey",
                                       @"appleAppID" : @"appID",
                                       @"trackAttributionData" : @"123",
    };
    AppsFlyerLib * appsFlyerObject = [AppsFlyerLib new];
    SEGAppsFlyerIntegration * SEGAppsFlyerIntegrationObject = [SEGAppsFlyerIntegration new];
    id SEGAppsFlyerIntegrationMock = OCMPartialMock(SEGAppsFlyerIntegrationObject);
    OCMStub([SEGAppsFlyerIntegrationMock appsflyerLib]).andReturn(appsFlyerObject);
    SEGAppsFlyerIntegration *integrationObject = [SEGAppsFlyerIntegrationMock initWithSettings:settings withAnalytics:nil];
    NSMutableDictionary * traits = nil;
    SEGIdentifyPayload * payload = [[SEGIdentifyPayload alloc] initWithUserId:nil anonymousId:nil traits:traits context:nil integrations:nil];
    [integrationObject identify:payload];
    NSString * customerUserID = [[integrationObject appsflyer] customerUserID];
    NSString * customData = [[integrationObject appsflyer] customDataString];
    XCTAssertNil([[integrationObject appsflyer] currencyCode]);
    XCTAssertNil([[integrationObject appsflyer] customerUserID]);
    XCTAssertTrue([customData isEqual:@"{}"]);
    XCTAssertNil(customerUserID);
}

//
//track
//
- (void)testSEGAppsFlyerIntegration_track_happyFlow_withCurrencyAndRevenue{
    id appsFlyerMock = OCMClassMock([AppsFlyerLib class]);
    OCMStub([appsFlyerMock logEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertTrue([obj isEqual:@"testEvent"]);
        return YES;
    }] withValues:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertTrue([obj[@"af_currency"] isEqual: @"ILS"]);
        XCTAssertTrue([obj[@"af_revenue"] isEqual: @(10.1)]);
        XCTAssertTrue([obj[@"currency"] isEqual: @"ILS"]);
        XCTAssertTrue([obj[@"revenue"] isEqual: @"10.1"]);
        return YES;
    }]]);
    SEGAppsFlyerIntegration *integrationObject = [[SEGAppsFlyerIntegration alloc] init];
    [integrationObject setAppsflyer: appsFlyerMock];
    NSMutableDictionary * dictionary = @{@"revenue" : @"10.1", @"currency" : @"ILS"};
    SEGTrackPayload * payload = [[SEGTrackPayload alloc] initWithEvent:@"testEvent" properties: dictionary context:@{} integrations:@{}];
    [integrationObject track:payload];
    [appsFlyerMock stopMocking];
}

-(void)testSEGAppsFlyerIntegration_track_nilFlow{
    id appsFlyerMock = OCMClassMock([AppsFlyerLib class]);
    OCMStub([appsFlyerMock logEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertNil(obj);
        return YES;
    }] withValues:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertNil(obj);
        return YES;
    }]]);
    SEGAppsFlyerIntegration *integrationObject = [[SEGAppsFlyerIntegration alloc] init];
    [integrationObject setAppsflyer: appsFlyerMock];
    SEGTrackPayload * payload = [[SEGTrackPayload alloc] initWithEvent:nil properties: nil context:@{} integrations:@{}];
    [integrationObject track:payload];
    [appsFlyerMock stopMocking];
}

-(void)testSEGAppsFlyerIntegration_track_negativeFlow_numberAsKeyWhenWhileLogEventExpectsString{
    id appsFlyerMock = OCMClassMock([AppsFlyerLib class]);
    OCMStub([appsFlyerMock logEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertNil(obj);
        return YES;
    }] withValues:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertNotNil(obj);
        XCTAssertTrue([[[obj allKeys] objectAtIndex:0] isKindOfClass:[NSNumber class]]);
        return YES;
    }]]);
    SEGAppsFlyerIntegration *integrationObject = [[SEGAppsFlyerIntegration alloc] init];
    [integrationObject setAppsflyer: appsFlyerMock];
    NSMutableDictionary * dictionary = @{@(10):@(11)};
    SEGTrackPayload * payload = [[SEGTrackPayload alloc] initWithEvent:nil properties: dictionary context:@{} integrations:@{}];
    [integrationObject track:payload];
    [appsFlyerMock stopMocking];
}

//
//extractCurrency
//
- (void)testSEGAppsFlyerIntegration_extractCurrency_happyFlow_stringInput {
    NSDictionary * dictionaryInput = @{ @"key" : @"ILS"};
    NSString * outputCurrency = [SEGAppsFlyerIntegration extractCurrency:dictionaryInput withKey:@"key"];
    XCTAssertTrue([dictionaryInput[@"key"] isEqual:outputCurrency] );
}

- (void)testSEGAppsFlyerIntegration_extractCurrency_nilflow {
    NSDictionary * dictionaryInput = @{ @"key" : [NSNull null]};
    NSString * outputCurrency = [SEGAppsFlyerIntegration extractCurrency:dictionaryInput withKey:@"key"];
    XCTAssertFalse([dictionaryInput[@"key"] isEqual:outputCurrency]);
    XCTAssertTrue([outputCurrency isEqual:@"USD"]);
    dictionaryInput = @{};
    outputCurrency = [SEGAppsFlyerIntegration extractCurrency:dictionaryInput withKey:@"key"];
    XCTAssertTrue([outputCurrency isEqual:@"USD"]);
}

- (void)testSEGAppsFlyerIntegration_extractCurrency_negativeflow_keyNotExists {
    NSDictionary * dictionaryInput = @{ @"key" : @"ILS"};
    NSString * outputCurrency = [SEGAppsFlyerIntegration extractCurrency:dictionaryInput withKey:@"key2"];
    XCTAssertFalse([dictionaryInput[@"key"] isEqual:outputCurrency]);
    XCTAssertTrue([outputCurrency isEqual:@"USD"]);
}

- (void)testSEGAppsFlyerIntegration_extractCurrency_negativeFlow_intInput {
    NSDictionary * dictionaryInput = @{ @"key" : @(12.0)};
    NSString * outputCurrency = [SEGAppsFlyerIntegration extractCurrency:dictionaryInput withKey:@"key"];
    XCTAssertNotEqual(dictionaryInput[@"key"], outputCurrency);
    XCTAssertTrue([outputCurrency isEqual:@"USD"]);
}


//
//extractRevenue
//
- (void)testSEGAppsFlyerIntegration_extractRevenue_happyFlow_stringInput {
    NSDictionary * dictionaryInput = @{ @"key" : @"12.1"};
    NSDecimalNumber * outputRevenue = [SEGAppsFlyerIntegration extractRevenue:dictionaryInput withKey:@"key"];
    XCTAssertTrue([outputRevenue isEqual:@(12.1)]);
}

- (void)testSEGAppsFlyerIntegration_extractRevenue_happyFlow_numberInput {
    NSDictionary * dictionaryInput = @{@"key" : @(12.1)};
    NSDecimalNumber * outputRevenue = [SEGAppsFlyerIntegration extractRevenue:dictionaryInput withKey:@"key"];
    XCTAssertTrue([outputRevenue isEqual:@(12.1)]);
}

- (void)testSEGAppsFlyerIntegration_extractRevenue_nilFlow_valueNilForKey {
    NSDictionary * dictionaryInput = @{@"key" : [NSNull null]};
    NSDecimalNumber * outputRevenue = [SEGAppsFlyerIntegration extractRevenue:dictionaryInput withKey:@"key"];
    //    XCTAssertTrue([outputRevenue isEqual:@(12.1)]);
    XCTAssertNil(outputRevenue);
}

- (void)testSEGAppsFlyerIntegration_extractRevenue_nilFlow_nilForDictionary {
    NSDictionary * dictionaryInput = nil;
    NSDecimalNumber * outputRevenue = [SEGAppsFlyerIntegration extractRevenue:dictionaryInput withKey:@"key"];
    //    XCTAssertTrue([outputRevenue isEqual:@(12.1)]);
    XCTAssertNil(outputRevenue);
}

- (void)testSEGAppsFlyerIntegration_extractRevenue_negativeFlow_missingKey {
    NSDictionary * dictionaryInput = @{};
    NSDecimalNumber * outputRevenue = [SEGAppsFlyerIntegration extractRevenue:dictionaryInput withKey:@"key"];
    //    XCTAssertTrue([outputRevenue isEqual:@(12.1)]);
    XCTAssertNil(outputRevenue);
}

- (void)testSEGAppsFlyerIntegration_extractRevenue_negativeFlow_stringNotNumber {
    NSDictionary * dictionaryInput = @{@"key" : @"moris"};
    NSDecimalNumber * outputRevenue = [SEGAppsFlyerIntegration extractRevenue:dictionaryInput withKey:@"key"];
    XCTAssertTrue(isnan(outputRevenue.doubleValue));
}

- (void)testSEGAppsFlyerIntegration_extractRevenue_negativeFlow_keyNotExists {
    NSDictionary * dictionaryInput = @{@"key" : @"moris"};
    NSDecimalNumber * outputRevenue = [SEGAppsFlyerIntegration extractRevenue:dictionaryInput withKey:@"key1"];
    XCTAssertNil(outputRevenue);
}

//
//validateNil
//
- (void)testSEGAppsFlyerIntegration_validateNil_happyFlow_withString {
    NSString * outputValidateNil = [SEGAppsFlyerIntegration validateNil:@"moris"];
    XCTAssertTrue([outputValidateNil isEqual:@"moris"]);
}

- (void)testSEGAppsFlyerIntegration_validateNil_happyFlow_withNil {
    NSString * outputValidateNil = [SEGAppsFlyerIntegration validateNil:nil];
    XCTAssertTrue([outputValidateNil isEqual:@""]);
    outputValidateNil = [SEGAppsFlyerIntegration validateNil:[NSNull null]];
    XCTAssertTrue([outputValidateNil isEqual:@""]);
}

- (void)testSEGAppsFlyerIntegration_validateNil_negativeFlow {
    NSString * outputValidateNil = [SEGAppsFlyerIntegration validateNil:@(10.0)];
    XCTAssertTrue([outputValidateNil isEqual:@(10.0)]);
}

//
// onConversionDataSuccess
//
- (void)onConversionDataSuccess:(NSDictionary *)conversionInfo{
    
}

- (void)testSEGAppsFlyerIntegration_onConversionDataSuccess_happyflow{
    NSDictionary * dictionaryInputToAnalytics = @{@"campaign":@{@"ad_group":@"appsflyer",
                                                               @"name":@"gateno",
                                                               @"source":@"moris"},
                                                 @"provider":@"AppsFlyer"
    };
    NSDictionary * dictionaryInputAsParmeter = @{@"media_source":@"moris",
                                       @"campaign":@"gateno",
                                       @"adgroup":@"appsflyer"
    };
    id SEGAnalyticsMock = OCMClassMock([SEGAnalytics class]);
    id SEGAppsFlyerIntegrationTestsMock = OCMClassMock([SEGAppsFlyerIntegrationTests class]);
    OCMStub([SEGAppsFlyerIntegrationTestsMock onConversionDataSuccess:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertTrue([dictionaryInputAsParmeter isEqualToDictionary:obj]);
        return YES;
    }]]);
    OCMStub([SEGAnalyticsMock track:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertTrue([obj isEqual:@"Install Attributed"]);
        return YES;
    }] properties:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertTrue([obj isEqualToDictionary:dictionaryInputToAnalytics]);
        return YES;
    }]]);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:@"AF_Install_Attr_Sent"];
    SEGAppsFlyerIntegration *integrationObject = [[SEGAppsFlyerIntegration alloc] initWithSettings:@{} withAnalytics:SEGAnalyticsMock andDelegate:SEGAppsFlyerIntegrationTestsMock];

    [integrationObject onConversionDataSuccess:dictionaryInputAsParmeter];
    XCTAssertTrue([userDefaults boolForKey:@"AF_Install_Attr_Sent"]);
    
    [SEGAnalyticsMock stopMocking];
    [SEGAppsFlyerIntegrationTestsMock stopMocking];
}

- (void)testSEGAppsFlyerIntegration_onConversionDataSuccess_negativeflow{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    SEGAnalytics * SEGAnalyticsObject = [SEGAnalytics new];
    id SEGAnalyticsMock = OCMPartialMock(SEGAnalyticsObject);
    id SEGAppsFlyerIntegrationMock = OCMPartialMock(self);
    OCMReject([SEGAppsFlyerIntegrationMock onConversionDataSuccess:[OCMArg any]]);
    OCMReject([SEGAnalyticsMock track:[OCMArg any] properties:[OCMArg any]]);
    [userDefaults setBool:YES forKey:@"AF_Install_Attr_Sent"];
    
    SEGAppsFlyerIntegration *integrationObject = [[SEGAppsFlyerIntegration alloc] initWithSettings:@{} withAnalytics:SEGAnalyticsMock andDelegate:SEGAppsFlyerIntegrationMock];
    
    [integrationObject onConversionDataSuccess:@{}];
    
    [SEGAnalyticsMock verify];
    [SEGAppsFlyerIntegrationMock verify];
    [SEGAnalyticsMock stopMocking];
    [SEGAppsFlyerIntegrationMock stopMocking];
}

//
// onConversionDataFail
//
- (void)onConversionDataFail:(NSError *)error{
    
}
- (void)testSEGAppsFlyerIntegration_onConversionDataFail_happyflow{
    NSError * error = [NSError new];
    id SEGAppsFlyerIntegrationTestsMock = OCMClassMock([SEGAppsFlyerIntegrationTests class]);
    OCMStub([SEGAppsFlyerIntegrationTestsMock onConversionDataFail:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertTrue([obj isEqual:error]);
    }]]);
    
    SEGAppsFlyerIntegration *integrationObject = [[SEGAppsFlyerIntegration alloc] initWithSettings:@{} withAnalytics:nil andDelegate:SEGAppsFlyerIntegrationTestsMock];
    [integrationObject onConversionDataFail:error];
    [SEGAppsFlyerIntegrationTestsMock stopMocking];
}

//
// onConversionDataFail
//
- (void)onAppOpenAttribution:(NSDictionary *)attributionData{
    
}
- (void)testSEGAppsFlyerIntegration_onAppOpenAttribution_happyflow{
    NSDictionary * attributionData = @{@"key":@"value"};
    id SEGAppsFlyerIntegrationTestsMock = OCMClassMock([SEGAppsFlyerIntegrationTests class]);
    OCMStub([SEGAppsFlyerIntegrationTestsMock onAppOpenAttribution:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertTrue([obj isEqualToDictionary:attributionData]);
    }]]);
    
    SEGAppsFlyerIntegration *integrationObject = [[SEGAppsFlyerIntegration alloc] initWithSettings:@{} withAnalytics:nil andDelegate:SEGAppsFlyerIntegrationTestsMock];
    [integrationObject onAppOpenAttribution:attributionData];
    [SEGAppsFlyerIntegrationTestsMock stopMocking];
}

//
// onConversionDataFail
//
- (void)onAppOpenAttributionFailure:(NSError *)error{
    
}
- (void)testSEGAppsFlyerIntegration_onAppOpenAttributionFailure_happyflow{
    NSError * error = [NSError new];
    id SEGAppsFlyerIntegrationTestsMock = OCMClassMock([SEGAppsFlyerIntegrationTests class]);
    OCMStub([SEGAppsFlyerIntegrationTestsMock onAppOpenAttribution:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertTrue([obj isEqual:error]);
    }]]);
    
    SEGAppsFlyerIntegration *integrationObject = [[SEGAppsFlyerIntegration alloc] initWithSettings:@{} withAnalytics:nil andDelegate:SEGAppsFlyerIntegrationTestsMock];
    [integrationObject onAppOpenAttribution:error];
    [SEGAppsFlyerIntegrationTestsMock stopMocking];
}

//
// onConversionDataFail
//
- (void)didResolveDeepLink:(AppsFlyerDeepLinkResult *_Nonnull)result{
    
}
- (void)testSEGAppsFlyerIntegration_didResolveDeepLink_happyflow{
    AppsFlyerDeepLinkResult * result = [AppsFlyerDeepLinkResult alloc];
    id SEGAppsFlyerIntegrationTestsMock = OCMClassMock([SEGAppsFlyerIntegrationTests class]);
    OCMStub([SEGAppsFlyerIntegrationTestsMock onAppOpenAttribution:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertTrue([obj isEqual:result]);
    }]]);
    
    SEGAppsFlyerIntegration *integrationObject = [[SEGAppsFlyerIntegration alloc] initWithSettings:@{} withAnalytics:nil andDelegate:SEGAppsFlyerIntegrationTestsMock];
    [integrationObject onAppOpenAttribution:result];
    [SEGAppsFlyerIntegrationTestsMock stopMocking];
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
