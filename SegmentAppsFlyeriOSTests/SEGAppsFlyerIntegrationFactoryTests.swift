//
//  SegmentAppsFlyeriOSTests.swift
//  SegmentAppsFlyeriOSTests
//
//  Created by Moris Gateno on 27/12/2022.
//  Copyright © 2022 Andrii Hahan. All rights reserved.
//

import XCTest
import SegmentAppsFlyeriOS



final class SegmentAppsFlyeriOSTests: XCTestCase , SEGAppsFlyerLibDelegate, SEGAppsFlyerDeepLinkDelegate {
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        print("onConversionDataSuccess")
    }
    
    func onConversionDataFail(_ error: Error) {
        print("onConversionDataFail")
    }
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //
    //instance
    //
    func testSEGAppsFlyerIntegrationFactory_instance_happyFlow() throws {
        let factoryObject = SEGAppsFlyerIntegrationFactory.instance()
        XCTAssertNil(factoryObject?.delegate)
        XCTAssertNil(factoryObject?.dlDelegate)
        XCTAssertEqual(factoryObject?.manualMode,false)
    }
    
    //
    //createWithLaunchDelegate
    //
    func testSEGAppsFlyerIntegrationFactory_createWithLaunchDelegate_happyFlow() throws {
        let factoryObject = SEGAppsFlyerIntegrationFactory.create(withLaunch:self)
        XCTAssertNotNil(factoryObject?.delegate)
        XCTAssertTrue(((factoryObject?.delegate.isEqual(self)) != nil))
        XCTAssertNil(factoryObject?.dlDelegate)
        XCTAssertEqual(factoryObject?.manualMode,false)
    }
    
    func testSEGAppsFlyerIntegrationFactory_createWithLaunchDelegate_nilFlow() throws {
        let factoryObject = SEGAppsFlyerIntegrationFactory.create(withLaunch:nil)
        XCTAssertNil(factoryObject?.delegate)
    }
    
    //
    //createWithLaunchDelegate andDeepLinkDelegate
    //
    
    func testSEGAppsFlyerIntegrationFactory_createWithLaunchDelegateandDeepLinkDelegate_happyFlow() throws {
        let factoryObject = SEGAppsFlyerIntegrationFactory.create(withLaunch: self, andDeepLinkDelegate: self)
        XCTAssertNotNil(factoryObject?.delegate)
        XCTAssertNotNil(factoryObject?.dlDelegate)
        XCTAssertTrue(((factoryObject?.delegate.isEqual(self)) != nil))
        XCTAssertTrue(((factoryObject?.dlDelegate.isEqual(self)) != nil))
        XCTAssertEqual(factoryObject?.manualMode,false)
    }
    
    func testSEGAppsFlyerIntegrationFactory_createWithLaunchDelegateandDeepLinkDelegate_nilFlow() throws {
        let factoryObject = SEGAppsFlyerIntegrationFactory.create(withLaunch: nil, andDeepLinkDelegate: nil)
        XCTAssertNil(factoryObject?.delegate)
        XCTAssertNil(factoryObject?.dlDelegate)
    }
    
    //
    //createWithLaunchDelegate andManualMode
    //
    
    func testSEGAppsFlyerIntegrationFactory_createWithLaunchDelegateandManualMode_happyFlow() throws {
        var factoryObject = SEGAppsFlyerIntegrationFactory.create(withLaunch: self, andManualMode: true)
        XCTAssertNotNil(factoryObject?.delegate)
        XCTAssertNil(factoryObject?.dlDelegate)
        XCTAssertTrue(((factoryObject?.delegate.isEqual(self)) != nil))
        XCTAssertEqual(factoryObject?.manualMode,true)
        factoryObject = SEGAppsFlyerIntegrationFactory.create(withLaunch: self, andManualMode: false)
        XCTAssertEqual(factoryObject?.manualMode,false)
    }
    
    //
    //createWithLaunchDelegate andDeepLinkDelegate andManualMode
    //
    func testSEGAppsFlyerIntegrationFactory_createWithLaunchDelegateandDeepLinkDelegateandManualMode_happyFlow() throws {
        let factoryObject = SEGAppsFlyerIntegrationFactory.create(withLaunch: self, andDeepLinkDelegate: self, andManualMode: true)
        XCTAssertNotNil(factoryObject?.delegate)
        XCTAssertNotNil(factoryObject?.dlDelegate)
        XCTAssertTrue(((factoryObject?.delegate.isEqual(self)) != nil))
        XCTAssertTrue(((factoryObject?.dlDelegate.isEqual(self)) != nil))
        XCTAssertEqual(factoryObject?.manualMode,true)
    }
    
    //
    //createWithSettings
    //
    func testSEGAppsFlyerIntegrationFactory_createWithSettings_happyFlow() throws {
        let factoryObject = SEGAppsFlyerIntegrationFactory.create(withLaunch: self, andDeepLinkDelegate: self, andManualMode: true)
        let integrationObject : SEGAppsFlyerIntegration = factoryObject?.create(withSettings: Dictionary(), for: Analytics()) as! SEGAppsFlyerIntegration
        XCTAssertNotNil(integrationObject)
        XCTAssertTrue(integrationObject.manualMode==true)
        XCTAssertTrue(integrationObject.segDelegate.isEqual(self))
        XCTAssertTrue(integrationObject.segDLDelegate.isEqual(self))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
