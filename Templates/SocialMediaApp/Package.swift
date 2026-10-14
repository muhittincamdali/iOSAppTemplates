// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SocialMediaApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "SocialMediaApp", targets: ["SocialMediaApp"]),
        .library(name: "SocialMediaAppUI", targets: ["SocialMediaAppUI"]),
        .library(name: "SocialMediaAppCore", targets: ["SocialMediaAppCore"])
    ],
    targets: [
        .target(name: "SocialMediaApp", dependencies: ["SocialMediaAppUI", "SocialMediaAppCore"]),
        .target(name: "SocialMediaAppUI", dependencies: ["SocialMediaAppCore"]),
        .target(name: "SocialMediaAppCore"),
        .testTarget(name: "SocialMediaAppTests", dependencies: ["SocialMediaApp"])
    ]
)
