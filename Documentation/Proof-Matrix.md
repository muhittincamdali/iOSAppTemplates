# Proof Matrix

Last updated: 2026-04-20

This page shows the gap between the current public claim and the current proof, lane by lane.

Status meanings:

- `Strong`: route + build path + packaging + app-specific proof var
- `Medium`: route + packaging exist, but app-specific build or media proof is still missing
- `Low`: source-level coverage exists, but product proof is still weak

| Lane | Current Packaging | Current Proof | Strength | Next Missing Piece |
| --- | --- | --- | --- | --- |
| Commerce | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/EcommerceApp/Package.resolved` exists, source shell exists, richer example surface exists, per-app proof surface exists, template-root README exists | Medium | tracked generic iOS build proof + media |
| Social | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/SocialMediaApp/Package.resolved` exists, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| Health / Fitness | standalone root + template family | root package green, standalone manifest smoke green, `Templates/FitnessApp/Package.resolved` exists, source shell exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| Finance | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/FinanceApp/Package.resolved` exists, local standalone `swift test` passes, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| Education | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/EducationApp/Package.resolved` exists, local standalone `swift test` passes, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| Food Delivery | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/FoodDeliveryApp/Package.resolved` exists, local standalone `swift test` passes, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| Travel | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/TravelPlannerApp/Package.resolved` exists, local standalone `swift test` passes, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| AI | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/AIAssistantApp/Package.resolved` exists, local standalone `swift test` passes, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| Productivity | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/ProductivityApp/Package.resolved` exists, local standalone `swift test` passes, richer source/example surface exists, per-app proof surface exists, template-root README exists, local generic iOS `xcodebuild` passes | Medium | media + hosted standalone iOS CI proof |
| News | template family + generator lane | root package green, generator lane is listed | Low | standalone root or per-app proof |
| Music / Podcast | template family + generator lane | root package green, generator lane is listed | Low | standalone root or per-app proof |

## Current Global Proof

- root `swift build -c release` passes
- root `swift test` passes
- generator `--list` passes
- generator sample app `build + test` passes
- standalone root manifest smoke passes
- deterministic `Package.resolved` coverage exists for 9 standalone roots
- canonical per-app proof pages exist for standalone roots
- canonical per-app media pages exist for 9 standalone roots, but media status is still `not-published`
- local generic iOS `xcodebuild` passes for `SocialMediaApp`, `FitnessApp`, `ProductivityApp`, `FinanceApp`, `EducationApp`, `FoodDeliveryApp`, `TravelPlannerApp`, and `AIAssistantApp`
- local standalone `swift test` passes for `ProductivityApp`, `FinanceApp`, `EducationApp`, `FoodDeliveryApp`, `TravelPlannerApp`, and `AIAssistantApp`
- tracked local generic iOS proof is not yet present for `EcommerceApp`
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

## What Is Still Missing

Main missing layers before a `20 complete apps` claim:

1. lane-specific per-app README
2. real screenshot gallery
3. equal local generic iOS build proof for every standalone root
4. hosted standalone iOS CI proof for the tracked roots
5. standalone packaging for lanes beyond the current 9 roots

Required Wave 1 app-pack contract:

- [Wave-1-Implementation-Plan.md](./Wave-1-Implementation-Plan.md)
- [Wave-1-App-Pack-Spec.md](./Wave-1-App-Pack-Spec.md)

Tracked local standalone iOS build validator:

- [../Scripts/validate-standalone-ios-builds.sh](../Scripts/validate-standalone-ios-builds.sh)

## Rule

A lane does not count as a `complete app` just because source files exist for it.

Canonical standard for counting a `complete app`:
- [Complete-App-Standard.md](./Complete-App-Standard.md)
