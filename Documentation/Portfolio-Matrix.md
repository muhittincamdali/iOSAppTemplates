# Current Portfolio Matrix

Last updated: 2026-04-19

This page is the canonical current-vs-target product map for `iOSAppTemplates`.

It exists to:

- show what the repository really ships today
- keep the gap visible on the way to `20 provable complete apps`
- give README, docs, and examples one canonical product router

## Status Labels

- `Standalone Root`: `Templates/` contains a manifest-valid app package entry and source shell
- `Template Family`: `Sources/` contains a lane-level source surface
- `Example Surface`: `Examples/` contains an inspection or richer learning path
- `App Proof Surface`: a canonical per-app proof page exists
- `App Media Surface`: a canonical per-app media page exists
- `Complete App Target`: the intended world-class app for that lane

## Current 15-Lane Surface

| Lane | Today | Best current route | Target complete app |
| --- | --- | --- | --- |
| Commerce | Standalone Root + Template Family + Example Surface + App Proof Surface + App Media Surface | `Templates/EcommerceApp` or `Documentation/App-Proofs/EcommerceApp.md` | E-Commerce Store |
| Social | Standalone Root + Template Family + Example Surface + App Proof Surface + App Media Surface | `Templates/SocialMediaApp` or `Documentation/App-Proofs/SocialMediaApp.md` | Social Media |
| News | Standalone Root + Template Family + Example Surface + App Proof Surface + App Media Surface | `Templates/NewsBlogApp` or `Documentation/App-Proofs/NewsBlogApp.md` | News / Editorial |
| Marketplace | Standalone Root + Example Surface + App Proof Surface + App Media Surface | `Templates/MarketplaceApp` or `Documentation/App-Proofs/MarketplaceApp.md` | Marketplace |
| Messaging / Community | Standalone Root + Example Surface + App Proof Surface + App Media Surface | `Templates/MessagingApp` or `Documentation/App-Proofs/MessagingApp.md` | Messaging / Community |
| Booking / Reservations | Standalone Root + Example Surface + App Proof Surface + App Media Surface | `Templates/BookingReservationsApp` or `Documentation/App-Proofs/BookingReservationsApp.md` | Booking & Reservations |
| Notes / Knowledge | Standalone Root + Example Surface + App Proof Surface + App Media Surface | `Templates/NotesKnowledgeApp` or `Documentation/App-Proofs/NotesKnowledgeApp.md` | Notes / Knowledge Base |
| Health / Fitness | Standalone Root + Template Family + App Proof Surface + App Media Surface | `Templates/FitnessApp` or `Documentation/App-Proofs/FitnessApp.md` | Health / Fitness |
| Finance | Standalone Root + Template Family + Example Surface + App Proof Surface + App Media Surface | `Templates/FinanceApp` or `Documentation/App-Proofs/FinanceApp.md` | Finance / Budgeting |
| Education | Standalone Root + Template Family + Example Surface + App Proof Surface + App Media Surface | `Templates/EducationApp` or `Documentation/App-Proofs/EducationApp.md` | Education / Learning |
| Food Delivery | Standalone Root + Template Family + Example Surface + App Proof Surface + App Media Surface | `Templates/FoodDeliveryApp` or `Documentation/App-Proofs/FoodDeliveryApp.md` | Food Delivery |
| Travel | Standalone Root + Template Family + Example Surface + App Proof Surface + App Media Surface | `Templates/TravelPlannerApp` or `Documentation/App-Proofs/TravelPlannerApp.md` | Travel Planner |
| AI | Standalone Root + Template Family + Example Surface + App Proof Surface + App Media Surface | `Templates/AIAssistantApp` or `Documentation/App-Proofs/AIAssistantApp.md` | AI Assistant |
| Music / Podcast | Standalone Root + Template Family + Example Surface + App Proof Surface + App Media Surface | `Templates/MusicPodcastApp` or `Documentation/App-Proofs/MusicPodcastApp.md` | Music / Podcast |
| Productivity | Standalone Root + Template Family + Example Surface + App Proof Surface + App Media Surface | `Templates/ProductivityApp` or `Documentation/App-Proofs/ProductivityApp.md` | Productivity / Tasks |

## Current Truth

- the repository currently has `15` standalone app roots
- the generator currently covers the broad starter map via `swift Scripts/TemplateGenerator.swift --list`
- this `15 lane` surface does not equal `15 complete apps`
- the `Complete App` label is governed only by [Complete-App-Standard.md](./Complete-App-Standard.md)

## 20 Complete App Expansion Map

### Wave 1: Highest-Impact Complete Apps

1. E-Commerce Store
2. Social Media
3. Productivity / Tasks
4. Finance / Budgeting
5. Education / Learning
6. Food Delivery
7. Travel Planner
8. AI Assistant

### Wave 2: Coverage Expansion

9. Marketplace
10. Messaging / Community
11. Health / Fitness
12. News / Editorial
13. Booking & Reservations
14. Notes / Knowledge Base
15. Creator / Short Video
16. Music / Podcast

### Wave 3: Premium Differentiation

17. Team Collaboration
18. CRM / Admin Companion
19. Subscription Lifestyle / Habit Tracker
20. Privacy / Secure Vault

The market reasoning for this order lives in [World-Class-20-App-Strategy-2026-04-19.md](./World-Class-20-App-Strategy-2026-04-19.md).

The repository-level implementation contract for these eight apps lives in [Wave-1-Implementation-Plan.md](./Wave-1-Implementation-Plan.md).

## How To Read The Repo Today

### If you want a standalone package root now

- `Templates/EcommerceApp`
- `Templates/SocialMediaApp`
- `Templates/FitnessApp`
- `Templates/ProductivityApp`
- `Templates/FinanceApp`
- `Templates/EducationApp`
- `Templates/FoodDeliveryApp`
- `Templates/TravelPlannerApp`
- `Templates/AIAssistantApp`
- `Templates/NewsBlogApp`
- `Templates/MusicPodcastApp`
- `Templates/MarketplaceApp`
- `Templates/MessagingApp`
- `Templates/BookingReservationsApp`
- `Templates/NotesKnowledgeApp`

### If you want the cleanest proof pages now

- [App-Proofs/EcommerceApp.md](./App-Proofs/EcommerceApp.md)
- [App-Proofs/SocialMediaApp.md](./App-Proofs/SocialMediaApp.md)
- [App-Proofs/FitnessApp.md](./App-Proofs/FitnessApp.md)
- [App-Proofs/ProductivityApp.md](./App-Proofs/ProductivityApp.md)
- [App-Proofs/FinanceApp.md](./App-Proofs/FinanceApp.md)
- [App-Proofs/EducationApp.md](./App-Proofs/EducationApp.md)
- [App-Proofs/FoodDeliveryApp.md](./App-Proofs/FoodDeliveryApp.md)
- [App-Proofs/TravelPlannerApp.md](./App-Proofs/TravelPlannerApp.md)
- [App-Proofs/AIAssistantApp.md](./App-Proofs/AIAssistantApp.md)
- [App-Proofs/NewsBlogApp.md](./App-Proofs/NewsBlogApp.md)
- [App-Proofs/MusicPodcastApp.md](./App-Proofs/MusicPodcastApp.md)
- [App-Proofs/MarketplaceApp.md](./App-Proofs/MarketplaceApp.md)
- [App-Proofs/MessagingApp.md](./App-Proofs/MessagingApp.md)
- [App-Proofs/BookingReservationsApp.md](./App-Proofs/BookingReservationsApp.md)
- [App-Proofs/NotesKnowledgeApp.md](./App-Proofs/NotesKnowledgeApp.md)

### If you want the canonical media router now

- [App-Media/README.md](./App-Media/README.md)

### If you want broad category coverage now

- `swift Scripts/TemplateGenerator.swift --list`
- `swift Scripts/TemplateGenerator.swift --interactive`
- lane-specific files under `Sources/`

### If you want the product gap without marketing noise

- [Complete-App-Standard.md](./Complete-App-Standard.md)
- [World-Class-20-App-Strategy-2026-04-19.md](./World-Class-20-App-Strategy-2026-04-19.md)
- [World-Class-Audit-2026-04-15.md](./World-Class-Audit-2026-04-15.md)

## Hard Rule

Count only what can be routed, built, shown, and defended.
