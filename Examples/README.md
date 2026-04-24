# Examples Hub

Generated from `Documentation/app-surface-catalog.json`.

This folder is not a complete-app gallery. Its current role is:

- source-level reference
- lightweight onboarding example
- richer lane examples for `19` tracked app packs

## Canonical Example Router

| Surface | Type | Use it for |
| --- | --- | --- |
| [BasicExample.swift](./BasicExample.swift) | single-file reference | inspect the package API quickly |
| [BasicExample/BasicExample.swift](./BasicExample/BasicExample.swift) | small example shell | inspect minimal structure |
| [QuickStartExample/QuickStartApp.swift](./QuickStartExample/QuickStartApp.swift) | onboarding entry | reach the fastest source-level start |
| [EcommerceExample](./EcommerceExample/) | richer category example | inspect a more product-like e-commerce store flow |
| [SocialMediaExample](./SocialMediaExample/) | richer category example | inspect a more product-like social media flow |
| [ProductivityExample](./ProductivityExample/) | richer category example | inspect a more product-like productivity / tasks flow |
| [FinanceExample](./FinanceExample/) | richer category example | inspect a more product-like finance / budgeting flow |
| [EducationExample](./EducationExample/) | richer category example | inspect a more product-like education / learning flow |
| [FoodDeliveryExample](./FoodDeliveryExample/) | richer category example | inspect a more product-like food delivery flow |
| [TravelPlannerExample](./TravelPlannerExample/) | richer category example | inspect a more product-like travel planner flow |
| [AIAssistantExample](./AIAssistantExample/) | richer category example | inspect a more product-like ai assistant flow |
| [NewsBlogExample](./NewsBlogExample/) | richer category example | inspect a more product-like news / editorial flow |
| [MusicPodcastExample](./MusicPodcastExample/) | richer category example | inspect a more product-like music / podcast flow |
| [MarketplaceExample](./MarketplaceExample/) | richer category example | inspect a more product-like marketplace flow |
| [MessagingExample](./MessagingExample/) | richer category example | inspect a more product-like messaging / community flow |
| [BookingReservationsExample](./BookingReservationsExample/) | richer category example | inspect a more product-like booking & reservations flow |
| [NotesKnowledgeExample](./NotesKnowledgeExample/) | richer category example | inspect a more product-like notes / knowledge base flow |
| [CreatorShortVideoExample](./CreatorShortVideoExample/) | richer category example | inspect a more product-like creator / short video flow |
| [TeamCollaborationExample](./TeamCollaborationExample/) | richer category example | inspect a more product-like team collaboration flow |
| [CRMAdminExample](./CRMAdminExample/) | richer category example | inspect a more product-like crm / admin companion flow |
| [SubscriptionLifestyleExample](./SubscriptionLifestyleExample/) | richer category example | inspect a more product-like subscription lifestyle / habit tracker flow |
| [PrivacyVaultExample](./PrivacyVaultExample/) | richer category example | inspect a more product-like privacy / secure vault flow |

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
open ../Templates/EcommerceApp/Package.swift
open ../Templates/SocialMediaApp/Package.swift
open ../Templates/FitnessApp/Package.swift
open ../Templates/ProductivityApp/Package.swift
open ../Templates/FinanceApp/Package.swift
open ../Templates/EducationApp/Package.swift
open ../Templates/FoodDeliveryApp/Package.swift
open ../Templates/TravelPlannerApp/Package.swift
open ../Templates/AIAssistantApp/Package.swift
open ../Templates/NewsBlogApp/Package.swift
open ../Templates/MusicPodcastApp/Package.swift
open ../Templates/MarketplaceApp/Package.swift
open ../Templates/MessagingApp/Package.swift
open ../Templates/BookingReservationsApp/Package.swift
open ../Templates/NotesKnowledgeApp/Package.swift
open ../Templates/CreatorShortVideoApp/Package.swift
open ../Templates/TeamCollaborationApp/Package.swift
open ../Templates/CRMAdminApp/Package.swift
open ../Templates/SubscriptionLifestyleApp/Package.swift
open ../Templates/PrivacyVaultApp/Package.swift
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
