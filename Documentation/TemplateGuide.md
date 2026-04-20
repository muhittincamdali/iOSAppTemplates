# Template Guide

This page explains the current template surfaces in the repository. It avoids invented file contracts and unproven deployment claims.

## Current Template Surface

The repository currently has three major layers:

### 1. Root package discovery

Source:
- `Sources/iOSAppTemplates/iOSAppTemplates.swift`

This layer is used for:
- category mapping
- complexity mapping
- template discovery and search

### 2. Template family modules

Source:
- `Sources/SocialTemplates`
- `Sources/CommerceTemplates`
- `Sources/HealthTemplates`
- `Sources/ProductivityTemplates`
- `Sources/EducationTemplates`
- `Sources/FinanceTemplates`
- `Sources/TravelTemplates`
- `Sources/EntertainmentTemplates`
- `Sources/FoodTemplates`
- `Sources/AITemplates`
- `Sources/VisionOSTemplates`

This layer provides:
- models
- stores or managers
- sample data
- SwiftUI views
- sometimes app entry points

These families are not all at the same abstraction level. Some modules are closer to reference implementations, while others carry broader UI surfaces.

### 3. Standalone template roots

The public repo now tracks `20` standalone roots under `Templates/`.

Good first-entry roots:

- `Templates/SocialMediaApp`
- `Templates/EcommerceApp`
- `Templates/ProductivityApp`
- `Templates/FinanceApp`
- `Templates/TravelPlannerApp`

For the full routed list, use [Portfolio-Matrix.md](./Portfolio-Matrix.md).

These roots are the closest `open package and inspect app shell` surfaces in the repo. Generic iOS build proof is tracked separately from screenshot or demo proof.

## How To Choose A Starting Point

### If you want a social or feed flow
- `Sources/SocialTemplates/SocialMediaTemplate.swift`
- `Templates/SocialMediaApp`

### If you want a commerce or catalog flow
- `Sources/CommerceTemplates/CommerceTemplates.swift`
- `Templates/EcommerceApp`

### If you want a health or workout flow
- `Sources/HealthTemplates/FitnessHealthTemplate.swift`
- `Templates/FitnessApp`

### Reference-heavy advanced lanes
- `Sources/TCATemplates/SocialMediaTCATemplate.swift`
- `Sources/AITemplates/SmartPhotoTemplate.swift`
- `Sources/VisionOSTemplates/SpatialSocialTemplate.swift`

## What You Can Safely Customize Today

Based on the current repo truth, the safest customization areas are:

- sample data
- domain models
- SwiftUI screens
- product copy
- navigation flow
- category-specific feature slices

Not every template family has the same config filenames or design-token contract. Do not assume a fixed shape such as `AppColors.swift`, `AppFonts.swift`, or `AppConfig.swift` across every lane.

## Build And Inspection Flow

### Root package

```bash
open Package.swift
swift build
swift test
```

### Standalone roots

```bash
open Templates/SocialMediaApp/Package.swift
open Templates/EcommerceApp/Package.swift
open Templates/FitnessApp/Package.swift
open Templates/ProductivityApp/Package.swift
open Templates/FinanceApp/Package.swift
```

What this flow proves today:
- package manifest validity
- lane-specific source shells
- tracked generic iOS build proof for the standalone roots

What it does not prove yet:
- runtime screenshots
- demo clips
- equal release maturity across all lanes

## Deployment And App Store Notes

This repo currently provides:
- template families
- standalone roots
- reference implementations

It does not automatically guarantee:
- App Store submission readiness
- a TestFlight-ready binary
- identical CI proof depth for every lane
- runtime media proof for every root

If you want to ship a template, the safe flow is:

1. choose the relevant lane or standalone root
2. customize branding and data surfaces
3. add your own signing, bundle, and privacy setup
4. generate your own QA and release proof

## Complete App Claim

To count any template as a `complete app`, follow [Complete-App-Standard.md](./Complete-App-Standard.md).

Anything outside that standard should be treated as:
- a template family
- an example surface
- a reference implementation

## Next Reading

1. [First App Tutorial](./FirstApp.md)
2. [Template Showcase](./Template-Showcase.md)
3. [Proof Matrix](./Proof-Matrix.md)
4. [App Proof Surfaces](./App-Proofs/README.md)
5. [API Reference](./API-Reference.md)
6. [World-Class Audit](./World-Class-Audit-2026-04-15.md)
