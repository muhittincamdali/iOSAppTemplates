// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "EducationApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "EducationApp",
            targets: ["EducationApp"]
        ),
        .library(
            name: "EducationAppUI",
            targets: ["EducationAppUI"]
        ),
        .library(
            name: "EducationAppCore",
            targets: ["EducationAppCore"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.1")
    ],
    targets: [
        .target(
            name: "EducationApp",
            dependencies: [
                "EducationAppUI",
                "EducationAppCore"
            ]
        ),
        .target(
            name: "EducationAppUI",
            dependencies: [
                "EducationAppCore"
            ]
        ),
        .target(
            name: "EducationAppCore",
            dependencies: [
                "Alamofire"
            ]
        ),
        .testTarget(
            name: "EducationAppTests",
            dependencies: ["EducationApp"]
        )
    ]
)
