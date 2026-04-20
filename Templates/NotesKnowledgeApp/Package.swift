// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "NotesKnowledgeApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "NotesKnowledgeApp",
            targets: ["NotesKnowledgeApp"]
        ),
        .library(
            name: "NotesKnowledgeAppUI",
            targets: ["NotesKnowledgeAppUI"]
        ),
        .library(
            name: "NotesKnowledgeAppCore",
            targets: ["NotesKnowledgeAppCore"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "NotesKnowledgeApp",
            dependencies: [
                "NotesKnowledgeAppUI",
                "NotesKnowledgeAppCore"
            ]
        ),
        .target(
            name: "NotesKnowledgeAppUI",
            dependencies: [
                "NotesKnowledgeAppCore"
            ]
        ),
        .target(
            name: "NotesKnowledgeAppCore",
            dependencies: []
        ),
        .testTarget(
            name: "NotesKnowledgeAppTests",
            dependencies: ["NotesKnowledgeApp"]
        )
    ]
)
