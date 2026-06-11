// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "VisionEmpire",
    platforms: [.iOS(.v18), .visionOS(.v2)],
    products: [.library(name: "VisionEmpire", targets: ["VisionEmpire"])],
    dependencies: [
        .package(url: "https://github.com/muhittincamdali/SwiftNetwork", from: "1.0.0"),
        .package(url: "https://github.com/muhittincamdali/SwiftCache", from: "1.0.0"),
        .package(url: "https://github.com/muhittincamdali/VisionOS-UI-Framework", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "VisionEmpire",
            dependencies: [
                "SwiftNetwork",
                "SwiftCache",
                "VisionOS-UI-Framework"
            ],
            path: "Sources",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        )
    ]
)