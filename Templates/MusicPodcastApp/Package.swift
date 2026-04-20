// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "MusicPodcastApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "MusicPodcastApp",
            targets: ["MusicPodcastApp"]
        ),
        .library(
            name: "MusicPodcastAppUI",
            targets: ["MusicPodcastAppUI"]
        ),
        .library(
            name: "MusicPodcastAppCore",
            targets: ["MusicPodcastAppCore"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MusicPodcastApp",
            dependencies: [
                "MusicPodcastAppUI",
                "MusicPodcastAppCore"
            ]
        ),
        .target(
            name: "MusicPodcastAppUI",
            dependencies: [
                "MusicPodcastAppCore"
            ]
        ),
        .target(
            name: "MusicPodcastAppCore",
            dependencies: []
        ),
        .testTarget(
            name: "MusicPodcastAppTests",
            dependencies: ["MusicPodcastApp"]
        )
    ]
)
