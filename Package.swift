// swift-tools-version: 6.0

import PackageDescription

// The app templates live in Templates/ as standalone iOS packages.
// This root package contains the tooling that scaffolds new projects from them.
let package = Package(
    name: "iOSAppTemplates",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "create-ios-app", targets: ["create-ios-app"]),
        .library(name: "TemplateScaffold", targets: ["TemplateScaffold"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0")
    ],
    targets: [
        .target(name: "TemplateScaffold"),
        .executableTarget(
            name: "create-ios-app",
            dependencies: [
                "TemplateScaffold",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "Sources/CLI"
        ),
        .testTarget(name: "TemplateScaffoldTests", dependencies: ["TemplateScaffold"])
    ]
)
