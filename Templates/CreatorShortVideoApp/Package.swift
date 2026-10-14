// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CreatorShortVideoApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "CreatorShortVideoApp", targets: ["CreatorShortVideoApp"]),
        .library(name: "CreatorShortVideoAppUI", targets: ["CreatorShortVideoAppUI"]),
        .library(name: "CreatorShortVideoAppCore", targets: ["CreatorShortVideoAppCore"])
    ],
    targets: [
        .target(name: "CreatorShortVideoApp", dependencies: ["CreatorShortVideoAppUI", "CreatorShortVideoAppCore"]),
        .target(name: "CreatorShortVideoAppUI", dependencies: ["CreatorShortVideoAppCore"]),
        .target(name: "CreatorShortVideoAppCore"),
        .testTarget(name: "CreatorShortVideoAppTests", dependencies: ["CreatorShortVideoApp"])
    ]
)
