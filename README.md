<img src="https://massets.appsflyer.com/wp-content/uploads/2018/06/20092440/static-ziv_1TP.png"  width="400" > 

# AppsFlyer integration for Segment.

## This is a Segment wrapper for AppsFlyer SDK that is built with iOS SDK v6.10.1.

[![Version](https://img.shields.io/badge/cocoapods-compatible-brightgreen?logo=cocoapods&logoColor=green&style=flat)](http://cocoapods.org/pods/segment-appsflyer-ios)
[![Carthage compatible](https://img.shields.io/badge/Carthage-not_compatible-C20000.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CI - Tests](https://github.com/AppsFlyerSDK/segment-appsflyer-ios/actions/workflows/unit-tests-workflow.yml/badge.svg)](https://github.com/AppsFlyerSDK/segment-appsflyer-ios/actions/workflows/unit-tests-workflow.yml)

----------
🛠 In order for us to provide optimal support, we would kindly ask you to submit any issues to support@appsflyer.com

*When submitting an issue please specify your AppsFlyer sign-up (account) email , your app ID , production steps, logs, code snippets and any additional relevant information.*

----------


## Table of content

- [Breaking changes](#breaking-changes)
- [Installation](#installation)
- [Manual mode](#manual)
- [Usage](#usage) 
  - [Objective-C](#usage-obj-c)
  - [Swift](#usage-swift)
- [Get Conversion Data](#getconversiondata)
  - [Objective-C](#gcd-obj-c)
  - [Swift](#gcd-swift)
- [Unified Deep linking](#DDL)
    - [Swift](#ddl-swift)
- [Install Attributed event](#install_attributed)
- [Additional AppsFlyer SDK setup](#additional_setup)
- [Examples](#examples) 


## <a id="breaking-changes"> ❗ Breaking Changes

- From version `6.3.2`, we use `xcframework` for iOS platform, then you need to use cocoapods version >= 1.10

## <a id="installation">Installation

### Cocoapods

To install the segment-appsflyer-ios integration:

1. Simply add this line to your [CocoaPods](http://cocoapods.org) `Podfile`:

**Production** version: 
```ruby
pod 'segment-appsflyer-ios', '6.10.1'
```

**Strict mode SDK** version: 
```ruby
pod 'segment-appsflyer-ios/Strict', '6.10.1'
```
Use the strict mode SDK to completely remove IDFA collection functionality and AdSupport framework dependencies (for example, when developing apps for kids).

2. Run `pod install` in the project directory

### Swift Package Manager
  
 In XCode, go to **File** > **Swift Package** > **Add Package dependency...** And add https://github.com/AppsFlyerSDK/segment-appsflyer-ios for the package dependency url. 

## <a id="manual"> Manual mode
Starting version `6.8.0`, we support a manual mode to seperate the initialization of the AppsFlyer SDK and the start of the SDK. In this case, the AppsFlyer SDK won't start automatically, giving the developper more freedom when to start the AppsFlyer SDK. Please note that in manual mode, the developper is required to implement the API ``AppsFlyerLib.shared().start()`` in order to start the SDK. 
### Example:
```objective-c
  [SEGAppsFlyerIntegrationFactory createWithManualMode:YES];
``` 
Please look at the examples below to see how to use the manual mode with delegate. \
To start the AppsFlyer SDK, use the `start()` API, like the following :
```objective-c
 [[AppsFlyerLib shared] start];
``` 
  
## <a id="usage"> Usage

First of all, you must provide values for AppsFlyer Dev Key, Apple App ID (iTunes) and client secret in Segment's **dashboard** for AppsFlyer integration

### <a id="usage-obj-c"> Usage - Objective-C

Open `AppDelegate.h` and add:

```objective-c
#import "SEGAppsFlyerIntegrationFactory.h"
```

In `AppDelegate.m` ➜ `didFinishLaunchingWithOptions`:

```objective-c

    // For ApsFlyer debug logs
    [AppsFlyerLib shared].isDebug = YES;
    
//    [[AppsFlyerLib shared] waitForATTUserAuthorizationWithTimeoutInterval:60];
    /*
     Based on your needs you can either pass a delegate to process deferred
     and direct deeplinking callbacks or disregard them.
     If you choose to use the delegate, see extension to this class below
     */
    SEGAppsFlyerIntegrationFactory* factoryNoDelegate = [SEGAppsFlyerIntegrationFactory instance];
//    SEGAppsFlyerIntegrationFactory* factoryWithDelegate = [SEGAppsFlyerIntegrationFactory createWithLaunchDelegate:self];

// To use the manual mode, use the following method
//    SEGAppsFlyerIntegrationFactory* factoryNoDelegate = [SEGAppsFlyerIntegrationFactory createWithManualMode:YES];
//    SEGAppsFlyerIntegrationFactory* factoryWithDelegate = [SEGAppsFlyerIntegrationFactory createWithLaunchDelegate:self andManualMode:YES];

    
    SEGAnalyticsConfiguration *config = [SEGAnalyticsConfiguration configurationWithWriteKey:@"SEGMENT_KEY"];
    [config use:factoryNoDelegate];
//    [config use:factoryWithDelegate];  // use this if you want to get conversion data in the app. Read more in the integration guide
    config.enableAdvertisingTracking = YES;       //OPTIONAL
    config.trackApplicationLifecycleEvents = YES; //OPTIONAL
    config.trackDeepLinks = YES;                  //OPTIONAL
    config.trackPushNotifications = YES;          //OPTIONAL
    [SEGAnalytics debug:YES];                     //OPTIONAL
    [SEGAnalytics setupWithConfiguration:config];
```

In `AppDelegate.m` ➜ `applicationDidBecomeActive`:
```objective-c
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Getting user consent dialog. Please read https://dev.appsflyer.com/hc/docs/integrate-ios-sdk#enabling-app-tracking-transparency-att-support
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            //....
        }];
    }
}
```
### <a id="usage-swift"> Usage - Swift

1. Open/Create `<Your-App-name>-Bridging-Header.h`  and add:

```objective-c
#import "SEGAppsFlyerIntegrationFactory.h"
```
![image](https://user-images.githubusercontent.com/50541317/90022182-e5768900-dcba-11ea-8bfd-180cc6f28700.png)

2. Add path to the Bridging header under Build Settings > Swift Compiler - General > Objective-C Bridging Header
![image](https://user-images.githubusercontent.com/50541317/90022174-e1e30200-dcba-11ea-8785-0303aebe75e2.png)

3. Open `AppDelegate.swift` and add:

```swift
import Segment
import AppsFlyerLib
import segment_appsflyer_ios
```

4. In `didFinishLaunchingWithOptions` add:
```swift 
    // For AppsFLyer debug logs uncomment the line below
    // AppsFlyerLib.shared().isDebug = true
//    AppsFlyerLib.shared().waitForATTUserAuthorization(withTimeoutInterval: 60)

    /*
     Based on your needs you can either pass a delegate to process deferred
     and direct deeplinking callbacks or disregard them.
     If you choose to use the delegate, see extension to this class below
     */
//    let factoryWithDelegate : SEGAppsFlyerIntegrationFactory = SEGAppsFlyerIntegrationFactory.create(withLaunch: self)
    let factoryNoDelegate = SEGAppsFlyerIntegrationFactory()
    
    /* If you want to use the manual mode, please use the following methods
      with or without delegate */
     //  let factoryWithDelegate : SEGAppsFlyerIntegrationFactory = SEGAppsFlyerIntegrationFactory.create(withLaunch: self, andManualMode:true)
   // let factoryNoDelegate = SEGAppsFlyerIntegrationFactory.create(withManualMode: true)
    
    
    // Segment initialization
    let config = AnalyticsConfiguration(writeKey: "SEGMENT_KEY")
//    config.use(factoryWithDelegate)  // use this if you want to get conversion data in the app. Read more in the integration guide
    config.use(factoryNoDelegate)
    config.enableAdvertisingTracking = true       //OPTIONAL
    config.trackApplicationLifecycleEvents = true //OPTIONAL
    config.trackDeepLinks = true                  //OPTIONAL
    config.trackPushNotifications = true          //OPTIONAL
    
    Analytics.debug(false)
    Analytics.setup(with: config)
```

In `applicationDidBecomeActive` add:
```swift
func applicationDidBecomeActive(_ application: UIApplication) {
    // If you want to collect IDFA, please add the code below and read https://support.appsflyer.com//hc/en-us/articles/207032066#integration-35-support-apptrackingtransparency-att
    if #available(iOS 14, *) {
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { (status) in
            // ...
        })
    }
}
```
AppsFlyer integration responds to ```identify``` call.  To read more about it, visit [Segment identify method documentation](https://segment.com/docs/libraries/ios/#identify).
In identify call ```traits``` dictionary  ```setCustomerUserID``` and ```currencyCode```

## <a id="getconversiondata"> Get Conversion Data
  
  In order for Conversion Data to be sent to Segment, make sure you have enabled "Track Attribution Data" and specified App ID in AppsFlyer destination settings:
  
![image](https://user-images.githubusercontent.com/50541317/69795158-51b86780-11d4-11ea-9ab3-be3e669e4e3b.png)
  
### <a id="gcd-obj-c"> Objective-C
  
    
  In order to get Conversion Data you need to:
  
  1. Add `SEGAppsFlyerLibDelegate` protocol to your AppDelegate.h (or other) class
```objective-c
#import <UIKit/UIKit.h>
#import "SEGAppsFlyerIntegrationFactory.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, SEGAppsFlyerLibDelegate>
```
  2. Pass AppDelegate (or other) class when configuring Segment Analytics with AppsFlyer. Change line `[config use:[SEGAppsFlyerIntegrationFactory instance]];` to `[config use:[SEGAppsFlyerIntegrationFactory createWithLaunchDelegate:self]];`
  3. In the class passed to the method above (AppDelegate.m by default) implement methods of the `SEGAppsFlyerLibDelegate` protocol. See sample code below:
  
```objective-c
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

-(void)onConversionDataSuccess:(NSDictionary*) installData {
    BOOL first_launch_flag = [[installData objectForKey:@"is_first_launch"] boolValue];
    NSString *status = [installData objectForKey:@"af_status"];
    
    if(first_launch_flag) {
        if ([status isEqualToString:@"Non-organic"]){
            NSString *sourceID = [installData objectForKey:@"media_source"];
            NSString *campaign = [installData objectForKey:@"campaign"];
            NSLog(@"This is a non-organic install. Media source: %@ Campaign: %@", sourceID, campaign);
        } else {
            NSLog(@"This is an organic install");
        }
    } else {
        NSLog(@"Not first launch");
    }
};

/**
 Any errors that occurred during the conversion request.
 */
-(void)onConversionDataFail:(NSError *) error {
    NSLog(@"%@", [error description]);
};

/**
 `attributionData` contains information about OneLink, deeplink.
 */
- (void)onAppOpenAttribution:(NSDictionary *)attributionData{
    NSLog(@"onAppOpenAttribution");
    for(id key in attributionData){
        NSLog(@"onAppOpenAttribution: key=%@ value=%@", key, [attributionData objectForKey:key]);
    }
};

/**
 Any errors that occurred during the attribution request.
 */
- (void)onAppOpenAttributionFailure:(NSError *)error{
    NSLog(@"%@", [error description]);
};

// Rest of your AppDelegate code
```


### <a id="gcd-swift"> Swift
  
  In order to get Conversion Data you need to:
  
  1. Add `SEGAppsFlyerLibDelegate` protocol to your AppDelegate (or other) class
  2. Pass AppDelegate (or other) class when configuring Segment Analytics with AppsFlyer. If you use sample code from above, change line `config.use(factoryNoDelegate)` to `config.use(factoryWithDelegate)`
  3. Implement methods of the protocol in the class, passed as a delegate. See sample code below where AppDelegate is used for that:
  
  ```swift
  class AppDelegate: UIResponder, UIApplicationDelegate, SEGAppsFlyerLibDelegate {
    
    var window: UIWindow?
    
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        guard let first_launch_flag = conversionInfo["is_first_launch"] as? Int else {
            return
        }
        
        guard let status = conversionInfo["af_status"] as? String else {
            return
        }
        
        if(first_launch_flag == 1) {
            if(status == "Non-organic") {
                if let media_source = conversionInfo["media_source"] , let campaign = conversionInfo["campaign"]{
                    print("This is a Non-Organic install. Media source: \(media_source) Campaign: \(campaign)")
                }
            } else {
                print("This is an organic install.")
            }
        } else {
            print("Not First Launch")
        }
    }
    
    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]) {
        print("Deep Link Data goes here:")
        if let data = attributionData{
          print("\(data)")
        }
    }

   func onConversionDataFail(_ error: Error) {
        }

    func onAppOpenAttributionFailure(_ error: Error?) {
    }
    //rest of you AppDelegate code
  }
  ```

## <a id="DDL"> Unified Deep linking
### <a id="ddl-swift"> Swift
In order to use Unified Deep linking you need to:
  
  1. Add `SEGAppsFlyerDeepLinkDelegate` protocol to your AppDelegate (or other) class
  2. Pass AppDelegate (or other) class when configuring Segment Analytics with AppsFlyer. From the sample code above, change  factoryWithDelegate to :
  ```swift
  let factoryWithDelegate: SEGAppsFlyerIntegrationFactory = SEGAppsFlyerIntegrationFactory.create(withLaunch: self, andDeepLinkDelegate: self)
  ```

  3. Implement methods of the protocol in the class, passed as a delegate. See sample code below where AppDelegate is used for that:
  
```swift
extension AppDelegate: SEGAppsFlyerDeepLinkDelegate {
    func didResolveDeepLink(_ result: DeepLinkResult) {
        print(result)
    }
}

```


## <a id="install_attributed"> Install Attributed event

If you are working with networks that don't allow passing user level data to 3rd parties, you will need to apply code to filter out these networks before calling
```objective-c
// [self.analytics track:@"Install Attributed" properties:[properties copy]];
```

## <a id="additional_setup"> Additional AppsFlyer SDK setup

```objective-c
@import AppsFlyerLib;

...
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(integrationDidStart:) name:SEGAnalyticsIntegrationDidStart object:nil];
    ...
}

...

- (void)integrationDidStart:(nonnull NSNotification *)notification {
    NSString *integration = notification.object;
    if ([integration isEqualToString:@"AppsFlyer"]) {
        /// Additional AppsFlyer SDK setup goes below
        /// All setup is optional
        /// To set Apple App ID and AppsFlyer Dev Key use Segment dashboard
        /// ...
        /// Enable ESP support for specific URLs
        [[AppsFlyerLib shared] setResolveDeepLinkURLs:@[@"afsdktests.com"]];
        /// Disable printing SDK messages to the console log
        [[AppsFlyerLib shared]  setIsDebug:NO];
        /// `OneLink ID` from OneLink configuration
        [[AppsFlyerLib shared]  setAppInviteOneLink:@"one_link_id"];
    }
}
```

## <a id="examples"> Examples

This project  has [4 examples](https://github.com/AppsFlyerSDK/segment-appsflyer-ios/tree/master/examples) for objective-C and Swift (with troubleshooting). To give it a try , clone this repo and from each example first run `pod install` to install project dependancies.

