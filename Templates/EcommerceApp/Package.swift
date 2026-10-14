// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "EcommerceApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "EcommerceApp", targets: ["EcommerceApp"]),
        .library(name: "EcommerceAppUI", targets: ["EcommerceAppUI"]),
        .library(name: "EcommerceAppCore", targets: ["EcommerceAppCore"])
    ],
    targets: [
        .target(name: "EcommerceApp", dependencies: ["EcommerceAppUI", "EcommerceAppCore"]),
        .target(name: "EcommerceAppUI", dependencies: ["EcommerceAppCore"]),
        .target(name: "EcommerceAppCore"),
        .testTarget(name: "EcommerceAppTests", dependencies: ["EcommerceApp"])
    ]
)
