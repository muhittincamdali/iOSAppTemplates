// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "FoodDeliveryApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "FoodDeliveryApp", targets: ["FoodDeliveryApp"])
    ],
    targets: [
        .target(name: "FoodDeliveryApp"),
        .testTarget(name: "FoodDeliveryAppTests", dependencies: ["FoodDeliveryApp"])
    ]
)
