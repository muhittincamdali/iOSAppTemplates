// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "MessagingApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "MessagingApp", targets: ["MessagingApp"])
    ],
    targets: [
        .target(name: "MessagingApp"),
        .testTarget(name: "MessagingAppTests", dependencies: ["MessagingApp"])
    ]
)
