<img src="https://www.appsflyer.com/wp-content/uploads/2016/11/logo-1.svg"  width="200">

# AppsFlyer integration for Segment.
This is a Segment wrapper for AppsFlyer SDK framework.


----------
In order for us to provide optimal support, we would kindly ask you to submit any issues to support@appsflyer.com

*When submitting an issue please specify your AppsFlyer sign-up (account) email , your app ID , production steps, logs, code snippets and any additional relevant information.*

----------


## Table of content

- [Installation](#installation)

- [Usage](#usage) 
  - [Objective-C](#usage-obj-c)
  - [Swift](#usage-swift)
- [Get Conversion Data](#getconversiondata)
  - [Objective-C](#gcd-obj-c)
  - [Swift](#gcd-swift)
- [Install Attributed event](#install_attributed)
- [Additional AppsFlyer SDK setup](#additional_setup)
- [Examples](#examples) 


## <a id="installation">Installation

### Cocoapods

To install the segment-appsflyer-ios integration, simply add this line to your [CocoaPods](http://cocoapods.org) `Podfile`:

```ruby
pod 'segment-appsflyer-ios'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate AppsFlyer and Segment into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "AppsFlyerSDK/segment-appsflyer-ios" "5.1.3"
```

## <a id="usage"> Usage

First of all, you must provide values for AppsFlyer Dev Key, Apple App ID (iTunes) and client secret in Segment's **dashboard** for AppsFlyer integration

### <a id="usage-obj-c"> Usage - Objective-C

Open `AppDelegate.h` and add:

```
#import "SEGAppsFlyerIntegrationFactory.h"
```

In `AppDelegate.m` ➜ `didFinishLaunchingWithOptions`:

```objective-c
SEGAnalyticsConfiguration *config = [SEGAnalyticsConfiguration configurationWithWriteKey:@"SEGMENT_KEY"];
    
    [config use:[SEGAppsFlyerIntegrationFactory instance]]; // this line may need to be replaced if you would like to get conversion and deep link data in the app.
    
    config.enableAdvertisingTracking = YES;       //OPTIONAL
    config.trackApplicationLifecycleEvents = YES; //OPTIONAL
    config.trackDeepLinks = YES;                  //OPTIONAL
    config.trackPushNotifications = YES;          //OPTIONAL
    config.trackAttributionData = YES;            //OPTIONAL   
    [SEGAnalytics debug:YES];                     //OPTIONAL
    [SEGAnalytics setupWithConfiguration:config];
```

### <a id="usage-swift"> Usage - Swift

Open/Create `<Your-App-name>-Bridging-Header.h`  and add:

```objective-c
#import "SEGAppsFlyerIntegrationFactory.h"
```

Open `AppDelegate.swift` ➜ `didFinishLaunchingWithOptions` and add:

```swift

import Analytics

//...

let config:Analytics.SEGAnalyticsConfiguration = SEGAnalyticsConfiguration(writeKey: "SEGMENT_KEY")

        config.use(SEGAppsFlyerIntegrationFactory())  // this line may need to be replaced if you would like to get conversion and deep link data in the app.
        config.enableAdvertisingTracking = true       //OPTIONAL
        config.trackApplicationLifecycleEvents = true //OPTIONAL
        config.trackDeepLinks = true                  //OPTIONAL
        config.trackPushNotifications = true          //OPTIONAL
        config.trackAttributionData = true            //OPTIONAL

        Analytics.SEGAnalytics.debug(true)
        Analytics.SEGAnalytics.setup(with: config)
```



AppsFlyer integration responds to ```identify``` call.  To read more about it, visit [Segment identify method documentation](https://segment.com/docs/libraries/ios/#identify).
In identify call ```traits``` dictionary  ```setCustomerUserID``` and ```currencyCode```

## <a id="getconversiondata"> Get Conversion Data
  
  In order for Conversion Data to be sent to Segment, make sure you have enabled "Track Attribution Data" and specified App ID in AppsFlyer destination settings:
  
![image](https://user-images.githubusercontent.com/50541317/69795158-51b86780-11d4-11ea-9ab3-be3e669e4e3b.png)
  
### <a id="gcd-obj-c"> Objective-C
  
    
  In order to get Conversion Data you need to:
  
  1. Add `SEGAppsFlyerTrackerDelegate` protocol to your AppDelegate.h (or other) class
```
#import <UIKit/UIKit.h>
#import "SEGAppsFlyerIntegrationFactory.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, SEGAppsFlyerTrackerDelegate>
```
  2. Pass AppDelegate (or other) class when configuring Segment Analytics with AppsFlyer. Change line `[config use:[SEGAppsFlyerIntegrationFactory instance]];` to `[config use:[SEGAppsFlyerIntegrationFactory createWithLaunchDelegate:self]];`
  3. In the class passed to the method above (AppDelegate.m by default) implement methods of the `SEGAppsFlyerTrackerDelegate` protocol. See sample code below:
  
```
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
  
  1. Add `SEGAppsFlyerTrackerDelegate` protocol to your AppDelegate (or other) class
  2. Pass AppDelegate (or other) class when configuring Segment Analytics with AppsFlyer. Change line `config.use(SEGAppsFlyerIntegrationFactory())` to `config.use(SEGAppsFlyerIntegrationFactory.create(withLaunch: self))`
  3. Implement methods of the protocol. See sample code below:
  
  ```
  class AppDelegate: UIResponder, UIApplicationDelegate, SEGAppsFlyerTrackerDelegate {
    
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
## <a id="install_attributed"> Install Attributed event

If you are working with networks that don't allow passing user level data to 3rd parties, you will need to apply code to filter out these networks before calling
```
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
        [[AppsFlyerTracker sharedTracker] setResolveDeepLinkURLs:@[@"afsdktests.com"]];
        /// Disable printing SDK messages to the console log
        [[AppsFlyerTracker sharedTracker] setIsDebug:NO];
        /// `OneLink ID` from OneLink configuration
        [[AppsFlyerTracker sharedTracker] setAppInviteOneLink:@"one_link_id"];
    }
}
```

## <a id="examples"> Examples

This project  has [4 examples](https://github.com/AppsFlyerSDK/segment-appsflyer-ios/tree/master/examples) for objective-C and Swift (with troubleshooting). To give it a try , clone this repo and from each example first run `pod install` to install project dependancies.

