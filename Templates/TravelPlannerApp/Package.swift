// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "TravelPlannerApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "TravelPlannerApp", targets: ["TravelPlannerApp"])
    ],
    targets: [
        .target(name: "TravelPlannerApp"),
        .testTarget(name: "TravelPlannerAppTests", dependencies: ["TravelPlannerApp"])
    ]
)
