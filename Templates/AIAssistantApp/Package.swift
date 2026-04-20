// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "AIAssistantApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "AIAssistantApp",
            targets: ["AIAssistantApp"]
        ),
        .library(
            name: "AIAssistantAppUI",
            targets: ["AIAssistantAppUI"]
        ),
        .library(
            name: "AIAssistantAppCore",
            targets: ["AIAssistantAppCore"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.1")
    ],
    targets: [
        .target(
            name: "AIAssistantApp",
            dependencies: [
                "AIAssistantAppUI",
                "AIAssistantAppCore"
            ]
        ),
        .target(
            name: "AIAssistantAppUI",
            dependencies: [
                "AIAssistantAppCore"
            ]
        ),
        .target(
            name: "AIAssistantAppCore",
            dependencies: [
                "Alamofire"
            ]
        ),
        .testTarget(
            name: "AIAssistantAppTests",
            dependencies: ["AIAssistantApp"]
        )
    ]
)
