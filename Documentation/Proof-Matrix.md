# Proof Matrix

Last updated: 2026-04-20

This page shows the gap between the current public claim and the current proof, lane by lane.

Status meanings:

- `Strong`: route + build path + packaging + app-specific proof var
- `Medium`: route + packaging exist, but app-specific build or media proof is still missing
- `Low`: source-level coverage exists, but product proof is still weak

| Lane | Current Packaging | Current Proof | Strength | Next Missing Piece |
| --- | --- | --- | --- | --- |
| Commerce | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/EcommerceApp/Package.swift` is dependency-free so no external dependency lockfile is required, source shell exists, richer example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| Social | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/SocialMediaApp/Package.resolved` exists, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| Marketplace | standalone root + example | root package green, standalone manifest smoke green, `Templates/MarketplaceApp/Package.swift` is dependency-free so no external dependency lockfile is required, local standalone `swift test` passes, richer example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| Messaging / Community | standalone root + example | root package green, standalone manifest smoke green, `Templates/MessagingApp/Package.swift` is dependency-free so no external dependency lockfile is required, local standalone `swift test` passes, richer example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| Booking / Reservations | standalone root + example | root package green, standalone manifest smoke green, `Templates/BookingReservationsApp/Package.swift` is dependency-free so no external dependency lockfile is required, local standalone `swift test` passes, richer example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| Notes / Knowledge | standalone root + example | root package green, standalone manifest smoke green, `Templates/NotesKnowledgeApp/Package.swift` is dependency-free so no external dependency lockfile is required, local standalone `swift test` passes, richer example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| Creator / Short Video | standalone root + example | root package green, standalone manifest smoke green, `Templates/CreatorShortVideoApp/Package.swift` is dependency-free so no external dependency lockfile is required, local standalone `swift test` passes, richer example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| Team Collaboration | standalone root + example | root package green, standalone manifest smoke green, `Templates/TeamCollaborationApp/Package.swift` is dependency-free so no external dependency lockfile is required, local standalone `swift test` passes, richer example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| CRM / Admin | standalone root + example | root package green, standalone manifest smoke green, `Templates/CRMAdminApp/Package.swift` is dependency-free so no external dependency lockfile is required, local standalone `swift test` passes, richer example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| Subscription Lifestyle | standalone root + example | root package green, standalone manifest smoke green, `Templates/SubscriptionLifestyleApp/Package.swift` is dependency-free so no external dependency lockfile is required, local standalone `swift test` passes, richer example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| Privacy / Secure Vault | standalone root + example | root package green, standalone manifest smoke green, `Templates/PrivacyVaultApp/Package.swift` is dependency-free so no external dependency lockfile is required, local standalone `swift test` passes, richer example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| Health / Fitness | standalone root + template family | root package green, standalone manifest smoke green, `Templates/FitnessApp/Package.resolved` exists, source shell exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| Finance | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/FinanceApp/Package.resolved` exists, local standalone `swift test` passes, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| Education | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/EducationApp/Package.resolved` exists, local standalone `swift test` passes, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| Food Delivery | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/FoodDeliveryApp/Package.resolved` exists, local standalone `swift test` passes, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| Travel | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/TravelPlannerApp/Package.resolved` exists, local standalone `swift test` passes, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| AI | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/AIAssistantApp/Package.resolved` exists, local standalone `swift test` passes, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| News | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/NewsBlogApp/Package.swift` is dependency-free so no external dependency lockfile is required, local standalone `swift test` passes, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| Music / Podcast | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/MusicPodcastApp/Package.swift` is dependency-free so no external dependency lockfile is required, local standalone `swift test` passes, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| Productivity | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/ProductivityApp/Package.resolved` exists, local standalone `swift test` passes, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |

## Current Global Proof

- root `swift build -c release` passes
- root `swift test` passes
- generator `--list` passes
- generator sample app `build + test` passes
- standalone root manifest smoke passes
- deterministic `Package.resolved` coverage exists for 8 standalone roots with external packages
- canonical per-app proof pages exist for standalone roots
- canonical per-app media pages exist for 20 standalone roots, shareable gallery cards are published, and preview boards are published
- local generic iOS `xcodebuild` passes for `EcommerceApp`, `SocialMediaApp`, `FitnessApp`, `ProductivityApp`, `FinanceApp`, `EducationApp`, `FoodDeliveryApp`, `TravelPlannerApp`, `AIAssistantApp`, `NewsBlogApp`, `MusicPodcastApp`, `MarketplaceApp`, `MessagingApp`, `BookingReservationsApp`, `NotesKnowledgeApp`, `CreatorShortVideoApp`, `TeamCollaborationApp`, `CRMAdminApp`, `SubscriptionLifestyleApp`, and `PrivacyVaultApp`
- local standalone `swift test` passes for `ProductivityApp`, `FinanceApp`, `EducationApp`, `FoodDeliveryApp`, `TravelPlannerApp`, `AIAssistantApp`, `NewsBlogApp`, `MusicPodcastApp`, `MarketplaceApp`, `MessagingApp`, `BookingReservationsApp`, `NotesKnowledgeApp`, `CreatorShortVideoApp`, `TeamCollaborationApp`, `CRMAdminApp`, `SubscriptionLifestyleApp`, and `PrivacyVaultApp`
- GitHub workflows are truth-based and currently green

## App Proof Router

- [App-Proofs/README.md](./App-Proofs/README.md)
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
- [App-Proofs/CreatorShortVideoApp.md](./App-Proofs/CreatorShortVideoApp.md)
- [App-Proofs/TeamCollaborationApp.md](./App-Proofs/TeamCollaborationApp.md)
- [App-Proofs/CRMAdminApp.md](./App-Proofs/CRMAdminApp.md)
- [App-Proofs/SubscriptionLifestyleApp.md](./App-Proofs/SubscriptionLifestyleApp.md)
- [App-Proofs/PrivacyVaultApp.md](./App-Proofs/PrivacyVaultApp.md)

## What Is Still Missing

Main missing layers before a `20 complete apps` claim:

1. lane-specific per-app README
2. real runtime screenshots beyond the current card and preview layer
3. hosted standalone iOS CI proof for the tracked roots
4. screenshot and demo production for the current 20 roots

Required Wave 1 app-pack contract:

- [Wave-1-Implementation-Plan.md](./Wave-1-Implementation-Plan.md)
- [Wave-1-App-Pack-Spec.md](./Wave-1-App-Pack-Spec.md)

Tracked local standalone iOS build validator:

- [../Scripts/validate-standalone-ios-builds.sh](../Scripts/validate-standalone-ios-builds.sh)

## Rule

A lane does not count as a `complete app` just because source files exist for it.

Canonical standard for counting a `complete app`:
- [Complete-App-Standard.md](./Complete-App-Standard.md)
