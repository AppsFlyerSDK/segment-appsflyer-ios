//
//  SEGAppsFlyerIntegration.h
//  AppsFlyerSegmentiOS
//
//  Created by Golan/Maxim Shoustin on 5/17/16.
//  Copyright © 2016 AppsFlyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Analytics/SEGAnalytics.h>
#ifdef COCOAPODS
#import <AppsFlyerLib/AppsFlyerTracker.h>
#else
#import <AppsFlyerTracker/AppsFlyerTracker.h>
#endif

@protocol SEGAppsFlyerTrackerDelegate <AppsFlyerTrackerDelegate>

@end

@interface SEGAppsFlyerIntegration : NSObject <SEGIntegration, AppsFlyerTrackerDelegate>

@property (nonatomic, strong) NSDictionary *settings;
@property (nonatomic, strong) AppsFlyerTracker *appsflyer;
@property (nonatomic, strong) SEGAnalytics *analytics;
@property (weak, nonatomic) id<SEGAppsFlyerTrackerDelegate> segDelegate;

- (instancetype)initWithSettings:(NSDictionary *)settings
                   withAnalytics:(SEGAnalytics *) analytics;

- (instancetype)initWithSettings:(NSDictionary *)settings
                   withAnalytics:(SEGAnalytics *)analytics
                andDelegate:(id<AppsFlyerTrackerDelegate>) delegate;


- (void) trackLaunch;
@end

