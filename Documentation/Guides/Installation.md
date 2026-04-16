# Installation Guide

Bu sayfa mevcut repo yapisina gore gercek kurulum yolunu anlatir. Ship edilmeyen custom generator veya distribution contract'lerini varsaymaz.

## Prerequisites

### Required
- macOS uzerinde Swift Package build ortami
- Xcode `16+`
- Swift `6+`

### Helpful but optional
- Apple Developer account
- visionOS simulator
- Firebase/third-party service hesaplari

Not:
- Apple Developer account sadece device signing veya distribution icin gerekir
- root package build/test icin zorunlu degildir

## Installation Method 1: Clone The Repo

En dogru ilk kurulum:

```bash
git clone https://github.com/muhittincamdali/iOSAppTemplates.git
cd iOSAppTemplates
open Package.swift
```

Dogrulama:

```bash
swift build
swift test
```

## Installation Method 2: Add As Swift Package Dependency

SPM ile baglamak istiyorsan mevcut public package products'tan sec.

Minimal ornek:

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

Ihtiyaca gore product secenekleri:
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

Not:
- versioned release yerine branch pinlemek burada daha dogru ornek; cunku repo truth-reset asamasinda ve latest public version surface ayrica dogrulanmali

## First Verification

Root package'ta:

```bash
swift build
swift test
```

Beklenen truth:
- package compile olmali
- aktif package test graph gecmeli

## Standalone Template Roots

Bugun acikca gorunen standalone roots:

```bash
open Templates/SocialMediaApp/Package.swift
open Templates/EcommerceApp/Package.swift
open Templates/FitnessApp/Package.swift
```

Bu roots, root package'tan farkli olarak daha dogrudan app-shell inspection yuzeyi sunar.

## What This Page Does Not Assume

Bu guide su contract'leri varsaymaz:
- Xcode template wizard
- automatic project generator API
- ready-made `.env` or `Config.xcconfig` contract
- guaranteed App Store distribution setup

Bunlar consuming app tarafinda ayri kurulmalidir.

## Recommended Next Steps

1. [Quick Start](./QuickStart.md)
2. [Template Guide](../TemplateGuide.md)
3. [First App Tutorial](../FirstApp.md)
4. [Complete App Standard](../Complete-App-Standard.md)
