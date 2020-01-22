//
//  SEGAppsFlyerIntegrationFactory.h
//  AppsFlyerSegmentiOS
//
//  Created by Margot Guetta/Maxim Shoustin on 5/17/16.
//  Copyright © 2016 AppsFlyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Analytics/SEGIntegrationFactory.h>
#import "SEGAppsFlyerIntegration.h"


@interface SEGAppsFlyerIntegrationFactory : NSObject <SEGIntegrationFactory>

+ (instancetype)instance;
+ (instancetype)createWithLaunchDelegate:(id<SEGAppsFlyerTrackerDelegate>) delegate;

@property (weak, nonatomic) id<SEGAppsFlyerTrackerDelegate> delegate;

@end
