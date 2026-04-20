// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CreatorShortVideoApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "CreatorShortVideoApp",
            targets: ["CreatorShortVideoApp"]
        ),
        .library(
            name: "CreatorShortVideoAppUI",
            targets: ["CreatorShortVideoAppUI"]
        ),
        .library(
            name: "CreatorShortVideoAppCore",
            targets: ["CreatorShortVideoAppCore"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CreatorShortVideoApp",
            dependencies: [
                "CreatorShortVideoAppUI",
                "CreatorShortVideoAppCore"
            ]
        ),
        .target(
            name: "CreatorShortVideoAppUI",
            dependencies: [
                "CreatorShortVideoAppCore"
            ]
        ),
        .target(
            name: "CreatorShortVideoAppCore",
            dependencies: []
        ),
        .testTarget(
            name: "CreatorShortVideoAppTests",
            dependencies: ["CreatorShortVideoApp"]
        )
    ]
)
