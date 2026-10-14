// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ProductivityApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "ProductivityApp", targets: ["ProductivityApp"]),
        .library(name: "ProductivityAppUI", targets: ["ProductivityAppUI"]),
        .library(name: "ProductivityAppCore", targets: ["ProductivityAppCore"])
    ],
    targets: [
        .target(name: "ProductivityApp", dependencies: ["ProductivityAppUI", "ProductivityAppCore"]),
        .target(name: "ProductivityAppUI", dependencies: ["ProductivityAppCore"]),
        .target(name: "ProductivityAppCore"),
        .testTarget(name: "ProductivityAppTests", dependencies: ["ProductivityApp"])
    ]
)
