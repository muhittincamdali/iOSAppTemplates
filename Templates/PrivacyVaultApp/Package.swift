// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "PrivacyVaultApp",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "PrivacyVaultApp", targets: ["PrivacyVaultApp"]),
        .library(name: "PrivacyVaultAppUI", targets: ["PrivacyVaultAppUI"]),
        .library(name: "PrivacyVaultAppCore", targets: ["PrivacyVaultAppCore"])
    ],
    targets: [
        .target(name: "PrivacyVaultApp", dependencies: ["PrivacyVaultAppUI", "PrivacyVaultAppCore"]),
        .target(name: "PrivacyVaultAppUI", dependencies: ["PrivacyVaultAppCore"]),
        .target(name: "PrivacyVaultAppCore"),
        .testTarget(name: "PrivacyVaultAppTests", dependencies: ["PrivacyVaultApp"])
    ]
)
