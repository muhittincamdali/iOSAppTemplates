// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "TeamCollaborationApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "TeamCollaborationApp", targets: ["TeamCollaborationApp"])
    ],
    targets: [
        .target(name: "TeamCollaborationApp"),
        .testTarget(name: "TeamCollaborationAppTests", dependencies: ["TeamCollaborationApp"])
    ]
)
