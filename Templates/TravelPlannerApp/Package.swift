// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "TravelPlannerApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "TravelPlannerApp",
            targets: ["TravelPlannerApp"]
        ),
        .library(
            name: "TravelPlannerAppUI",
            targets: ["TravelPlannerAppUI"]
        ),
        .library(
            name: "TravelPlannerAppCore",
            targets: ["TravelPlannerAppCore"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.1")
    ],
    targets: [
        .target(
            name: "TravelPlannerApp",
            dependencies: [
                "TravelPlannerAppUI",
                "TravelPlannerAppCore"
            ]
        ),
        .target(
            name: "TravelPlannerAppUI",
            dependencies: [
                "TravelPlannerAppCore"
            ]
        ),
        .target(
            name: "TravelPlannerAppCore",
            dependencies: [
                "Alamofire"
            ]
        ),
        .testTarget(
            name: "TravelPlannerAppTests",
            dependencies: ["TravelPlannerApp"]
        )
    ]
)
