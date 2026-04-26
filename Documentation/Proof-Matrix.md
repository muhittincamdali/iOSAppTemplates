# Proof Matrix

Last updated: 2026-04-20

This page shows the gap between the current public claim and the current proof, lane by lane.

Status meanings:

- `Strong`: route + build path + packaging + app-specific proof var
- `Medium`: route + packaging exist, but app-specific build or media proof is still missing
- `Low`: source-level coverage exists, but product proof is still weak

| Lane | Current Packaging | Current Proof | Strength | Next Missing Piece |
| --- | --- | --- | --- | --- |
| Commerce | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/EcommerceApp/Package.swift` is dependency-free so no external dependency lockfile is required, source shell exists, richer example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes, hosted standalone iOS proof workflow is active | Medium | media + stable green hosted standalone iOS baseline |
| Social | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/SocialMediaApp/Package.resolved` exists, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes, hosted standalone iOS proof workflow is active | Medium | media + stable green hosted standalone iOS baseline |
| Marketplace | standalone root + example | root package green, standalone manifest smoke green, `Templates/MarketplaceApp/Package.swift` is dependency-free so no external dependency lockfile is required, local standalone `swift test` passes, richer example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes, hosted standalone iOS proof workflow is active | Medium | media + stable green hosted standalone iOS baseline |
| Messaging / Community | standalone root + example | root package green, standalone manifest smoke green, `Templates/MessagingApp/Package.swift` is dependency-free so no external dependency lockfile is required, local standalone `swift test` passes, richer example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes, hosted standalone iOS proof workflow is active | Medium | media + stable green hosted standalone iOS baseline |
| Booking / Reservations | standalone root + example | root package green, standalone manifest smoke green, `Templates/BookingReservationsApp/Package.swift` is dependency-free so no external dependency lockfile is required, local standalone `swift test` passes, richer example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes, hosted standalone iOS proof workflow is active | Medium | media + stable green hosted standalone iOS baseline |
| Notes / Knowledge | standalone root + example | root package green, standalone manifest smoke green, `Templates/NotesKnowledgeApp/Package.swift` is dependency-free so no external dependency lockfile is required, local standalone `swift test` passes, richer example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes, hosted standalone iOS proof workflow is active | Medium | media + stable green hosted standalone iOS baseline |
| Creator / Short Video | standalone root + example | root package green, standalone manifest smoke green, `Templates/CreatorShortVideoApp/Package.swift` is dependency-free so no external dependency lockfile is required, local standalone `swift test` passes, richer example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes, hosted standalone iOS proof workflow is active | Medium | media + stable green hosted standalone iOS baseline |
| Team Collaboration | standalone root + example | root package green, standalone manifest smoke green, `Templates/TeamCollaborationApp/Package.swift` is dependency-free so no external dependency lockfile is required, local standalone `swift test` passes, richer example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes, hosted standalone iOS proof workflow is active | Medium | media + stable green hosted standalone iOS baseline |
| CRM / Admin | standalone root + example | root package green, standalone manifest smoke green, `Templates/CRMAdminApp/Package.swift` is dependency-free so no external dependency lockfile is required, local standalone `swift test` passes, richer example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes, hosted standalone iOS proof workflow is active | Medium | media + stable green hosted standalone iOS baseline |
| Subscription Lifestyle | standalone root + example | root package green, standalone manifest smoke green, `Templates/SubscriptionLifestyleApp/Package.swift` is dependency-free so no external dependency lockfile is required, local standalone `swift test` passes, richer example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes, hosted standalone iOS proof workflow is active | Medium | media + stable green hosted standalone iOS baseline |
| Privacy / Secure Vault | standalone root + example | root package green, standalone manifest smoke green, `Templates/PrivacyVaultApp/Package.swift` is dependency-free so no external dependency lockfile is required, local standalone `swift test` passes, richer example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes, hosted standalone iOS proof workflow is active | Medium | media + stable green hosted standalone iOS baseline |
| Health / Fitness | standalone root + template family | root package green, standalone manifest smoke green, `Templates/FitnessApp/Package.resolved` exists, source shell exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes, hosted standalone iOS proof workflow is active | Medium | media + stable green hosted standalone iOS baseline |
| Finance | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/FinanceApp/Package.resolved` exists, local standalone `swift test` passes, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes, hosted standalone iOS proof workflow is active | Medium | media + stable green hosted standalone iOS baseline |
| Education | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/EducationApp/Package.resolved` exists, local standalone `swift test` passes, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes, hosted standalone iOS proof workflow is active | Medium | media + stable green hosted standalone iOS baseline |
| Food Delivery | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/FoodDeliveryApp/Package.resolved` exists, local standalone `swift test` passes, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes, hosted standalone iOS proof workflow is active | Medium | media + stable green hosted standalone iOS baseline |
| Travel | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/TravelPlannerApp/Package.resolved` exists, local standalone `swift test` passes, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes, hosted standalone iOS proof workflow is active | Medium | media + stable green hosted standalone iOS baseline |
| AI | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/AIAssistantApp/Package.resolved` exists, local standalone `swift test` passes, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes, hosted standalone iOS proof workflow is active | Medium | media + stable green hosted standalone iOS baseline |
| News | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/NewsBlogApp/Package.swift` is dependency-free so no external dependency lockfile is required, local standalone `swift test` passes, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes, hosted standalone iOS proof workflow is active | Medium | media + stable green hosted standalone iOS baseline |
| Music / Podcast | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/MusicPodcastApp/Package.swift` is dependency-free so no external dependency lockfile is required, local standalone `swift test` passes, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes, hosted standalone iOS proof workflow is active | Medium | media + stable green hosted standalone iOS baseline |
| Productivity | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/ProductivityApp/Package.resolved` exists, local standalone `swift test` passes, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes, hosted standalone iOS proof workflow is active | Medium | media + stable green hosted standalone iOS baseline |

## Current Global Proof

- root `swift build -c release` passes
- root `swift test` passes
- generator `--list` passes
- generator sample app `build + test` passes
- standalone root manifest smoke passes
- deterministic `Package.resolved` coverage exists for 8 standalone roots with external packages
- canonical per-app proof pages exist for standalone roots
- canonical per-app media pages exist for 20 standalone roots, shareable gallery cards are published, preview boards are published, runtime screenshots are published, demo clips are published, and launch-to-ready scenario frames are published
- canonical runtime scenario pages exist for the same 20 standalone roots
- local generic iOS `xcodebuild` passes for `EcommerceApp`, `SocialMediaApp`, `FitnessApp`, `ProductivityApp`, `FinanceApp`, `EducationApp`, `FoodDeliveryApp`, `TravelPlannerApp`, `AIAssistantApp`, `NewsBlogApp`, `MusicPodcastApp`, `MarketplaceApp`, `MessagingApp`, `BookingReservationsApp`, `NotesKnowledgeApp`, `CreatorShortVideoApp`, `TeamCollaborationApp`, `CRMAdminApp`, `SubscriptionLifestyleApp`, and `PrivacyVaultApp`
- local simulator runtime launch proof passes for `EcommerceApp`, `SocialMediaApp`, `FitnessApp`, `ProductivityApp`, `FinanceApp`, `EducationApp`, `FoodDeliveryApp`, `TravelPlannerApp`, `AIAssistantApp`, `NewsBlogApp`, `MusicPodcastApp`, `MarketplaceApp`, `MessagingApp`, `BookingReservationsApp`, `NotesKnowledgeApp`, `CreatorShortVideoApp`, `TeamCollaborationApp`, `CRMAdminApp`, `SubscriptionLifestyleApp`, and `PrivacyVaultApp`
- local standalone `swift test` passes for `ProductivityApp`, `FinanceApp`, `EducationApp`, `FoodDeliveryApp`, `TravelPlannerApp`, `AIAssistantApp`, `NewsBlogApp`, `MusicPodcastApp`, `MarketplaceApp`, `MessagingApp`, `BookingReservationsApp`, `NotesKnowledgeApp`, `CreatorShortVideoApp`, `TeamCollaborationApp`, `CRMAdminApp`, `SubscriptionLifestyleApp`, and `PrivacyVaultApp`
- hosted standalone iOS proof workflow is active for the same `20` roots; live green status should be checked on `master`
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

1. stable green hosted standalone iOS baseline for the tracked roots
2. equal production depth across the current 20 roots
3. deeper multi-step interaction proof beyond the current launch / ready / first-screen scenario set
4. deeper per-lane product polish and trust depth

Required Wave 1 app-pack contract:

- [Wave-1-Implementation-Plan.md](./Wave-1-Implementation-Plan.md)
- [Wave-1-App-Pack-Spec.md](./Wave-1-App-Pack-Spec.md)

Tracked local standalone iOS build validator:

- [../Scripts/validate-standalone-ios-builds.sh](../Scripts/validate-standalone-ios-builds.sh)

Hosted standalone iOS workflow:

- [../.github/workflows/standalone-ios-proof.yml](../.github/workflows/standalone-ios-proof.yml)

Tracked local runtime launch validator:

- [../Scripts/validate-runtime-app-launches.sh](../Scripts/validate-runtime-app-launches.sh)

## Rule

A lane does not count as a `complete app` just because source files exist for it.

Canonical standard for counting a `complete app`:
- [Complete-App-Standard.md](./Complete-App-Standard.md)
