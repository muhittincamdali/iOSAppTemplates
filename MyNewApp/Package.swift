// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MyNewApp",
    platforms: [.iOS(.v18)],
    products: [.library(name: "MyNewApp", targets: ["MyNewApp"])],
    dependencies: [
        .package(url: "https://github.com/muhittincamdali/SwiftNetwork", from: "1.0.0"),
        .package(url: "https://github.com/muhittincamdali/SwiftCache", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "MyNewApp",
            dependencies: ["SwiftNetwork", "SwiftCache"],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        )
    ]
)