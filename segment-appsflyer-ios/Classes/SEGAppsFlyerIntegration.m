//
//  SEGAppsFlyerIntegration.m
//  SegmentAppsFlyeriOS
//
//  Created by Golan on 5/2/16.
//  Copyright © 2016 AppsFlyer. All rights reserved.
//

#import "SEGAppsFlyerIntegration.h"
#import "SEGAnalyticsUtils.h"


@implementation SEGAppsFlyerIntegration

+ (void)load
{
    [SEGAnalytics registerIntegration:self withIdentifier:@"AppsFlyer"];
}

#pragma mark - Initialization

- (id)init
{
    if (self = [super init]) {
        self.name = @"Appsflyer";
        self.valid = NO;
        self.initialized = NO;
        self.appsflyer = [AppsFlyerTracker sharedTracker];
    }
    return self;
}


- (instancetype)initWithSettings:(NSDictionary *)settings {
 
    if (self = [super init]) {
        self.settings = settings;
        self.name = @"Appsflyer";
        self.valid = NO;
        self.initialized = NO;
        self.appsflyer = [AppsFlyerTracker sharedTracker];
        NSString *devKey = self.settings[@"devKey"];
        NSString *appleAppId = self.settings[@"appleAppId"];
        
        [self.appsflyer setAppsFlyerDevKey:devKey];
        [self.appsflyer setAppleAppID:appleAppId];

    }
    return self;
}

- (void)start
{
    NSString *devKey = self.settings[@"devKey"];
    NSString *appleAppId = self.settings[@"appleAppId"];
    
    [self.appsflyer setAppsFlyerDevKey:devKey];
    [self.appsflyer setAppleAppID:appleAppId];
    

    SEGLog(@"AppsFyer Start.");
    [super start];
}

#pragma mark - Settings

- (void)validate
{
    BOOL isValid = [self.settings objectForKey:@"devKey"] != nil;
    self.valid = isValid;
}

#pragma mark - Analytics API

- (void)identify:(NSString *)userId traits:(NSDictionary *)traits options:(NSDictionary *)options
{
    if (userId) {
        [self.appsflyer setCustomerUserID:userId];
    }
    
}

- (void)track:(NSString *)event properties:(NSDictionary *)properties options:(NSDictionary *)options
{
    [self.appsflyer trackEvent:event withValues:properties];
}

- (void)screen:(NSString *)screenTitle properties:(NSDictionary *)properties options:(NSDictionary *)options
{
    [self.appsflyer trackEvent:screenTitle withValues:properties];
}

- (void)flush
{
}


#pragma mark - Callbacks for app state changes


- (void)applicationDidBecomeActive
{
    [self.appsflyer trackAppLaunch];
}

@end
