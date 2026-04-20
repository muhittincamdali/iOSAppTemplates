# Examples Hub

This folder is not a full complete-app gallery yet. Its current role is:

- source-level reference
- lightweight onboarding example
- richer lane examples for tracked app packs

## Canonical Example Router

| Surface | Type | Use it for |
| --- | --- | --- |
| [BasicExample.swift](./BasicExample.swift) | single-file reference | inspect the package API quickly |
| [BasicExample/BasicExample.swift](./BasicExample/BasicExample.swift) | small example shell | inspect minimal structure |
| [QuickStartExample/QuickStartApp.swift](./QuickStartExample/QuickStartApp.swift) | onboarding entry | reach the fastest source-level start |
| [EcommerceExample](./EcommerceExample/) | richer category example | inspect a more product-like commerce flow |
| [SocialMediaExample](./SocialMediaExample/) | richer category example | inspect a more product-like social flow |
| [ProductivityExample](./ProductivityExample/) | richer category example | inspect a more product-like productivity flow |
| [FinanceExample](./FinanceExample/) | richer category example | inspect a more product-like finance flow |
| [EducationExample](./EducationExample/) | richer category example | inspect a more product-like education flow |
| [FoodDeliveryExample](./FoodDeliveryExample/) | richer category example | inspect a more product-like food delivery flow |
| [TravelPlannerExample](./TravelPlannerExample/) | richer category example | inspect a more product-like travel planning flow |
| [AIAssistantExample](./AIAssistantExample/) | richer category example | inspect a more product-like AI assistant flow |
| [NewsBlogExample](./NewsBlogExample/) | richer category example | inspect a more product-like editorial/news flow |
| [MusicPodcastExample](./MusicPodcastExample/) | richer category example | inspect a more product-like music and podcast flow |

## Important Truth

- Not everything in this folder is a separate runnable Xcode project.
- The most reliable standalone package-entry path today is under `Templates/`.
- The most reliable repo validation path today is root `swift build` and `swift test`.

## If You Want To Run Something

### Package truth

```bash
swift build
swift test
```

### Inspect standalone roots

```bash
open ../Templates/SocialMediaApp/Package.swift
open ../Templates/EcommerceApp/Package.swift
open ../Templates/FitnessApp/Package.swift
open ../Templates/ProductivityApp/Package.swift
open ../Templates/FinanceApp/Package.swift
open ../Templates/EducationApp/Package.swift
open ../Templates/FoodDeliveryApp/Package.swift
open ../Templates/TravelPlannerApp/Package.swift
open ../Templates/AIAssistantApp/Package.swift
open ../Templates/NewsBlogApp/Package.swift
open ../Templates/MusicPodcastApp/Package.swift
```

### Generator path

```bash
swift ../Scripts/TemplateGenerator.swift --interactive
```

## Related Docs

- [../Documentation/Guides/QuickStart.md](../Documentation/Guides/QuickStart.md)
- [../Documentation/Portfolio-Matrix.md](../Documentation/Portfolio-Matrix.md)
- [../Documentation/Template-Showcase.md](../Documentation/Template-Showcase.md)
- [../Documentation/TemplateGuide.md](../Documentation/TemplateGuide.md)
- [../Documentation/Proof-Matrix.md](../Documentation/Proof-Matrix.md)
- [../Documentation/App-Proofs/README.md](../Documentation/App-Proofs/README.md)
- [../Documentation/Complete-App-Standard.md](../Documentation/Complete-App-Standard.md)
- [../Documentation/Wave-1-Implementation-Plan.md](../Documentation/Wave-1-Implementation-Plan.md)
