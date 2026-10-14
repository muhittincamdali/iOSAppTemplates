// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SubscriptionLifestyleApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "SubscriptionLifestyleApp", targets: ["SubscriptionLifestyleApp"]),
        .library(name: "SubscriptionLifestyleAppUI", targets: ["SubscriptionLifestyleAppUI"]),
        .library(name: "SubscriptionLifestyleAppCore", targets: ["SubscriptionLifestyleAppCore"])
    ],
    targets: [
        .target(name: "SubscriptionLifestyleApp", dependencies: ["SubscriptionLifestyleAppUI", "SubscriptionLifestyleAppCore"]),
        .target(name: "SubscriptionLifestyleAppUI", dependencies: ["SubscriptionLifestyleAppCore"]),
        .target(name: "SubscriptionLifestyleAppCore"),
        .testTarget(name: "SubscriptionLifestyleAppTests", dependencies: ["SubscriptionLifestyleApp"])
    ]
)
