// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CRMAdminApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "CRMAdminApp", targets: ["CRMAdminApp"])
    ],
    targets: [
        .target(name: "CRMAdminApp"),
        .testTarget(name: "CRMAdminAppTests", dependencies: ["CRMAdminApp"])
    ]
)
