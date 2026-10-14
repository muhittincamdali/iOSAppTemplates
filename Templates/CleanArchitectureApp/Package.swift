// swift-tools-version: 6.0

import PackageDescription

// Each layer is its own target, so the compiler enforces the dependency rule:
// Domain imports nothing, Data and Presentation import only Domain, and the
// CleanArchitectureApp target is the composition root that wires them together.
let package = Package(
    name: "CleanArchitectureApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "CleanArchitectureApp", targets: ["CleanArchitectureApp"])
    ],
    targets: [
        .target(name: "CleanArchitectureAppDomain"),
        .target(name: "CleanArchitectureAppData", dependencies: ["CleanArchitectureAppDomain"]),
        .target(name: "CleanArchitectureAppPresentation", dependencies: ["CleanArchitectureAppDomain"]),
        .target(
            name: "CleanArchitectureApp",
            dependencies: [
                "CleanArchitectureAppDomain",
                "CleanArchitectureAppData",
                "CleanArchitectureAppPresentation"
            ]
        ),
        .testTarget(name: "CleanArchitectureAppDomainTests", dependencies: ["CleanArchitectureAppDomain"]),
        .testTarget(
            name: "CleanArchitectureAppDataTests",
            dependencies: ["CleanArchitectureAppData", "CleanArchitectureAppDomain"]
        ),
        .testTarget(
            name: "CleanArchitectureAppPresentationTests",
            dependencies: ["CleanArchitectureAppPresentation", "CleanArchitectureAppDomain"]
        ),
        .testTarget(
            name: "CleanArchitectureAppTests",
            dependencies: [
                "CleanArchitectureApp",
                "CleanArchitectureAppData",
                "CleanArchitectureAppDomain",
                "CleanArchitectureAppPresentation"
            ]
        )
    ]
)
