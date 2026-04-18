// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ProductivityApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "ProductivityApp",
            targets: ["ProductivityApp"]
        ),
        .library(
            name: "ProductivityAppUI",
            targets: ["ProductivityAppUI"]
        ),
        .library(
            name: "ProductivityAppCore",
            targets: ["ProductivityAppCore"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.1")
    ],
    targets: [
        .target(
            name: "ProductivityApp",
            dependencies: [
                "ProductivityAppUI",
                "ProductivityAppCore"
            ]
        ),
        .target(
            name: "ProductivityAppUI",
            dependencies: [
                "ProductivityAppCore"
            ]
        ),
        .target(
            name: "ProductivityAppCore",
            dependencies: [
                "Alamofire"
            ]
        ),
        .testTarget(
            name: "ProductivityAppTests",
            dependencies: ["ProductivityApp"]
        )
    ]
)
