# First App Tutorial

The fastest first success in this repository comes from two paths:

1. inspect the root package surface
2. open one of the standalone app roots under `Templates/`

This page describes the shortest credible path based on the current repository truth. It does not rely on invented generator or config APIs.

## Which First Path Is Better?

### If you want to inspect an app shell immediately

Start with one of these standalone roots:

- `Templates/SocialMediaApp`
- `Templates/EcommerceApp`
- `Templates/ProductivityApp`
- `Templates/FinanceApp`

These are the clearest first-entry standalone roots. They have package-level proof and tracked generic iOS build proof.

### If you want to understand the package surface first

Start here:

- `Sources/iOSAppTemplates/iOSAppTemplates.swift`

This gives you:
- `TemplateManager.shared`
- category filtering
- complexity filtering
- search behavior

## Prerequisites

- Xcode `16+`
- Swift `6+`
- a macOS environment that can run Swift Package builds

## Option A: Build and Inspect the Root Package

```bash
git clone https://github.com/muhittincamdali/iOSAppTemplates.git
cd iOSAppTemplates
open Package.swift
```

Then validate the package:

```bash
swift build
swift test
```

Minimal inspection:

```swift
import iOSAppTemplates

let manager = TemplateManager.shared
let allTemplates = manager.searchTemplates(query: "")
let commerceTemplates = manager.getTemplates(category: .commerce)
let socialTemplates = manager.searchTemplates(query: "social")
```

This path validates:
- the root metadata surface
- the category map
- the search behavior

## Option B: Open and Inspect a Standalone Root

Fastest UI-first path:

```bash
open Templates/SocialMediaApp/Package.swift
```

The same pattern also applies to:

```bash
open Templates/EcommerceApp/Package.swift
open Templates/FitnessApp/Package.swift
open Templates/TravelPlannerApp/Package.swift
open Templates/AIAssistantApp/Package.swift
```

These roots provide:
- a standalone app shell
- a package-level app entry
- their own dependency and platform baseline

They do not automatically prove runtime screenshots or demo clips.

## Where To Go Next

### Social lane
- `Sources/SocialTemplates/SocialMediaTemplate.swift`
- `Sources/TCATemplates/SocialMediaTCATemplate.swift`

### Commerce lane
- `Sources/CommerceTemplates/CommerceTemplates.swift`

### Health lane
- `Sources/HealthTemplates/FitnessHealthTemplate.swift`
- `Sources/HealthTemplates/HealthTemplates.swift`

## What This Page Does Not Promise

This tutorial does not claim:

- one-step shipping readiness
- store-submission proof
- hardened security guarantees
- fixed coverage, launch, or performance metrics

Current truthful claim:
- the repo offers a combination of template family, standalone root, and reference implementation surfaces
- for the stricter `complete app` bar, follow [Complete-App-Standard.md](./Complete-App-Standard.md)

## Recommended Next Steps

1. [Quick Start](./Guides/QuickStart.md)
2. [Template Guide](./TemplateGuide.md)
3. [API Reference](./API-Reference.md)
4. [Complete App Standard](./Complete-App-Standard.md)
