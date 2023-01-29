//
//  AppDelegate.swift
//  SwiftPodsSample
//
//  Created by Vitaly Sokolov on 12.08.2020.
//

import UIKit
import Segment
import AppsFlyerLib
import AppTrackingTransparency

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
   
        // For AppsFLyer debug logs uncomment the line below
        AppsFlyerLib.shared().isDebug = true
        
//        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
        /*
         Based on your needs you can either pass a delegate to process deferred
         and direct deeplinking callbacks or disregard them.
         If you choose to use the delegate, see extension to this class below
         */
//        let factoryWithDelegate : SEGAppsFlyerIntegrationFactory = SEGAppsFlyerIntegrationFactory.create(withLaunch: self)
        let factoryWithDelegate: SEGAppsFlyerIntegrationFactory = SEGAppsFlyerIntegrationFactory.create(withLaunch: self, andDeepLinkDelegate: self)
      // let factoryNoDelegate = SEGAppsFlyerIntegrationFactory()
        
        // Segment initialization
        let config = AnalyticsConfiguration(writeKey: "SEGMENT_KEY")
        config.use(factoryWithDelegate)
        //      config.use(factoryNoDelegate)
        config.enableAdvertisingTracking = true       //OPTIONAL
        config.trackApplicationLifecycleEvents = true //OPTIONAL
        config.trackDeepLinks = true                  //OPTIONAL
        config.trackPushNotifications = true          //OPTIONAL
    
        
        Analytics.debug(true)
        Analytics.setup(with: config)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { (status) in
                // ...
            })
        }
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: restorationHandler)
        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        AppsFlyerLib.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        AppsFlyerLib.shared().handleOpen(url, options: options)
        return true
    }
}

extension AppDelegate: SEGAppsFlyerLibDelegate {
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        print("GCD: " + conversionInfo.description)
    }
    
    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]) {
        print("OAOA: " + attributionData.description)
    }
    func onConversionDataFail(_ error: Error) {
        print("\(error)")
    }
    
    func onAppOpenAttributionFailure(_ error: Error) {
        print("\(error)")
    }
}

extension AppDelegate: SEGAppsFlyerDeepLinkDelegate {
    
    func didResolveDeepLink(_ result: DeepLinkResult) {
        
        print(result)
    }
}

