//
//  SEGAppsFlyerIntegration.m
//  AppsFlyerSegmentiOS
//
//  Created by Golan/Maxim Shoustin on 5/17/16.
//  Copyright © 2016 AppsFlyer. All rights reserved.
//

#import "SEGAppsFlyerIntegration.h"
#import <Analytics/SEGAnalyticsUtils.h>
#import "SEGAppsFlyerIntegrationFactory.h"

@implementation SEGAppsFlyerIntegration


- (instancetype)initWithSettings:(NSDictionary *)settings withAnalytics:(SEGAnalytics *)analytics {
    if (self = [super init]) {
        self.settings = settings;
        NSString *afDevKey = [self.settings objectForKey:@"appsFlyerDevKey"];
        NSString *appleAppId = [self.settings objectForKey:@"appleAppID"];
        
        self.appsflyer = [AppsFlyerTracker sharedTracker];
        [self.appsflyer setAppsFlyerDevKey:afDevKey];
        [self.appsflyer setAppleAppID:appleAppId];
        self.analytics = analytics;
        if ([self trackAttributionData]) {
            self.appsflyer.delegate = self;
        }
        //self.appsflyer.isDebug = YES;
    }
    return self;
}


- (instancetype)initWithSettings:(NSDictionary *)settings
                   withAnalytics:(SEGAnalytics *)analytics
                     andDelegate:(id<SEGAppsFlyerTrackerDelegate>) delegate
{
    self.segDelegate = delegate;
    return [self initWithSettings:settings withAnalytics:analytics];
}

- (instancetype)initWithSettings:(NSDictionary *)settings withAppsflyer:(AppsFlyerTracker *)aAppsflyer {
    
    if (self = [super init]) {
        self.settings = settings;
        self.appsflyer = aAppsflyer;
        
        NSString *afDevKey = [self.settings objectForKey:@"appsFlyerDevKey"];
        NSString *appleAppId = [self.settings objectForKey:@"appleAppID"];
        [self.appsflyer setAppsFlyerDevKey:afDevKey];
        [self.appsflyer setAppleAppID:appleAppId];
        
        if ([self trackAttributionData]) {
            self.appsflyer.delegate = self;
        }
        
    }
    return self;
}



-(void) applicationDidBecomeActive {
    [self trackLaunch];
}


- (void)identify:(SEGIdentifyPayload *)payload
{
    NSMutableDictionary *afTraits = [NSMutableDictionary dictionary];
    
    if (payload.userId != nil && [payload.userId length] != 0) {
        
        if ([NSThread isMainThread]) {
            [self.appsflyer setCustomerUserID:payload.userId];
            SEGLog(@"setCustomerUserID:%@]", payload.userId);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.appsflyer setCustomerUserID:payload.userId];
                SEGLog(@"setCustomerUserID:%@]", payload.userId);
            });
        }
    }
    
    if ([payload.traits[@"currencyCode"] isKindOfClass:[NSString class]]) {
        self.appsflyer.currencyCode = payload.traits[@"currencyCode"];
        SEGLog(@"self.appsflyer.currencyCode: %@", payload.traits[@"currencyCode"]);
    }
    
    if ([payload.traits[@"email"] isKindOfClass:[NSString class]]) {
        [afTraits setObject:payload.traits[@"email"] forKey:@"email"];
    }
    
    if ([payload.traits[@"firstName"] isKindOfClass:[NSString class]]) {
        [afTraits setObject:payload.traits[@"firstName"] forKey:@"firstName"];
    }
    
    if ([payload.traits[@"lastName"] isKindOfClass:[NSString class]]) {
        [afTraits setObject:payload.traits[@"lastName"] forKey:@"lastName"];
    }
    
    if ([payload.traits[@"username"] isKindOfClass:[NSString class]]) {
        [afTraits setObject:payload.traits[@"username"] forKey:@"username"];
    }
    
    [self.appsflyer setAdditionalData:afTraits];
    
}

- (void) trackLaunch {
    [self.appsflyer trackAppLaunch];
}


- (void)track:(SEGTrackPayload *)payload
{
    if (payload.properties != nil){
        SEGLog(@"trackEvent: %@", payload.properties);
    }
    
    // Extract the revenue from the properties passed in to us.
    NSNumber *revenue = [SEGAppsFlyerIntegration extractRevenue:payload.properties withKey:@"revenue"];
    if (revenue) {
        // Track purchase event.
        NSDictionary *values = @{AFEventParamRevenue : revenue, AFEventParam1 : payload.properties};
        [self.appsflyer trackEvent:AFEventPurchase withValues:values];
        
    }
    else {
        // Track the raw event.
        [self.appsflyer trackEvent:payload.event withValues:payload.properties];
    }
    
}

+ (NSDecimalNumber *)extractRevenue:(NSDictionary *)dictionary withKey:(NSString *)revenueKey
{
    id revenueProperty = dictionary[revenueKey];
    if (revenueProperty) {
        if ([revenueProperty isKindOfClass:[NSString class]]) {
            return [NSDecimalNumber decimalNumberWithString:revenueProperty];
        } else if ([revenueProperty isKindOfClass:[NSNumber class]]) {
            return revenueProperty;
        }
    }
    return nil;
}

-(void)onConversionDataReceived:(NSDictionary *)installData
{
    
    if(self.segDelegate)
    {
        [self.segDelegate onConversionDataReceived:installData];
    }
    
    NSString *const key = @"AF_Install_Attr_Sent";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL installAttrSent = [userDefaults boolForKey:key];
    
    if(!installAttrSent){
        NSDictionary *campaign = @{
                                   @"source": installData[@"media_source"] ? installData[@"media_source"] : @"",
                                   @"name": installData[@"campaign"] ? installData[@"campaign"] : @"",
                                   @"adGroup": installData[@"adgroup"] ? installData[@"adgroup"] : @""
                                   };
        
        NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithDictionary:@{@"provider": @"AppsFlyer"}];
        [properties addEntriesFromDictionary:installData];
        
        // Delete already mapped special fields.
        [properties removeObjectForKey:@"media_source"];
        [properties removeObjectForKey:@"adgroup"];
        
        // replace original campaign with new created
        [properties removeObjectForKey:@"campaign"];
        [properties setObject:campaign forKey:@"campaign"];
        
        // If you are working with networks that don't allow passing user level data to 3rd parties,
        // you will need to apply code to filter out these networks before calling
        // `[self.analytics track:@"Install Attributed" properties:[properties copy]];`
        [self.analytics track:@"Install Attributed" properties:[properties copy]];
        
        [userDefaults setBool:YES forKey:key];
    }
}

-(void)onConversionDataRequestFailure:(NSError *) error
{
    if(self.segDelegate)
    {
        [self.segDelegate onConversionDataRequestFailure:error];
    }
    SEGLog(@"[Appsflyer] onConversionDataRequestFailure:%@]", error);
}

- (void) onAppOpenAttribution:(NSDictionary*) attributionData
{
    if(self.segDelegate)
    {
        [self.segDelegate onAppOpenAttribution:attributionData];
    }
    SEGLog(@"[Appsflyer] onAppOpenAttribution data: %@", attributionData);
}

- (void) onAppOpenAttributionFailure:(NSError *)error
{
    if(self.segDelegate)
    {
        [self.segDelegate onAppOpenAttributionFailure:error];
    }
    SEGLog(@"[Appsflyer] onAppOpenAttribution failure data: %@", error);
}

- (BOOL)trackAttributionData
{
    return [(NSNumber *)[self.settings objectForKey:@"trackAttributionData"] boolValue];
}

@end
