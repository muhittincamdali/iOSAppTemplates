// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EcommerceApp",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
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
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.1"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.18.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.9.1"),
        .package(url: "https://github.com/stripe/stripe-ios.git", from: "23.18.0"),
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.54.0")
    ],
    targets: [
        .target(
            name: "EcommerceApp",
            dependencies: [
                "EcommerceAppUI",
                "EcommerceAppCore",
                "Alamofire",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "Stripe", package: "stripe-ios"),
                "Kingfisher"
            ]),
        .target(
            name: "EcommerceAppUI",
            dependencies: [
                "EcommerceAppCore"
            ]),
        .target(
            name: "EcommerceAppCore",
            dependencies: [
                "Alamofire"
            ]),
        .testTarget(
            name: "EcommerceAppTests",
            dependencies: ["EcommerceApp"])
    ]
) 