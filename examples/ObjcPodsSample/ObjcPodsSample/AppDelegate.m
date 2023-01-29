//
//  AppDelegate.m
//  ObjcPodsSample
//
//  Created by Vitaly Sokolov on 12.08.2020.
//

#import "AppDelegate.h"
#import "SEGAppsFlyerIntegrationFactory.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>


@interface AppDelegate ()

@end

@interface AppDelegate ()<SEGAppsFlyerLibDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // For ApsFlyer debug logs
    [AppsFlyerLib shared].isDebug = YES;
    
//    [[AppsFlyerLib shared] waitForATTUserAuthorizationWithTimeoutInterval:60];
    /*
     Based on your needs you can either pass a delegate to process deferred
     and direct deeplinking callbacks or disregard them.
     If you choose to use the delegate, see extension to this class below
     */
//    SEGAppsFlyerIntegrationFactory* factoryNoDelegate = [SEGAppsFlyerIntegrationFactory instance];
    SEGAppsFlyerIntegrationFactory* factoryWithDelegate = [SEGAppsFlyerIntegrationFactory createWithLaunchDelegate:self];
    
    SEGAnalyticsConfiguration *config = [SEGAnalyticsConfiguration configurationWithWriteKey:@"SEGMENT_KEY"];
//    [config use:factoryNoDelegate];
    [config use:factoryWithDelegate];  // use this if you want to get conversion data in the app. Read more in the integration guide
    config.enableAdvertisingTracking = YES;       //OPTIONAL
    config.trackApplicationLifecycleEvents = YES; //OPTIONAL
    config.trackDeepLinks = YES;                  //OPTIONAL
    config.trackPushNotifications = YES;          //OPTIONAL
    [SEGAnalytics debug:YES];                     //OPTIONAL
    [SEGAnalytics setupWithConfiguration:config];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Code below is to collect IDFA. Read more here - https://support.appsflyer.com/hc/en-us/articles/360011451918-iOS-SDK-V6-beta-integration-guide-for-developers#integration-34-support-apptrackingtransparency-att
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            //....
        }];
    }
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


-(void)onConversionDataFail:(NSError *) error {
    NSLog(@"%@",error);
}

-(void)onConversionDataSuccess:(NSDictionary*) installData {
    id status = [installData objectForKey:@"af_status"];
    if([status isEqualToString:@"Non-organic"]) {
        id sourceID = [installData objectForKey:@"media_source"];
        id campaign = [installData objectForKey:@"campaign"];
        NSLog(@"This is a none organic install. Media source: %@  Campaign: %@",sourceID,campaign);
    } else if([status isEqualToString:@"Organic"]) {
        NSLog(@"This is an organic install.");
    }
}

- (void) onAppOpenAttribution:(NSDictionary*) attributionData {
    NSLog(@"%@",attributionData);
}

- (void) onAppOpenAttributionFailure:(NSError *)error {
    NSLog(@"%@",error);
}

@end
