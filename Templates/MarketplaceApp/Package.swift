// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "MarketplaceApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "MarketplaceApp", targets: ["MarketplaceApp"])
    ],
    targets: [
        .target(name: "MarketplaceApp"),
        .testTarget(name: "MarketplaceAppTests", dependencies: ["MarketplaceApp"])
    ]
)
