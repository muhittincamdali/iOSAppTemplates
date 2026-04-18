# Documentation Hub

Bu sayfa `iOSAppTemplates` icin canonical docs router'dir.

## Current Repo Truth

- `Sources/` canonical template-family surface
- `Templates/` altinda `3` standalone app root var
- `Examples/` karisik reference/example alani; henuz 20 app gallery degil
- genis complete-app parity hedef, bugunku parity claim'i degil

## Start By Goal

| Goal | Start here |
| --- | --- |
| Repo'yu hizli degerlendirmek | [Guides/QuickStart.md](./Guides/QuickStart.md) |
| Gercek kurulum yolunu gormek | [Guides/Installation.md](./Guides/Installation.md) |
| Complete-app standardini anlamak | [Complete-App-Standard.md](./Complete-App-Standard.md) |
| Current portfolio map'i gormek | [Portfolio-Matrix.md](./Portfolio-Matrix.md) |
| Tracked gallery'yi gormek | [Template-Showcase.md](./Template-Showcase.md) |
| Lane proof seviyesini gormek | [Proof-Matrix.md](./Proof-Matrix.md) |
| Standalone root proof sayfalarini gormek | [App-Proofs/README.md](./App-Proofs/README.md) |
| Media truth seviyesini gormek | [App-Media/README.md](./App-Media/README.md) |
| Template ailelerini incelemek | [TemplateGuide.md](./TemplateGuide.md) |
| Example/router yuzeyini gormek | [../Examples/README.md](../Examples/README.md) |
| Repo gap audit'ini okumak | [World-Class-Audit-2026-04-15.md](./World-Class-Audit-2026-04-15.md) |

## Core Surfaces

### Onboarding

- [Guides/QuickStart.md](./Guides/QuickStart.md)
- [Guides/Installation.md](./Guides/Installation.md)
- [FirstApp.md](./FirstApp.md)

### Template And Product Surfaces

- [Portfolio-Matrix.md](./Portfolio-Matrix.md)
- [Template-Showcase.md](./Template-Showcase.md)
- [Proof-Matrix.md](./Proof-Matrix.md)
- [App-Proofs/README.md](./App-Proofs/README.md)
- [App-Media/README.md](./App-Media/README.md)
- [TemplateGuide.md](./TemplateGuide.md)
- [VisionProGuide.md](./VisionProGuide.md)
- [ArchitectureTemplatesGuide.md](./ArchitectureTemplatesGuide.md)
- `Templates/EcommerceApp/README.md`
- `Templates/SocialMediaApp/README.md`
- `Templates/FitnessApp/README.md`

### API And Package Surfaces

- [API-Reference.md](./API-Reference.md)
- [API.md](./API.md)
- [ArchitectureAPI.md](./ArchitectureAPI.md)
- [SecurityAPI.md](./SecurityAPI.md)

### Validation And Trust

- [Guides/TestingGuide.md](./Guides/TestingGuide.md)
- [../SECURITY.md](../SECURITY.md)
- [../CONTRIBUTING.md](../CONTRIBUTING.md)
- [World-Class-Audit-2026-04-15.md](./World-Class-Audit-2026-04-15.md)

## What To Ignore For Now

Bu repo icinde henuz complete-app gallery parity'sine ulasmamis alanlar var. Bir yuzey buyuk bir iddia tasiyorsa once su iki sayfayi kontrol et:

- [Complete-App-Standard.md](./Complete-App-Standard.md)
- [World-Class-Audit-2026-04-15.md](./World-Class-Audit-2026-04-15.md)

## Version Baseline

Top-level package baseline:

- Swift 6
- iOS 18
- macOS 15
- tvOS 18
- watchOS 11
- visionOS 2

Standalone template roots bu noktada iOS-only app-shell surface olarak ele alinmalidir; top-level package baseline ile birebir ayni contract sayilmaz.
