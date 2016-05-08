//
//  SEGAppsFlyerIntegration.h
//  SegmentAppsFlyeriOS
//
//  Created by Golan on 5/2/16.
//  Copyright © 2016 AppsFlyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppsFlyer/AppsFlyer.h>
#import <Analytics/SEGAnalyticsIntegration.h>
#import <Analytics/SEGAnalytics.h>

@interface SEGAppsFlyerIntegration : SEGAnalyticsIntegration


- (instancetype)initWithSettings:(NSDictionary *)settings;

@property AppsFlyerTracker *appsflyer;

@end

