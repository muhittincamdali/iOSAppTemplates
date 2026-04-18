# Current Portfolio Matrix

Last updated: 2026-04-18

Bu sayfa `iOSAppTemplates` icin current-vs-target product map'tir.

Amaç:

- bugun repo icinde neyin gercekten var oldugunu gostermek
- `20 provable complete apps` hedefine giderken lane bazli gap'i acik tutmak
- README, docs ve examples icin tek canonical portfolio router olmak

## Status Labels

- `Standalone Root`: `Templates/` altinda manifest-valid app package entry ve source shell var
- `Template Family`: `Sources/` altinda category-level source surface var
- `Example Surface`: `Examples/` altinda ek inspection path var
- `Complete App Target`: complete-app standardina gore hedef urun

## Current 10-Lane Surface

| Lane | Today | Best Current Route | Next Complete App Target |
| --- | --- | --- | --- |
| Commerce | Standalone Root + Template Family + App Proof Surface | `Templates/EcommerceApp` veya `Documentation/App-Proofs/EcommerceApp.md` | E-Commerce Store |
| Social | Standalone Root + Template Family + Example Surface + App Proof Surface | `Templates/SocialMediaApp` veya `Documentation/App-Proofs/SocialMediaApp.md` | Social Media |
| News | Template Family | `Sources/NewsTemplates/NewsBlogTemplate.swift` | News / Editorial |
| Health / Fitness | Standalone Root + Template Family + App Proof Surface | `Templates/FitnessApp` veya `Documentation/App-Proofs/FitnessApp.md` | Health / Fitness |
| Finance | Template Family | `Sources/FinanceTemplates/FinanceAppTemplate.swift` | Finance / Budgeting |
| Education | Template Family | `Sources/EducationTemplates/EducationAppTemplate.swift` | Education / Learning |
| Food Delivery | Template Family | `Sources/FoodTemplates/FoodDeliveryTemplate.swift` | Food Delivery |
| Travel | Template Family | `Sources/TravelTemplates/TravelAppTemplate.swift` | Travel Planner |
| Music / Podcast | Template Family | `Sources/MusicTemplates/MusicPodcastTemplate.swift` | Music / Podcast |
| Productivity | Template Family | `Sources/ProductivityTemplates/ProductivityAppTemplate.swift` | Productivity / Tasks |

## Current Truth

- Bugun net standalone app root sayisi `3`
- Generator bugun `10` lane icin starter shell uretiyor
- Bu `10 lane`, `10 complete app` demek degil
- `Complete App` etiketi sadece [Complete-App-Standard.md](./Complete-App-Standard.md) ile verilecek

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

## How To Read This Repo Today

### If you want a standalone package root now

- `Templates/EcommerceApp`
- `Templates/SocialMediaApp`
- `Templates/FitnessApp`

### If you want the cleanest standalone proof page now

- [App-Proofs/EcommerceApp.md](./App-Proofs/EcommerceApp.md)
- [App-Proofs/SocialMediaApp.md](./App-Proofs/SocialMediaApp.md)
- [App-Proofs/FitnessApp.md](./App-Proofs/FitnessApp.md)

### If you want broad category coverage now

- `swift Scripts/TemplateGenerator.swift --list`
- `swift Scripts/TemplateGenerator.swift --interactive`
- `Sources/` altindaki lane-specific template dosyalari

### If you want proof discipline

- [Complete-App-Standard.md](./Complete-App-Standard.md)
- [World-Class-Audit-2026-04-15.md](./World-Class-Audit-2026-04-15.md)

## Hard Rule

Count only what can be routed, opened, built, and shown.
