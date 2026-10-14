// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "EcommerceApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "EcommerceApp", targets: ["EcommerceApp"])
    ],
    targets: [
        .target(name: "EcommerceApp"),
        .testTarget(name: "EcommerceAppTests", dependencies: ["EcommerceApp"])
    ]
)
