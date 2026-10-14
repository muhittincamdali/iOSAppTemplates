// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "FitnessApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "FitnessApp", targets: ["FitnessApp"]),
        .library(name: "FitnessAppUI", targets: ["FitnessAppUI"]),
        .library(name: "FitnessAppCore", targets: ["FitnessAppCore"])
    ],
    targets: [
        .target(name: "FitnessApp", dependencies: ["FitnessAppUI", "FitnessAppCore"]),
        .target(name: "FitnessAppUI", dependencies: ["FitnessAppCore"]),
        .target(name: "FitnessAppCore"),
        .testTarget(name: "FitnessAppTests", dependencies: ["FitnessApp"])
    ]
)
