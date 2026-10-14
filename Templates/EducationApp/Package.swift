// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "EducationApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "EducationApp", targets: ["EducationApp"])
    ],
    targets: [
        .target(name: "EducationApp"),
        .testTarget(name: "EducationAppTests", dependencies: ["EducationApp"])
    ]
)
