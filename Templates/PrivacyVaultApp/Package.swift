// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "PrivacyVaultApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "PrivacyVaultApp", targets: ["PrivacyVaultApp"])
    ],
    targets: [
        .target(name: "PrivacyVaultApp"),
        .testTarget(name: "PrivacyVaultAppTests", dependencies: ["PrivacyVaultApp"])
    ]
)
