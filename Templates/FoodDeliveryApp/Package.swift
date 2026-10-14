// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "FoodDeliveryApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "FoodDeliveryApp", targets: ["FoodDeliveryApp"]),
        .library(name: "FoodDeliveryAppUI", targets: ["FoodDeliveryAppUI"]),
        .library(name: "FoodDeliveryAppCore", targets: ["FoodDeliveryAppCore"])
    ],
    targets: [
        .target(name: "FoodDeliveryApp", dependencies: ["FoodDeliveryAppUI", "FoodDeliveryAppCore"]),
        .target(name: "FoodDeliveryAppUI", dependencies: ["FoodDeliveryAppCore"]),
        .target(name: "FoodDeliveryAppCore"),
        .testTarget(name: "FoodDeliveryAppTests", dependencies: ["FoodDeliveryApp"])
    ]
)
