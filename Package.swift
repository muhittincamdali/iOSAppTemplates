// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOSAppTemplates",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2)
    ],
    products: [
        .library(name: "iOSAppTemplates", targets: ["iOSAppTemplates"]),
        .library(name: "SocialTemplates", targets: ["SocialTemplates"]),
        .library(name: "CommerceTemplates", targets: ["CommerceTemplates"]),
        .library(name: "HealthTemplates", targets: ["HealthTemplates"]),
        .library(name: "ProductivityTemplates", targets: ["ProductivityTemplates"]),
        .library(name: "EntertainmentTemplates", targets: ["EntertainmentTemplates"]),
        .library(name: "EducationTemplates", targets: ["EducationTemplates"]),
        .library(name: "FinanceTemplates", targets: ["FinanceTemplates"]),
        .library(name: "TravelTemplates", targets: ["TravelTemplates"]),
        .library(name: "TCATemplates", targets: ["TCATemplates"]),
        .library(name: "VisionOSTemplates", targets: ["VisionOSTemplates"]),
        .library(name: "AITemplates", targets: ["AITemplates"]),
        .library(name: "PerformanceTemplates", targets: ["PerformanceTemplates"]),
        .library(name: "SecurityTemplates", targets: ["SecurityTemplates"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-collections", from: "1.1.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.15.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0")
    ],
    targets: [
        // MARK: - CLI Tool
        .executableTarget(
            name: "create-ios-app",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "Sources/CLI"
        ),

        // MARK: - Main Target
        .target(
            name: "iOSAppTemplates",
            dependencies: [
                "SocialTemplates", "CommerceTemplates", "HealthTemplates",
                "ProductivityTemplates", "EntertainmentTemplates", "EducationTemplates",
                "FinanceTemplates", "TravelTemplates"
            ],
            path: "Sources/iOSAppTemplates"
        ),
        .target(name: "SocialTemplates", dependencies: [], path: "Sources/SocialTemplates"),
        .target(name: "CommerceTemplates", dependencies: [], path: "Sources/CommerceTemplates"),
        .target(name: "HealthTemplates", dependencies: [], path: "Sources/HealthTemplates"),
        .target(name: "ProductivityTemplates", dependencies: [], path: "Sources/ProductivityTemplates"),
        .target(name: "EntertainmentTemplates", dependencies: [], path: "Sources/EntertainmentTemplates"),
        .target(name: "EducationTemplates", dependencies: [], path: "Sources/EducationTemplates"),
        .target(name: "FinanceTemplates", dependencies: [], path: "Sources/FinanceTemplates"),
        .target(name: "TravelTemplates", dependencies: [], path: "Sources/TravelTemplates"),
        .target(
            name: "TCATemplates",
            dependencies: [.product(name: "ComposableArchitecture", package: "swift-composable-architecture")],
            path: "Sources/TCATemplates"
        ),
        .target(
            name: "VisionOSTemplates",
            dependencies: [.product(name: "ComposableArchitecture", package: "swift-composable-architecture")],
            path: "Sources/VisionOSTemplates"
        ),
        .target(
            name: "AITemplates",
            dependencies: [.product(name: "ComposableArchitecture", package: "swift-composable-architecture")],
            path: "Sources/AITemplates"
        ),
        .target(
            name: "PerformanceTemplates",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms")
            ],
            path: "Sources/PerformanceTemplates"
        ),
        .target(name: "SecurityTemplates", dependencies: [], path: "Sources/SecurityTemplates"),
        
        // Test targets
        .testTarget(name: "iOSAppTemplatesTests", dependencies: ["iOSAppTemplates"], path: "Tests/iOSAppTemplatesTests"),
        .testTarget(name: "PerformanceBenchmarkTests", dependencies: ["iOSAppTemplates", "PerformanceTemplates"], path: "Tests/PerformanceBenchmarkTests"),
        .testTarget(name: "SecuritySurfaceTests", dependencies: ["SecurityTemplates"], path: "Tests/SecuritySurfaceTests")
    ]
)
