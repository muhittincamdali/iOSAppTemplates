// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SocialMediaApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "SocialMediaApp", targets: ["SocialMediaApp"])
    ],
    targets: [
        .target(name: "SocialMediaApp"),
        .testTarget(name: "SocialMediaAppTests", dependencies: ["SocialMediaApp"])
    ]
)
