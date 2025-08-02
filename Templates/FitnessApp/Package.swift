// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FitnessApp",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "FitnessApp",
            targets: ["FitnessApp"]),
        .library(
            name: "FitnessAppUI",
            targets: ["FitnessAppUI"]),
        .library(
            name: "FitnessAppCore",
            targets: ["FitnessAppCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.1"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.18.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.9.1"),
        .package(url: "https://github.com/danielgindi/Charts.git", from: "5.0.0"),
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.54.0")
    ],
    targets: [
        .target(
            name: "FitnessApp",
            dependencies: [
                "FitnessAppUI",
                "FitnessAppCore",
                "Alamofire",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                "Kingfisher",
                "Charts"
            ]),
        .target(
            name: "FitnessAppUI",
            dependencies: [
                "FitnessAppCore"
            ]),
        .target(
            name: "FitnessAppCore",
            dependencies: [
                "Alamofire"
            ]),
        .testTarget(
            name: "FitnessAppTests",
            dependencies: ["FitnessApp"])
    ]
) 