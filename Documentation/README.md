# Documentation Hub

This page is the canonical documentation router for `iOSAppTemplates`.

## Current Repo Truth

- `Sources/` is the canonical template-family surface
- `Templates/` currently ships `13` standalone app roots
- `Examples/` is still a mixed reference/example area, not a 20-app gallery
- the product goal is broad complete-app parity, not a claim that parity exists today

## Start By Goal

| Goal | Start here |
| --- | --- |
| Evaluate the repo quickly | [Guides/QuickStart.md](./Guides/QuickStart.md) |
| See the installation reality | [Guides/Installation.md](./Guides/Installation.md) |
| Understand the complete-app contract | [Complete-App-Standard.md](./Complete-App-Standard.md) |
| See the current portfolio map | [Portfolio-Matrix.md](./Portfolio-Matrix.md) |
| See the tracked gallery | [Template-Showcase.md](./Template-Showcase.md) |
| See lane-by-lane proof status | [Proof-Matrix.md](./Proof-Matrix.md) |
| See canonical app proof pages | [App-Proofs/README.md](./App-Proofs/README.md) |
| See canonical app media pages | [App-Media/README.md](./App-Media/README.md) |
| Read the market-backed 20-app strategy | [World-Class-20-App-Strategy-2026-04-19.md](./World-Class-20-App-Strategy-2026-04-19.md) |
| See the Wave 1 execution plan | [Wave-1-Implementation-Plan.md](./Wave-1-Implementation-Plan.md) |
| Inspect template families | [TemplateGuide.md](./TemplateGuide.md) |
| Inspect the examples router | [../Examples/README.md](../Examples/README.md) |
| Read the hard gap audit | [World-Class-Audit-2026-04-15.md](./World-Class-Audit-2026-04-15.md) |

## Core Surfaces

### Onboarding

- [Guides/QuickStart.md](./Guides/QuickStart.md)
- [Guides/Installation.md](./Guides/Installation.md)
- [FirstApp.md](./FirstApp.md)

### Product And Portfolio

- [Portfolio-Matrix.md](./Portfolio-Matrix.md)
- [Template-Showcase.md](./Template-Showcase.md)
- [Proof-Matrix.md](./Proof-Matrix.md)
- [App-Proofs/README.md](./App-Proofs/README.md)
- [App-Media/README.md](./App-Media/README.md)
- [World-Class-20-App-Strategy-2026-04-19.md](./World-Class-20-App-Strategy-2026-04-19.md)
- [Wave-1-Implementation-Plan.md](./Wave-1-Implementation-Plan.md)
- [Wave-1-App-Pack-Spec.md](./Wave-1-App-Pack-Spec.md)
- [TemplateGuide.md](./TemplateGuide.md)
- [VisionProGuide.md](./VisionProGuide.md)
- [ArchitectureTemplatesGuide.md](./ArchitectureTemplatesGuide.md)
- `Templates/EcommerceApp/README.md`
- `Templates/SocialMediaApp/README.md`
- `Templates/FitnessApp/README.md`
- `Templates/ProductivityApp/README.md`
- `Templates/FinanceApp/README.md`
- `Templates/EducationApp/README.md`
- `Templates/FoodDeliveryApp/README.md`
- `Templates/TravelPlannerApp/README.md`
- `Templates/AIAssistantApp/README.md`
- `Templates/NewsBlogApp/README.md`
- `Templates/MusicPodcastApp/README.md`
- `Templates/MarketplaceApp/README.md`
- `Templates/MessagingApp/README.md`

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

## What To Treat Carefully

Some repository surfaces still point to future complete-app parity.

If a page carries a big claim, verify it against:

- [Complete-App-Standard.md](./Complete-App-Standard.md)
- [Portfolio-Matrix.md](./Portfolio-Matrix.md)
- [Proof-Matrix.md](./Proof-Matrix.md)

## Version Baseline

Top-level package baseline:

- Swift 6
- iOS 18
- macOS 15
- tvOS 18
- watchOS 11
- visionOS 2

Standalone template roots should currently be treated as iOS-only app-shell surfaces, not as full parity with the top-level package contract.
