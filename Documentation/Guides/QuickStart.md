# Quick Start Guide

The fastest first success path in `iOSAppTemplates` is not a one-command generator flow. It is inspecting the active package graph, the tracked standalone app roots, and the public proof surfaces that describe what is true today.

## Fastest Paths

### 1. Validate the root package graph

```bash
git clone https://github.com/muhittincamdali/iOSAppTemplates.git
cd iOSAppTemplates
open Package.swift
swift build -c release
swift test
```

Then inspect the public root surface:

```swift
import iOSAppTemplates

let manager = TemplateManager.shared
let allTemplates = manager.searchTemplates(query: "")
let commerce = manager.getTemplates(category: .commerce)
let social = manager.searchTemplates(query: "social")
```

This path validates:

- the root metadata surface
- the category and complexity map
- the search behavior
- the current maintained package graph

### 2. Inspect a standalone app root

The clearest current standalone roots are:

```bash
open Templates/SocialMediaApp/Package.swift
open Templates/EcommerceApp/Package.swift
open Templates/FitnessApp/Package.swift
open Templates/ProductivityApp/Package.swift
open Templates/FinanceApp/Package.swift
```

This path validates:

- manifest-valid package entry
- app-shell source surface
- lane-specific packaging
- current standalone-root truth

### 3. Inspect the public proof and gallery routers

Start with:

- [Template Showcase](../Template-Showcase.md)
- [Proof Matrix](../Proof-Matrix.md)
- [App Proof Surfaces](../App-Proofs/README.md)
- [App Media Surfaces](../App-Media/README.md)
- [App Gallery](../App-Gallery.md)

## Which Path Should You Pick?

### If you want to evaluate the repo quickly

- `Package.swift`
- `Sources/iOSAppTemplates/iOSAppTemplates.swift`
- [Complete App Standard](../Complete-App-Standard.md)
- [Portfolio Matrix](../Portfolio-Matrix.md)
- [Template Showcase](../Template-Showcase.md)
- [Proof Matrix](../Proof-Matrix.md)

### If you want to start from a visible app pack

- `Templates/SocialMediaApp`
- `Templates/EcommerceApp`
- `Templates/FitnessApp`
- `Templates/ProductivityApp`
- `Templates/FinanceApp`

### If you want to inspect the broad portfolio story

- [PROJECT_STATUS.md](../../PROJECT_STATUS.md)
- [GitHub Distribution](../GitHub-Distribution.md)
- [Release Process](../Release-Process.md)

## Current Truth

This repository currently ships:

- a maintained root package graph
- `20` standalone app roots under `Templates/`
- per-app proof pages for `20` roots
- per-app media pages for `20` roots
- published gallery cards and preview boards for `20` roots

This repository does not yet publicly prove:

- runtime screenshots for every app pack
- demo clips for every app pack
- hosted standalone iOS CI proof for every app pack
- equal complete-app maturity across all `20` lanes

The canonical standard for those claims is:

- [Complete App Standard](../Complete-App-Standard.md)

## Recommended Reading Order

1. [Installation](./Installation.md)
2. [Complete App Standard](../Complete-App-Standard.md)
3. [Portfolio Matrix](../Portfolio-Matrix.md)
4. [Template Showcase](../Template-Showcase.md)
5. [Proof Matrix](../Proof-Matrix.md)
6. [App Gallery](../App-Gallery.md)
