// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "iOSAppTemplates",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "create-ios-app", targets: ["create-ios-app"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0")
    ],
    targets: [
        .executableTarget(
            name: "create-ios-app",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "Sources/CLI"
        )
    ]
)
