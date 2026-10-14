// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SubscriptionLifestyleApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "SubscriptionLifestyleApp", targets: ["SubscriptionLifestyleApp"])
    ],
    targets: [
        .target(name: "SubscriptionLifestyleApp"),
        .testTarget(name: "SubscriptionLifestyleAppTests", dependencies: ["SubscriptionLifestyleApp"])
    ]
)
