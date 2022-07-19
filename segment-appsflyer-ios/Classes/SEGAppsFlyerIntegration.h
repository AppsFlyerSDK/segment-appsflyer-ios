//
//  SEGAppsFlyerIntegration.h
//  AppsFlyerSegmentiOS
//
//  Created by Margot Guetta/Maxim Shoustin on 5/17/16.
//  Copyright © 2016 AppsFlyer. All rights reserved.
//

#import <Foundation/Foundation.h>

#if defined(__has_include) && __has_include(<Analytics/SEGAnalytics.h>) && __has_include(<Analytics/SEGAnalyticsUtils.h>)
#import <Analytics/SEGAnalytics.h>
#import <Analytics/SEGAnalyticsUtils.h>
#else
@import Segment;
#endif

#import <AppsFlyerLib/AppsFlyerLib.h>


@protocol SEGAppsFlyerLibDelegate <AppsFlyerLibDelegate>

@end

@protocol SEGAppsFlyerDeepLinkDelegate<AppsFlyerDeepLinkDelegate>


@end

@interface SEGAppsFlyerIntegration : NSObject <SEGIntegration, AppsFlyerLibDelegate, AppsFlyerDeepLinkDelegate>

@property (nonatomic, strong) NSDictionary *settings;
@property (nonatomic, strong) AppsFlyerLib *appsflyer;
@property (nonatomic, strong) SEGAnalytics *analytics;
@property (weak, nonatomic) id<SEGAppsFlyerLibDelegate> segDelegate;
@property (weak, nonatomic) id<AppsFlyerDeepLinkDelegate> segDLDelegate;
@property BOOL manualMode;

- (instancetype)initWithSettings:(NSDictionary *)settings
                   withAnalytics:(SEGAnalytics *) analytics;

- (instancetype)initWithSettings:(NSDictionary *)settings
                   withAnalytics:(SEGAnalytics *)analytics
                andDelegate:(id<AppsFlyerLibDelegate>) delegate;

- (instancetype)initWithSettings:(NSDictionary *)settings
                   withAnalytics:(SEGAnalytics *)analytics
                andDelegate:(id<AppsFlyerLibDelegate>) delegate
             andDeepLinkDelegate:(id<AppsFlyerDeepLinkDelegate>) DLDelegate
                   andManualMode:(BOOL)manualMode;




- (void) start;
@end

