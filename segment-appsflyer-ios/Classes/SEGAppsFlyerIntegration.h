//
//  SEGAppsFlyerIntegration.h
//  AppsFlyerSegmentiOS
//
//  Created by Margot Guetta/Maxim Shoustin on 5/17/16.
//  Copyright © 2016 AppsFlyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Analytics/SEGAnalytics.h>
#import <AppsFlyerLib/AppsFlyerLib.h>

@protocol SEGAppsFlyerLibDelegate <AppsFlyerLibDelegate>

@end

@interface SEGAppsFlyerIntegration : NSObject <SEGIntegration, AppsFlyerLibDelegate>

@property (nonatomic, strong) NSDictionary *settings;
@property (nonatomic, strong) AppsFlyerLib *appsflyer;
@property (nonatomic, strong) SEGAnalytics *analytics;
@property (weak, nonatomic) id<SEGAppsFlyerLibDelegate> segDelegate;

- (instancetype)initWithSettings:(NSDictionary *)settings
                   withAnalytics:(SEGAnalytics *) analytics;

- (instancetype)initWithSettings:(NSDictionary *)settings
                   withAnalytics:(SEGAnalytics *)analytics
                andDelegate:(id<AppsFlyerLibDelegate>) delegate;


- (void) start;
@end

