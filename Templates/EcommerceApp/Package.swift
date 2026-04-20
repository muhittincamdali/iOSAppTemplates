// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EcommerceApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "EcommerceApp",
            targets: ["EcommerceApp"]),
        .library(
            name: "EcommerceAppUI",
            targets: ["EcommerceAppUI"]),
        .library(
            name: "EcommerceAppCore",
            targets: ["EcommerceAppCore"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "EcommerceApp",
            dependencies: [
                "EcommerceAppUI",
                "EcommerceAppCore"
            ]),
        .target(
            name: "EcommerceAppUI",
            dependencies: [
                "EcommerceAppCore"
            ]),
        .target(
            name: "EcommerceAppCore",
            dependencies: []),
        .testTarget(
            name: "EcommerceAppTests",
            dependencies: ["EcommerceApp"])
    ]
) 
