// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "GalacticVault",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [.library(name: "GalacticVault", targets: ["GalacticVault"])],
    dependencies: [
        .package(url: "https://github.com/muhittincamdali/SwiftNetwork", from: "1.1.0"),
        .package(url: "https://github.com/muhittincamdali/SwiftCache", from: "1.0.0"),
        .package(url: "https://github.com/muhittincamdali/MobileLogger", from: "1.0.0"),
        .package(url: "https://github.com/muhittincamdali/SwiftAI", from: "1.2.0"),
        .package(url: "https://github.com/muhittincamdali/SwiftPersistence", from: "1.0.0"),
        .package(url: "https://github.com/muhittincamdali/iOSSecurityTools", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "GalacticVault",
            dependencies: [
                "SwiftNetwork",
                "SwiftCache",
                "MobileLogger",
                "SwiftAI",
                "SwiftPersistence",
                "iOSSecurityTools"
            ],
            path: "Sources",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        )
    ]
)