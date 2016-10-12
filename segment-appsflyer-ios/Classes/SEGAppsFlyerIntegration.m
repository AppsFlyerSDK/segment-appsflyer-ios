//
//  SEGAppsFlyerIntegration.m
//  AppsFlyerSegmentiOS
//
//  Created by Golan on 5/17/16.
//  Copyright © 2016 AppsFlyer. All rights reserved.
//

#import "SEGAppsFlyerIntegration.h"
#import <Analytics/SEGAnalyticsUtils.h>

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
    }
    return self;
}

- (instancetype)initWithSettings:(NSDictionary *)settings withAppsflyer:(AppsFlyerTracker *)aAppsflyer {
    
    if (self = [super init]) {
        self.settings = settings;
        self.appsflyer = aAppsflyer;
    }
    return self;
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
        } else if ([revenueProperty isKindOfClass:[NSDecimalNumber class]]) {
            return revenueProperty;
        }
    }
    return nil;
}

-(void)onConversionDataReceived:(NSDictionary *)installData {
      NSDictionary *campaign = @{
                @"source": installData[@"media_source"] ? installData[@"media_source"] : @"",
                @"name": installData[@"campaign"] ? installData[@"campaign"] : @"",
                @"adGroup": installData[@"adgroup"] ? installData[@"adgroup"] : @""
      };

      NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithDictionary:@{
                @"provider": @"AppsFlyer",
                @"campaign": campaign,
      }];
      [properties addEntriesFromDictionary:installData];

      // Delete already mapped special fields.
      [properties removeObjectForKey:@"media_source"];
      [properties removeObjectForKey:@"campagin"];
      [properties removeObjectForKey:@"adgroup"];
      
      [self.analytics track:@"Install Attributed" properties:[properties copy]];
}
                  
-(void)onConversionDataRequestFailure:(NSError *) error {
      SEGLog(@"[Appsflyer] onConversionDataRequestFailure:%@]", error);
}

- (BOOL)trackAttributionData
{
      return [(NSNumber *)[self.settings objectForKey:@"trackAttributionData"] boolValue];
}

@end
