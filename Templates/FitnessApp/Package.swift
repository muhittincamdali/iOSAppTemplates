// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "FitnessApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "FitnessApp", targets: ["FitnessApp"])
    ],
    targets: [
        .target(name: "FitnessApp"),
        .testTarget(name: "FitnessAppTests", dependencies: ["FitnessApp"])
    ]
)
