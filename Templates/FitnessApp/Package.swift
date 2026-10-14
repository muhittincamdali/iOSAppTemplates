// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FitnessApp",
    platforms: [
        .iOS(.v18)
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
    dependencies: [],
    targets: [
        .target(
            name: "FitnessApp",
            dependencies: [
                "FitnessAppUI",
                "FitnessAppCore"
            ]),
        .target(
            name: "FitnessAppUI",
            dependencies: [
                "FitnessAppCore"
            ]),
        .target(
            name: "FitnessAppCore",
            dependencies: []),
        .testTarget(
            name: "FitnessAppTests",
            dependencies: ["FitnessApp"])
    ]
) 
