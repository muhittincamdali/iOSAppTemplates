// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SocialMediaApp",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "SocialMediaApp",
            targets: ["SocialMediaApp"]),
        .library(
            name: "SocialMediaAppUI",
            targets: ["SocialMediaAppUI"]),
        .library(
            name: "SocialMediaAppCore",
            targets: ["SocialMediaAppCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.1"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.18.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.9.1"),
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.54.0")
    ],
    targets: [
        .target(
            name: "SocialMediaApp",
            dependencies: [
                "SocialMediaAppUI",
                "SocialMediaAppCore",
                "Alamofire",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                "Kingfisher"
            ]),
        .target(
            name: "SocialMediaAppUI",
            dependencies: [
                "SocialMediaAppCore"
            ]),
        .target(
            name: "SocialMediaAppCore",
            dependencies: [
                "Alamofire"
            ]),
        .testTarget(
            name: "SocialMediaAppTests",
            dependencies: ["SocialMediaApp"])
    ]
) 