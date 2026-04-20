// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "NewsBlogApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "NewsBlogApp",
            targets: ["NewsBlogApp"]
        ),
        .library(
            name: "NewsBlogAppUI",
            targets: ["NewsBlogAppUI"]
        ),
        .library(
            name: "NewsBlogAppCore",
            targets: ["NewsBlogAppCore"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "NewsBlogApp",
            dependencies: [
                "NewsBlogAppUI",
                "NewsBlogAppCore"
            ]
        ),
        .target(
            name: "NewsBlogAppUI",
            dependencies: [
                "NewsBlogAppCore"
            ]
        ),
        .target(
            name: "NewsBlogAppCore",
            dependencies: []
        ),
        .testTarget(
            name: "NewsBlogAppTests",
            dependencies: ["NewsBlogApp"]
        )
    ]
)
