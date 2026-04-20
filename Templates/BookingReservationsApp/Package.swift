// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "BookingReservationsApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "BookingReservationsApp",
            targets: ["BookingReservationsApp"]
        ),
        .library(
            name: "BookingReservationsAppUI",
            targets: ["BookingReservationsAppUI"]
        ),
        .library(
            name: "BookingReservationsAppCore",
            targets: ["BookingReservationsAppCore"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BookingReservationsApp",
            dependencies: [
                "BookingReservationsAppUI",
                "BookingReservationsAppCore"
            ]
        ),
        .target(
            name: "BookingReservationsAppUI",
            dependencies: [
                "BookingReservationsAppCore"
            ]
        ),
        .target(
            name: "BookingReservationsAppCore",
            dependencies: []
        ),
        .testTarget(
            name: "BookingReservationsAppTests",
            dependencies: ["BookingReservationsApp"]
        )
    ]
)
