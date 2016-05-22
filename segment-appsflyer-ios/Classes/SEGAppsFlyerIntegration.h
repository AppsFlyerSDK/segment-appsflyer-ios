//
//  SEGAppsFlyerIntegration.h
//  AppsFlyerSegmentiOS
//
//  Created by Golan on 5/17/16.
//  Copyright © 2016 AppsFlyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Analytics/SEGIntegration.h>
#import <AppsFlyer/AppsFlyer.h>

@interface SEGAppsFlyerIntegration : NSObject <SEGIntegration>

@property (nonatomic, strong) NSDictionary *settings;
@property (nonatomic, strong) AppsFlyerTracker *appsflyer;



- (instancetype)initWithSettings:(NSDictionary *)settings;
- (instancetype)initWithSettings:(NSDictionary *)settings withAppsflyer:(AppsFlyerTracker *)aAppsflyer;


@end
