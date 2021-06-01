// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "segment-appsflyer-ios",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "segment-appsflyer-ios",
            targets: ["segment-appsflyer-ios"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/segmentio/analytics-ios.git" , from: "4.0.0"),
        .package(url: "https://github.com/AppsFlyerSDK/AppsFlyerFramework.git", from: "6.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "segment-appsflyer-ios",
            dependencies: [], 
            path: "segment-appsflyer-ios/", 
            sources: ["Classes"]),
        .testTarget(
            name: "segment-appsflyer-iosTests",
            dependencies: ["segment-appsflyer-ios"]),
    ]
)
