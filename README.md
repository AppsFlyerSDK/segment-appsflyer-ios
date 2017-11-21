<img src="https://www.appsflyer.com/wp-content/uploads/2016/11/logo-1.svg"  width="200">

# AppsFlyer integration for Segment.
This is a Segment wrapper for AppsFlyer SDK framework.


----------
In order for us to provide optimal support, we would kindly ask you to submit any issues to support@appsflyer.com

*When submitting an issue please specify your AppsFlyer sign-up (account) email , your app ID , production steps, logs, code snippets and any additional relevant information.*

----------


## Table of content

- [Installation](#installation)
  - [troubleshooting](#troubleshooting-inst)  
- [Usage](#usage) 
 - [Objective-C](#usage-obj-c)
 - [Swift](#usage-swift)
 - [Install Attributed event](#install_attributed)
- [Examples](#examples) 


## <a id="installation">Installation

To install the segment-appsflyer-ios integration, simply add this line to your [CocoaPods](http://cocoapods.org) `Podfile`:

```ruby
pod 'segment-appsflyer-ios'
```
### <a id="troubleshooting-inst">Troubleshooting

For users who are unable to bundle static libraries as dependencies (Swift project for example)
     you can choose `StaticLibWorkaround` subspec, but be sure to include `AppsFlyerFramework` to  in your Podfile:

Example:
     
```ruby
  pod 'AppsFlyerFramework'
  pod 'segment-appsflyer-ios/StaticLibWorkaround'
```

Next step, add manually 5 files to your project (located under `<YOUR_APP>/Pods/segment-appsflyer-ios/segment-appsflyer-ios/Classes`):
  
 - `SEGAppsFlyerIntegration.h`
 - `SEGAppsFlyerIntegration.m`
 - `SEGAppsFlyerIntegrationFactory.h`
 - `SEGAppsFlyerIntegrationFactory.m`
 - `SegmentAppsFlyeriOS.h`

Xcode will ask you to generate `<YOUR_APP_NAME>-Bridging-Header.h`
Add to this file `#import "SEGAppsFlyerIntegrationFactory.h"`

For more details follow the instructions from Apple [here](https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html).


## <a id="usage"> Usage

First of all, you must provide values for AppsFlyer Dev Key, Apple App ID (iTunes) and client secret in Segment's **dashboard** for AppsFlyer integration

### <a id="usage-obj-c"> Usage - Objective-C

Open `AppDelegate.h` and add:

In `AppDelegate.m` ➜ `didFinishLaunchingWithOptions`:

```objective-c
SEGAnalyticsConfiguration *config = [SEGAnalyticsConfiguration configurationWithWriteKey:@"SEGMENT_KEY"];
    
    [config use:[SEGAppsFlyerIntegrationFactory instance]];
    
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

```objective-c

import Analytics

//...

let config:Analytics.SEGAnalyticsConfiguration = SEGAnalyticsConfiguration(writeKey: "SEGMENT_KEY")
        
        config.use(SEGAppsFlyerIntegrationFactory())
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

## <a id="install_attributed"> Install Attributed event

If you are working with networks that don't allow passing user level data to 3rd parties, you will need to apply code to filter out these networks before calling
```
// [self.analytics track:@"Install Attributed" properties:[properties copy]];
```

## <a id="examples"> Examples

This project  has [4 examples](https://github.com/AppsFlyerSDK/segment-appsflyer-ios/tree/master/examples) for objective-C and Swift (with troubleshooting). To give it a try , clone this repo and from each example first run `pod install` to install project dependancies.

