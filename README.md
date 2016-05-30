##AppsFlyer integration for Segment.

## Installation

Segment-AppsFlyer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your `Podfile`:

```
pod "segment-appsflyer-ios"
```

## Usage

First of all, you must provide values for AppsFlyer Dev Key, Apple App ID (itunes) and client secret in Segment's dashboard for AppsFlyer integration, then import Segment-AppsFlyer:

```objective-c
#import <segment-appsflyer-ios/SEGAppsFlyerIntegration.h>

```

You can now init the Analytics with AppsFlyer integration:

```objective-c
SEGAnalyticsConfiguration *config = [SEGAnalyticsConfiguration configurationWithWriteKey:@"YOUR_WRITE_KEY"];
SEGAppsFlyerIntegrationFactory *afFactory = [SEGAppsFlyerIntegrationFactory instance];
[config use:afFactory];
[SEGAnalytics setupWithConfiguration:config];
```

AppsFlyer integration responds to ```identify``` call.  To read more about it, visit [Segment identify method documentation](https://segment.com/docs/libraries/ios/#identify).
In identify call ```traits``` dictionary  ```setCustomerUserID``` and ```currencyCode```


## License

```
The MIT License (MIT)

Copyright (c) 2016 AppsFlyer

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
