//
//  SEGAppsFlyerIntegration.m
//  AppsFlyerSegmentiOS
//
//  Created by Margot Guetta/Maxim Shoustin on 5/17/16.
//  Copyright © 2016 AppsFlyer. All rights reserved.
//

#import "SEGAppsFlyerIntegration.h"
#import "SEGAppsFlyerIntegrationFactory.h"

@implementation SEGAppsFlyerIntegration


- (instancetype)initWithSettings:(NSDictionary *)settings withAnalytics:(SEGAnalytics *)analytics {
    if (self = [super init]) {
        self.settings = settings;
        NSString *afDevKey = [self.settings objectForKey:@"appsFlyerDevKey"];
        NSString *appleAppId = [self.settings objectForKey:@"appleAppID"];
        
        self.appsflyer = [AppsFlyerLib shared];
        [self.appsflyer setAppsFlyerDevKey:afDevKey];
        [self.appsflyer setAppleAppID:appleAppId];
        //self.appsflyer.isDebug = true;

        self.analytics = analytics;
        if ([self logAttributionData]) {
            self.appsflyer.delegate = self;
        }
        if (_segDLDelegate)
            self.appsflyer.deepLinkDelegate = self;
        
        // For Segment React Native. We should call our applicationDidBecomeActive in case we were initialized too late and missed the first launch
        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL alreadyActive = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
            // for regular Segment integration alreadyActive should always be false
            if (alreadyActive) {
                [self applicationDidBecomeActive];
                NSLog(@"Segment React Native AppsFlye rintegration is used, sending first launch manually");
            }
        });
    }
    return self;
}


- (instancetype)initWithSettings:(NSDictionary *)settings
                   withAnalytics:(SEGAnalytics *)analytics
                     andDelegate:(id<SEGAppsFlyerLibDelegate>) delegate
{
    self.segDelegate = delegate;
    return [self initWithSettings:settings withAnalytics:analytics];
}

- (instancetype)initWithSettings:(NSDictionary *)settings
                   withAnalytics:(SEGAnalytics *)analytics
                     andDelegate:(id<SEGAppsFlyerLibDelegate>) delegate
                    andDeepLinkDelegate:(id<AppsFlyerDeepLinkDelegate>)DLDelegate
{
    self.segDelegate = delegate;
    self.segDLDelegate = DLDelegate;
    return [self initWithSettings:settings withAnalytics:analytics];
}

- (instancetype)initWithSettings:(NSDictionary *)settings withAppsflyer:(AppsFlyerLib *)aAppsflyer {
    
    if (self = [super init]) {
        self.settings = settings;
        self.appsflyer = aAppsflyer;
        
        NSString *afDevKey = [self.settings objectForKey:@"appsFlyerDevKey"];
        NSString *appleAppId = [self.settings objectForKey:@"appleAppID"];
        [self.appsflyer setAppsFlyerDevKey:afDevKey];
        [self.appsflyer setAppleAppID:appleAppId];
       // self.appsflyer.isDebug = true;
        
        if ([self logAttributionData]) {
            self.appsflyer.delegate = self;
        }
        if (_segDLDelegate) {
            self.appsflyer.deepLinkDelegate = self;
        }
        
    }
    return self;
}



-(void) applicationDidBecomeActive {
    [self start];
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

- (void) start {
    [self.appsflyer start];
}


- (void)track:(SEGTrackPayload *)payload
{
    if (payload.properties != nil){
        SEGLog(@"logEvent: %@", payload.properties);
    }
    
    // Extract the revenue / currency from the properties passed in to us with an "af_" prefix
    NSNumber *revenue = [SEGAppsFlyerIntegration extractRevenue:payload.properties withKey:@"revenue"];
    NSString *currency = [SEGAppsFlyerIntegration extractCurrency:payload.properties withKey:@"currency"];
    
    if (revenue) {
        NSMutableDictionary* af_payload_properties = [NSMutableDictionary dictionaryWithDictionary: payload.properties];
        [af_payload_properties setObject:revenue forKey:@"af_revenue"];
        
        if (currency) {
            [af_payload_properties setObject:currency forKey:@"af_currency"];
        }
        
        [self.appsflyer logEvent:payload.event withValues:af_payload_properties];
    }
    
    else {
        // Log the raw event.
        [self.appsflyer logEvent:payload.event withValues:payload.properties];
    }
}

+ (NSString *)extractCurrency:(NSDictionary *)dictionary withKey:(NSString *)currencyKey
{
    id currencyProperty = dictionary[currencyKey];
    if (currencyProperty) {
        if ([currencyProperty isKindOfClass:[NSString class]]) {
            return currencyProperty;
        }
    }
    // If currency not set, return default USD
    return @"USD";
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

+(NSString *) validateNil: (NSString *) value
{
    return value ?((value != (id)[NSNull null]) ?  value: @"" ) : @"";
}

- (void)onConversionDataSuccess:(nonnull NSDictionary *)conversionInfo {
    NSString *const key = @"AF_Install_Attr_Sent";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL installAttrSent = [userDefaults boolForKey:key];
    
    if(!installAttrSent){
  [userDefaults setBool:YES forKey:key];
        if(_segDelegate && [_segDelegate respondsToSelector:@selector(onConversionDataSuccess:)]) {
          [_segDelegate onConversionDataSuccess:conversionInfo];
        }
        NSDictionary *campaign = @{
                @"source": [SEGAppsFlyerIntegration validateNil : conversionInfo[@"media_source"]],
                @"name": [SEGAppsFlyerIntegration validateNil : conversionInfo[@"campaign"]],
                @"ad_group": [SEGAppsFlyerIntegration validateNil: conversionInfo[@"adgroup"]]
            };
           
        
        NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithDictionary:@{@"provider": @"AppsFlyer"}];
        [properties addEntriesFromDictionary:conversionInfo];
        
        // Delete already mapped special fields.
        [properties removeObjectForKey:@"media_source"];
        [properties removeObjectForKey:@"adgroup"];
        
        // replace original campaign with new created
        [properties removeObjectForKey:@"campaign"];
        [properties setObject:campaign forKey:@"campaign"];
        
        // If you are working with networks that don't allow passing user level data to 3rd parties,
        // you will need to apply code to filter out these networks before calling
        // `[self.analytics track:@"Install Attributed" properties:[properties copy]];`
        [self.analytics track:@"Install Attributed" properties: [properties copy]];
        
      
    }
}

- (void)onConversionDataFail:(nonnull NSError *)error {
    if(_segDelegate && [_segDelegate respondsToSelector:@selector(onConversionDataFail:)]) {
        [_segDelegate onConversionDataFail:error];
    }
    SEGLog(@"[Appsflyer] onConversionDataRequestFailure:%@]", error);
}

- (void) onAppOpenAttribution:(NSDictionary*) attributionData
{
    if(_segDelegate && [_segDelegate respondsToSelector:@selector(onAppOpenAttribution:)]) {
        [_segDelegate onAppOpenAttribution:attributionData];
    }
    SEGLog(@"[Appsflyer] onAppOpenAttribution data: %@", attributionData);
}

- (void) onAppOpenAttributionFailure:(NSError *)error
{
    if(_segDelegate && [_segDelegate respondsToSelector:@selector(onAppOpenAttributionFailure:)]) {
        [_segDelegate onAppOpenAttributionFailure:error];
    }
    SEGLog(@"[Appsflyer] onAppOpenAttribution failure data: %@", error);
}

-(void)didResolveDeepLink:(AppsFlyerDeepLinkResult *_Nonnull)result
{
    if (_segDLDelegate && [_segDLDelegate respondsToSelector:@selector(didResolveDeepLink:)]) {
        [_segDLDelegate didResolveDeepLink:result];
    }
    SEGLog(@"[Appsflyer] didResolveDeepLink result: %@", result);
}




- (BOOL)logAttributionData
{
    return [(NSNumber *)[self.settings objectForKey:@"trackAttributionData"] boolValue];
}

@end

