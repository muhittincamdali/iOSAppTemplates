// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "MusicPodcastApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "MusicPodcastApp", targets: ["MusicPodcastApp"])
    ],
    targets: [
        .target(name: "MusicPodcastApp"),
        .testTarget(name: "MusicPodcastAppTests", dependencies: ["MusicPodcastApp"])
    ]
)
