// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "MessagingApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "MessagingApp",
            targets: ["MessagingApp"]
        ),
        .library(
            name: "MessagingAppUI",
            targets: ["MessagingAppUI"]
        ),
        .library(
            name: "MessagingAppCore",
            targets: ["MessagingAppCore"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MessagingApp",
            dependencies: [
                "MessagingAppUI",
                "MessagingAppCore"
            ]
        ),
        .target(
            name: "MessagingAppUI",
            dependencies: [
                "MessagingAppCore"
            ]
        ),
        .target(
            name: "MessagingAppCore",
            dependencies: []
        ),
        .testTarget(
            name: "MessagingAppTests",
            dependencies: ["MessagingApp"]
        )
    ]
)
