//
//  SEGAppsFlyerIntegrationFactory.m
//  AppsFlyerSegmentiOS
//
//  Created by Golan/Maxim Shoustin on 5/17/16.
//  Copyright © 2016 AppsFlyer. All rights reserved.
//

#import "SEGAppsFlyerIntegrationFactory.h"


@implementation SEGAppsFlyerIntegrationFactory : NSObject

+ (instancetype)instance
{
    static dispatch_once_t once;
    static SEGAppsFlyerIntegrationFactory *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initWithLaunchDelegate:nil];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    return self;
}

- (instancetype)initWithLaunchDelegate:(id<SEGAppsFlyerTrackerDelegate>) delegate
{
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}


+ (instancetype)createWithLaunchDelegate:(id<SEGAppsFlyerTrackerDelegate>) delegate
{
    return [[self alloc] initWithLaunchDelegate:delegate];
}

- (id<SEGIntegration>)createWithSettings:(NSDictionary *)settings forAnalytics:(SEGAnalytics *)analytics
{
    return [[SEGAppsFlyerIntegration alloc] initWithSettings:settings withAnalytics:analytics
                                            andDelegate:self.delegate];
}

- (NSString *)key
{
    return @"AppsFlyer";
}
@end