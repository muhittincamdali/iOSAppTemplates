// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "FinanceApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "FinanceApp", targets: ["FinanceApp"]),
        .library(name: "FinanceAppUI", targets: ["FinanceAppUI"]),
        .library(name: "FinanceAppCore", targets: ["FinanceAppCore"])
    ],
    targets: [
        .target(name: "FinanceApp", dependencies: ["FinanceAppUI", "FinanceAppCore"]),
        .target(name: "FinanceAppUI", dependencies: ["FinanceAppCore"]),
        .target(name: "FinanceAppCore"),
        .testTarget(name: "FinanceAppTests", dependencies: ["FinanceApp"])
    ]
)
