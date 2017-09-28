//
//  AppDelegate.h
//  TestAppSegmentPodsObjCTvOS
//
//  Created by Maxim Shoustin on 9/28/17.
//  Copyright © 2017 Maxim Shoustin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEGAppsFlyerIntegrationFactory.h"
#import <Analytics/SEGAnalytics.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, SEGAppsFlyerTrackerDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

