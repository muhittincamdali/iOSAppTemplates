// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CRMAdminApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "CRMAdminApp",
            targets: ["CRMAdminApp"]
        ),
        .library(
            name: "CRMAdminAppUI",
            targets: ["CRMAdminAppUI"]
        ),
        .library(
            name: "CRMAdminAppCore",
            targets: ["CRMAdminAppCore"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CRMAdminApp",
            dependencies: [
                "CRMAdminAppUI",
                "CRMAdminAppCore"
            ]
        ),
        .target(
            name: "CRMAdminAppUI",
            dependencies: [
                "CRMAdminAppCore"
            ]
        ),
        .target(
            name: "CRMAdminAppCore",
            dependencies: []
        ),
        .testTarget(
            name: "CRMAdminAppTests",
            dependencies: ["CRMAdminApp"]
        )
    ]
)
