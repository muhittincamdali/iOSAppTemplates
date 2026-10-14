// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "EducationApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "EducationApp", targets: ["EducationApp"]),
        .library(name: "EducationAppUI", targets: ["EducationAppUI"]),
        .library(name: "EducationAppCore", targets: ["EducationAppCore"])
    ],
    targets: [
        .target(name: "EducationApp", dependencies: ["EducationAppUI", "EducationAppCore"]),
        .target(name: "EducationAppUI", dependencies: ["EducationAppCore"]),
        .target(name: "EducationAppCore"),
        .testTarget(name: "EducationAppTests", dependencies: ["EducationApp"])
    ]
)
