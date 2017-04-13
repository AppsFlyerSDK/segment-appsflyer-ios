//
//  SEGAppsFlyerIntegrationFactory.m
//  AppsFlyerSegmentiOS
//
//  Created by Golan on 5/17/16.
//  Copyright © 2016 AppsFlyer. All rights reserved.
//

#import "SEGAppsFlyerIntegrationFactory.h"
#import "SEGAppsFlyerIntegration.h"


@implementation SEGAppsFlyerIntegrationFactory : NSObject

+ (instancetype)instance
{
    static dispatch_once_t once;
    static SEGAppsFlyerIntegrationFactory *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    return self;
}

- (id<SEGIntegration>)createWithSettings:(NSDictionary *)settings forAnalytics:(SEGAnalytics *)analytics
{
    return [[SEGAppsFlyerIntegration alloc] initWithSettings:settings withAnalytics:analytics];
}

- (NSString *)key
{
    return @"AppsFlyer";
}
@end
