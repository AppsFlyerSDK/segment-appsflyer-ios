//
//  SegAppsFlyerIntegrationFactory.m
//  SegmentAppsFlyeriOS
//
//  Created by Golan on 5/5/16.
//  Copyright © 2016 AppsFlyer. All rights reserved.
//

#import "SegAppsFlyerIntegrationFactory.h"
#import <Analytics/SEGAnalytics.h>


@implementation SegAppsFlyerIntegrationFactory : NSObject 


-(id) createWithSettings:(NSDictionary *)settings forAnalytics:(SEGAnalytics *)analytics
{
    return [[SEGAppsFlyerIntegration alloc] initWithSettings:settings];
}

-(NSString *)key
{
    return @"APPSFLYER";
}

@end

