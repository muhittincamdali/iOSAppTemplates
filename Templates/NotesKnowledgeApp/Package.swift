// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "NotesKnowledgeApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "NotesKnowledgeApp", targets: ["NotesKnowledgeApp"])
    ],
    targets: [
        .target(name: "NotesKnowledgeApp"),
        .testTarget(name: "NotesKnowledgeAppTests", dependencies: ["NotesKnowledgeApp"])
    ]
)
