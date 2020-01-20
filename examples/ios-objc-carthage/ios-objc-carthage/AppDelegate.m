//
//  AppDelegate.m
//  ios-objc-carthage
//
//  Created by Andrii Hahan on 20.01.2020.
//  Copyright © 2020 Andrii Hahan. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    SEGAnalyticsConfiguration *config = [SEGAnalyticsConfiguration configurationWithWriteKey:@"SEGMENT_KEY"];
    
    [config use:[SEGAppsFlyerIntegrationFactory instance]];
    
    config.enableAdvertisingTracking = YES;       //OPTIONAL
    config.trackApplicationLifecycleEvents = YES; //OPTIONAL
    config.trackDeepLinks = YES;                  //OPTIONAL
    config.trackPushNotifications = YES;          //OPTIONAL
    config.trackAttributionData = YES;            //OPTIONAL
    [SEGAnalytics debug:YES];                     //OPTIONAL
    [SEGAnalytics setupWithConfiguration:config];
    return YES;
}

@end
