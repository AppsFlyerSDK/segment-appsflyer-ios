//
//  SEGAppsFlyerIntegrationFactory.m
//  AppsFlyerSegmentiOS
//
//  Created by Margot Guetta/Maxim Shoustin on 5/17/16.
//  Copyright © 2016 AppsFlyer. All rights reserved.
//

#import "SEGAppsFlyerIntegrationFactory.h"


@implementation SEGAppsFlyerIntegrationFactory : NSObject

+ (instancetype)instance
{
    static dispatch_once_t once;
    static SEGAppsFlyerIntegrationFactory *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initWithLaunchDelegate:nil andDLDelegate:nil andManualMode:NO];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    return self;
}

- (instancetype)initWithLaunchDelegate:(id<SEGAppsFlyerLibDelegate>) delegate andDLDelegate:(id<SEGAppsFlyerDeepLinkDelegate>) DLDelegate andManualMode:(BOOL)mode
{
    if (self = [super init]) {
        self.delegate = delegate;
        self.DLDelegate = DLDelegate;
        self.manualMode = mode;
    }
    return self;
}


+ (instancetype)createWithLaunchDelegate:(id<SEGAppsFlyerLibDelegate>) delegate
{
    return [[self alloc] initWithLaunchDelegate:delegate andDLDelegate: nil andManualMode:NO];
}

+ (instancetype)createWithLaunchDelegate:(id<SEGAppsFlyerLibDelegate>) delegate andDeepLinkDelegate:(id<SEGAppsFlyerDeepLinkDelegate>)DLdelegate
{
    return [[self alloc] initWithLaunchDelegate:delegate andDLDelegate:DLdelegate andManualMode:NO];
}

+ (instancetype)createWithLaunchDelegate:(id<SEGAppsFlyerLibDelegate>) delegate andManualMode:(BOOL)mode
{
    return [[self alloc] initWithLaunchDelegate:delegate andDLDelegate: nil andManualMode:mode];
}

+ (instancetype)createWithLaunchDelegate:(id<SEGAppsFlyerLibDelegate>) delegate andDeepLinkDelegate:(id<SEGAppsFlyerDeepLinkDelegate>)DLdelegate andManualMode:(BOOL)mode
{
    return [[self alloc] initWithLaunchDelegate:delegate andDLDelegate:DLdelegate andManualMode:mode];
}

+ (instancetype)createWithManualMode:(BOOL) mode
{
    return [[self alloc] initWithLaunchDelegate:nil andDLDelegate: nil andManualMode:mode];
}

- (id<SEGIntegration>)createWithSettings:(NSDictionary *)settings forAnalytics:(SEGAnalytics *)analytics
{
    return [[SEGAppsFlyerIntegration alloc] initWithSettings:settings withAnalytics:analytics
                                            andDelegate:self.delegate andDeepLinkDelegate:self.DLDelegate andManualMode:self.manualMode];
}

- (NSString *)key
{
    return @"AppsFlyer";
}
@end
