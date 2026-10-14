// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "TeamCollaborationApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "TeamCollaborationApp", targets: ["TeamCollaborationApp"]),
        .library(name: "TeamCollaborationAppUI", targets: ["TeamCollaborationAppUI"]),
        .library(name: "TeamCollaborationAppCore", targets: ["TeamCollaborationAppCore"])
    ],
    targets: [
        .target(name: "TeamCollaborationApp", dependencies: ["TeamCollaborationAppUI", "TeamCollaborationAppCore"]),
        .target(name: "TeamCollaborationAppUI", dependencies: ["TeamCollaborationAppCore"]),
        .target(name: "TeamCollaborationAppCore"),
        .testTarget(name: "TeamCollaborationAppTests", dependencies: ["TeamCollaborationApp"])
    ]
)
