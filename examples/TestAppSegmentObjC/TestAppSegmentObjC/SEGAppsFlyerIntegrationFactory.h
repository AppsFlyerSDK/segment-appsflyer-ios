//
//  SEGAppsFlyerIntegrationFactory.h
//  AppsFlyerSegmentiOS
//
//  Created by Golan on 5/17/16.
//  Copyright © 2016 AppsFlyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Analytics/SEGIntegrationFactory.h>
#import <AppsFlyerLib/AppsFlyerTracker.h>
#import "SEGAppsFlyerIntegration.h"


@interface SEGAppsFlyerIntegrationFactory : NSObject <SEGIntegrationFactory>

+ (instancetype)instance;
//+ (instancetype)createWithLaunchOptions:(NSString *)token launchOptions:(NSDictionary *)launchOptions;
+ (instancetype)createWithLaunchDelegate:(id<SEGAppsFlyerTrackerDelegate>) delegate;

//@property NSDictionary *launchOptions;
@property (unsafe_unretained, nonatomic) id<SEGAppsFlyerTrackerDelegate> delegate;

@end
