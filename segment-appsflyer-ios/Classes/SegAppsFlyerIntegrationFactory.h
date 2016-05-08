//
//  SegAppsFlyerIntegrationFactory.h
//  SegmentAppsFlyeriOS
//
//  Created by Golan on 5/5/16.
//  Copyright © 2016 AppsFlyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEGAppsFlyerIntegration.h"

@class SEGAnalytics;

@protocol SEGIntegrationFactory


-(id<SEGAnalyticsIntegration>) createWithSettings:(NSDictionary *)settings forAnalytics:(SEGAnalytics *)analytics;
-(NSString *)key;

@end

@interface SegAppsFlyerIntegrationFactory : NSObject <SEGIntegrationFactory>



@end
