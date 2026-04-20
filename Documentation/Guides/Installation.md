# Installation Guide

This page explains the truthful installation path for the current repository. It does not assume generator features, distribution contracts, or shipping guarantees that are not published today.

## Prerequisites

### Required

- macOS with a working Swift Package toolchain
- Xcode `16+`
- Swift `6+`

### Helpful But Optional

- Apple Developer account for signing or device deployment
- Simulator runtimes for iOS or visionOS exploration
- third-party service accounts when adapting templates into a real product

## Installation Method 1: Clone The Repository

This is the canonical first path:

```bash
git clone https://github.com/muhittincamdali/iOSAppTemplates.git
cd iOSAppTemplates
open Package.swift
```

Verify the current maintained graph:

```bash
swift build -c release
swift test
```

## Installation Method 2: Add As A Swift Package Dependency

If you want to consume the root package products from another app:

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "YourApp",
    platforms: [
        .iOS(.v18)
    ],
    dependencies: [
        .package(url: "https://github.com/muhittincamdali/iOSAppTemplates.git", branch: "master")
    ],
    targets: [
        .target(
            name: "YourApp",
            dependencies: [
                .product(name: "iOSAppTemplates", package: "iOSAppTemplates")
            ]
        )
    ]
)
```

Current product options include:

- `iOSAppTemplates`
- `SocialTemplates`
- `CommerceTemplates`
- `HealthTemplates`
- `ProductivityTemplates`
- `EntertainmentTemplates`
- `EducationTemplates`
- `FinanceTemplates`
- `TravelTemplates`
- `TCATemplates`
- `VisionOSTemplates`
- `AITemplates`
- `PerformanceTemplates`
- `SecurityTemplates`

Branch pinning is the most truthful example today because the live latest release surface is still being tightened.

## First Verification

At the repo root:

```bash
swift build -c release
swift test
```

Expected current truth:

- the root package should compile
- the active package test graph should pass

## Standalone App Roots

The standalone app roots live under `Templates/` and are iOS-focused app-shell surfaces. Start with:

```bash
open Templates/SocialMediaApp/Package.swift
open Templates/EcommerceApp/Package.swift
open Templates/FitnessApp/Package.swift
open Templates/ProductivityApp/Package.swift
open Templates/FinanceApp/Package.swift
```

Use [Portfolio Matrix](../Portfolio-Matrix.md) and [Proof Matrix](../Proof-Matrix.md) to see what each root currently proves.

## What This Page Does Not Assume

This guide does not assume:

- an Xcode template wizard
- one-command project generation to a finished shipping app
- ready-made `.env` or `Config.xcconfig` contracts
- guaranteed App Store distribution readiness

Those concerns still belong to the consuming product app.

## Recommended Next Steps

1. [Quick Start](./QuickStart.md)
2. [Complete App Standard](../Complete-App-Standard.md)
3. [Portfolio Matrix](../Portfolio-Matrix.md)
4. [Release Process](../Release-Process.md)
