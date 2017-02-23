<img src="https://www.appsflyer.com/wp-content/uploads/2016/11/logo-1.svg"  width="200">

# AppsFlyer integration for Segment.
This is a Segment wrapper for AppsFlyer SDK framework.


## Table of content

- [Installation](#installation)
- [Usage](#usage) 
 - [Objective-C](#usage-obj-c)
 - [Swift](#usage-swift)
- [Examples](#examples) 
- [TODO](#todo) 

## <a id="installation">Installation

Segment AppsFlyer uses AppsFlyer static framework from Cocoapods.
Add the `appsFlyerFramework` to `podfile` and run `pod install`.


Example:
     
```
  pod 'AppsFlyerFramework'
  pod 'Analytics', '~> 3.5'

```

Next step, copy manually 5 files to your project:
  
 - `SEGAppsFlyerIntegration.h`
 - `SEGAppsFlyerIntegration.m`
 - `SegAppsFlyerIntegrationFactory.h`
 - `SegAppsFlyerIntegrationFactory.m`
 - `SegmentAppsFlyeriOS.h`

You can find them here: [segment appsflyer ios wrapper](https://github.com/AppsFlyerSDK/segment-appsflyer-ios/tree/master/segment-appsflyer-ios/Classes)

To use SDK from a Swift source just follow the instructions from Apple [here](https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html).


## <a id="usage"> Usage

First of all, you must provide values for AppsFlyer Dev Key, Apple App ID (iTunes) and client secret in Segment's **dashboard** for AppsFlyer integration

### <a id="usage-obj-c"> Usage - Objective-C

Open `AppDelegate.h` and add:

```objective-c
#import "SEGAppsFlyerIntegrationFactory.h"
#import <Analytics/SEGAnalytics.h>
```

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

## <a id="examples"> Examples

This project  has [2 examples](github.com/AppsFlyerSDK/segment-appsflyer-ios%7Chttps://github.com/AppsFlyerSDK/segment-appsflyer-ios/tree/master/examples) for objective-C and Swift. To give it a try , clone this repo and from each example first run `pod install` to install project dependancies.

## <a id="todo"> TODO

- Create Podspec with sybspec for  users who are unable to bundle static libraries as dependencies (mostly for Swift users)