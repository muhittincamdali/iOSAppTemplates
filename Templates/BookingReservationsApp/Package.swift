// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "BookingReservationsApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "BookingReservationsApp", targets: ["BookingReservationsApp"])
    ],
    targets: [
        .target(name: "BookingReservationsApp"),
        .testTarget(name: "BookingReservationsAppTests", dependencies: ["BookingReservationsApp"])
    ]
)
