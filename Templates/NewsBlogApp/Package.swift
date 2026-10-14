// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "NewsBlogApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "NewsBlogApp", targets: ["NewsBlogApp"])
    ],
    targets: [
        .target(name: "NewsBlogApp"),
        .testTarget(name: "NewsBlogAppTests", dependencies: ["NewsBlogApp"])
    ]
)
