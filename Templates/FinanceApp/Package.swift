// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "FinanceApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "FinanceApp", targets: ["FinanceApp"])
    ],
    targets: [
        .target(name: "FinanceApp"),
        .testTarget(name: "FinanceAppTests", dependencies: ["FinanceApp"])
    ]
)
