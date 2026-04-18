// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "FinanceApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "FinanceApp",
            targets: ["FinanceApp"]
        ),
        .library(
            name: "FinanceAppUI",
            targets: ["FinanceAppUI"]
        ),
        .library(
            name: "FinanceAppCore",
            targets: ["FinanceAppCore"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.1")
    ],
    targets: [
        .target(
            name: "FinanceApp",
            dependencies: [
                "FinanceAppUI",
                "FinanceAppCore"
            ]
        ),
        .target(
            name: "FinanceAppUI",
            dependencies: [
                "FinanceAppCore"
            ]
        ),
        .target(
            name: "FinanceAppCore",
            dependencies: [
                "Alamofire"
            ]
        ),
        .testTarget(
            name: "FinanceAppTests",
            dependencies: ["FinanceApp"]
        )
    ]
)
