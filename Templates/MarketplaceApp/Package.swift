// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "MarketplaceApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "MarketplaceApp",
            targets: ["MarketplaceApp"]
        ),
        .library(
            name: "MarketplaceAppUI",
            targets: ["MarketplaceAppUI"]
        ),
        .library(
            name: "MarketplaceAppCore",
            targets: ["MarketplaceAppCore"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MarketplaceApp",
            dependencies: [
                "MarketplaceAppUI",
                "MarketplaceAppCore"
            ]
        ),
        .target(
            name: "MarketplaceAppUI",
            dependencies: [
                "MarketplaceAppCore"
            ]
        ),
        .target(
            name: "MarketplaceAppCore",
            dependencies: []
        ),
        .testTarget(
            name: "MarketplaceAppTests",
            dependencies: ["MarketplaceApp"]
        )
    ]
)
