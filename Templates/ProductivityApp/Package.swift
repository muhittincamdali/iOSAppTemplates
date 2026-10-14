// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ProductivityApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "ProductivityApp", targets: ["ProductivityApp"])
    ],
    targets: [
        .target(name: "ProductivityApp"),
        .testTarget(name: "ProductivityAppTests", dependencies: ["ProductivityApp"])
    ]
)
