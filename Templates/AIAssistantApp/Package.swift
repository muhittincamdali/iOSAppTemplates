// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "AIAssistantApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "AIAssistantApp", targets: ["AIAssistantApp"])
    ],
    targets: [
        .target(name: "AIAssistantApp"),
        .testTarget(name: "AIAssistantAppTests", dependencies: ["AIAssistantApp"])
    ]
)
