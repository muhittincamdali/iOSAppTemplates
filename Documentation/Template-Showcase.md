# Template Showcase

Last updated: 2026-04-20

This page is the tracked gallery surface for `iOSAppTemplates`.

Rules for this page:

- what passes manifest smoke today counts as a `standalone package root`
- what exists only at source level counts as a `template family`
- anything missing proof does not count as a `complete app`

## Runnable Now

Canonical app-proof router:

- [App-Proofs/README.md](./App-Proofs/README.md)

### Commerce: EcommerceApp

- Type: `Standalone Root`
- Entry: `Templates/EcommerceApp/Package.swift`
- Extra route: `Examples/EcommerceExample`
- Product shape: store, cart, checkout, auth shell
- Proof today: package root exists, manifest smoke passes, dependency-free package graph needs no external lockfile, source shell exists, richer example surface exists, local generic iOS `xcodebuild` passes
- Proof surface: [App-Proofs/EcommerceApp.md](./App-Proofs/EcommerceApp.md)
- Gap: screenshot, demo, hosted standalone iOS CI proof

### Social: SocialMediaApp

- Type: `Standalone Root + richer source shell`
- Entry: `Templates/SocialMediaApp/Package.swift`
- Extra route: `Examples/SocialMediaExample`
- Product shape: auth, feed/community shell, richer UI fragments
- Proof today: package root exists, manifest smoke passes, `Templates/SocialMediaApp/Package.resolved` exists, richer example surface exists, local generic iOS `xcodebuild` passes
- Proof surface: [App-Proofs/SocialMediaApp.md](./App-Proofs/SocialMediaApp.md)
- Gap: screenshot, demo, hosted standalone iOS CI proof

### Marketplace: MarketplaceApp

- Type: `Standalone Root + richer source shell`
- Entry: `Templates/MarketplaceApp/Package.swift`
- Extra route: `Examples/MarketplaceExample`
- Product shape: buyer/seller dashboard, merchandising lanes, payout and trust workflow
- Proof today: package root exists, manifest smoke passes, dependency-free package graph needs no external lockfile, local standalone `swift test` passes, richer example surface exists, local generic iOS `xcodebuild` passes
- Proof surface: [App-Proofs/MarketplaceApp.md](./App-Proofs/MarketplaceApp.md)
- Gap: screenshot, demo, hosted standalone iOS CI proof

### Messaging / Community: MessagingApp

- Type: `Standalone Root + richer source shell`
- Entry: `Templates/MessagingApp/Package.swift`
- Extra route: `Examples/MessagingExample`
- Product shape: inbox dashboard, room routing, moderation and community workflow
- Proof today: package root exists, manifest smoke passes, dependency-free package graph needs no external lockfile, local standalone `swift test` passes, richer example surface exists, local generic iOS `xcodebuild` passes
- Proof surface: [App-Proofs/MessagingApp.md](./App-Proofs/MessagingApp.md)
- Gap: screenshot, demo, hosted standalone iOS CI proof

### Booking / Reservations: BookingReservationsApp

- Type: `Standalone Root + richer source shell`
- Entry: `Templates/BookingReservationsApp/Package.swift`
- Extra route: `Examples/BookingReservationsExample`
- Product shape: reservation dashboard, property routing, support and occupancy workflow
- Proof today: package root exists, manifest smoke passes, dependency-free package graph needs no external lockfile, local standalone `swift test` passes, richer example surface exists, local generic iOS `xcodebuild` passes
- Proof surface: [App-Proofs/BookingReservationsApp.md](./App-Proofs/BookingReservationsApp.md)
- Gap: screenshot, demo, hosted standalone iOS CI proof

### Notes / Knowledge: NotesKnowledgeApp

- Type: `Standalone Root + richer source shell`
- Entry: `Templates/NotesKnowledgeApp/Package.swift`
- Extra route: `Examples/NotesKnowledgeExample`
- Product shape: note dashboard, collection routing, knowledge sync and capture workflow
- Proof today: package root exists, manifest smoke passes, dependency-free package graph needs no external lockfile, local standalone `swift test` passes, richer example surface exists, local generic iOS `xcodebuild` passes
- Proof surface: [App-Proofs/NotesKnowledgeApp.md](./App-Proofs/NotesKnowledgeApp.md)
- Gap: screenshot, demo, hosted standalone iOS CI proof

### Creator / Short Video: CreatorShortVideoApp

- Type: `Standalone Root + richer source shell`
- Entry: `Templates/CreatorShortVideoApp/Package.swift`
- Extra route: `Examples/CreatorShortVideoExample`
- Product shape: creator studio, clip routing, moderation and publishing workflow
- Proof today: package root exists, manifest smoke passes, dependency-free package graph needs no external lockfile, local standalone `swift test` passes, richer example surface exists, local generic iOS `xcodebuild` passes
- Proof surface: [App-Proofs/CreatorShortVideoApp.md](./App-Proofs/CreatorShortVideoApp.md)
- Gap: screenshot, demo, hosted standalone iOS CI proof

### Team Collaboration: TeamCollaborationApp

- Type: `Standalone Root + richer source shell`
- Entry: `Templates/TeamCollaborationApp/Package.swift`
- Extra route: `Examples/TeamCollaborationExample`
- Product shape: workspace dashboard, project routing, async handoff and decision workflow
- Proof today: package root exists, manifest smoke passes, dependency-free package graph needs no external lockfile, local standalone `swift test` passes, richer example surface exists, local generic iOS `xcodebuild` passes
- Proof surface: [App-Proofs/TeamCollaborationApp.md](./App-Proofs/TeamCollaborationApp.md)
- Gap: screenshot, demo, hosted standalone iOS CI proof

### CRM / Admin: CRMAdminApp

- Type: `Standalone Root + richer source shell`
- Entry: `Templates/CRMAdminApp/Package.swift`
- Extra route: `Examples/CRMAdminExample`
- Product shape: CRM dashboard, renewal board, SLA routing and admin workflow
- Proof today: package root exists, manifest smoke passes, dependency-free package graph needs no external lockfile, local standalone `swift test` passes, richer example surface exists, local generic iOS `xcodebuild` passes
- Proof surface: [App-Proofs/CRMAdminApp.md](./App-Proofs/CRMAdminApp.md)
- Gap: screenshot, demo, hosted standalone iOS CI proof

### Subscription Lifestyle: SubscriptionLifestyleApp

- Type: `Standalone Root + richer source shell`
- Entry: `Templates/SubscriptionLifestyleApp/Package.swift`
- Extra route: `Examples/SubscriptionLifestyleExample`
- Product shape: subscription dashboard, retention programs, paywall workflow and member operations
- Proof today: package root exists, manifest smoke passes, dependency-free package graph needs no external lockfile, local standalone `swift test` passes, richer example surface exists, local generic iOS `xcodebuild` passes
- Proof surface: [App-Proofs/SubscriptionLifestyleApp.md](./App-Proofs/SubscriptionLifestyleApp.md)
- Gap: screenshot, demo, hosted standalone iOS CI proof

### Privacy / Secure Vault: PrivacyVaultApp

- Type: `Standalone Root + richer source shell`
- Entry: `Templates/PrivacyVaultApp/Package.swift`
- Extra route: `Examples/PrivacyVaultExample`
- Product shape: secure vault dashboard, collection routing, access review and recovery workflow
- Proof today: package root exists, manifest smoke passes, dependency-free package graph needs no external lockfile, local standalone `swift test` passes, richer example surface exists, local generic iOS `xcodebuild` passes
- Proof surface: [App-Proofs/PrivacyVaultApp.md](./App-Proofs/PrivacyVaultApp.md)
- Gap: screenshot, demo, hosted standalone iOS CI proof

### Health / Fitness: FitnessApp

- Type: `Standalone Root`
- Entry: `Templates/FitnessApp/Package.swift`
- Product shape: auth, workout/progress shell, HealthKit-adjacent flow
- Proof today: package root exists, manifest smoke passes, `Templates/FitnessApp/Package.resolved` exists, source shell exists, local generic iOS `xcodebuild` passes
- Proof surface: [App-Proofs/FitnessApp.md](./App-Proofs/FitnessApp.md)
- Gap: screenshot, demo, hosted standalone iOS CI proof

### Productivity: ProductivityApp

- Type: `Standalone Root + richer source shell`
- Entry: `Templates/ProductivityApp/Package.swift`
- Extra route: `Examples/ProductivityExample`
- Product shape: task dashboard, project summary, focus workflow
- Proof today: package root exists, manifest smoke passes, `Templates/ProductivityApp/Package.resolved` exists, richer example surface exists, local generic iOS `xcodebuild` passes
- Proof surface: [App-Proofs/ProductivityApp.md](./App-Proofs/ProductivityApp.md)
- Gap: screenshot, demo, hosted standalone iOS CI proof

### Finance: FinanceApp

- Type: `Standalone Root + richer source shell`
- Entry: `Templates/FinanceApp/Package.swift`
- Extra route: `Examples/FinanceExample`
- Product shape: finance dashboard, accounts, budget review, cash-flow workflow
- Proof today: package root exists, manifest smoke passes, `Templates/FinanceApp/Package.resolved` exists, richer example surface exists, local generic iOS `xcodebuild` passes
- Proof surface: [App-Proofs/FinanceApp.md](./App-Proofs/FinanceApp.md)
- Gap: screenshot, demo, hosted standalone iOS CI proof

### Education: EducationApp

- Type: `Standalone Root + richer source shell`
- Entry: `Templates/EducationApp/Package.swift`
- Extra route: `Examples/EducationExample`
- Product shape: learning dashboard, course summary, quiz and progress workflow
- Proof today: package root exists, manifest smoke passes, `Templates/EducationApp/Package.resolved` exists, local standalone `swift test` passes, richer example surface exists, local generic iOS `xcodebuild` passes
- Proof surface: [App-Proofs/EducationApp.md](./App-Proofs/EducationApp.md)
- Gap: screenshot, demo, hosted standalone iOS CI proof

### Food Delivery: FoodDeliveryApp

- Type: `Standalone Root + richer source shell`
- Entry: `Templates/FoodDeliveryApp/Package.swift`
- Extra route: `Examples/FoodDeliveryExample`
- Product shape: restaurant discovery, cart, order tracking and delivery workflow
- Proof today: package root exists, manifest smoke passes, `Templates/FoodDeliveryApp/Package.resolved` exists, local standalone `swift test` passes, richer example surface exists, local generic iOS `xcodebuild` passes
- Proof surface: [App-Proofs/FoodDeliveryApp.md](./App-Proofs/FoodDeliveryApp.md)
- Gap: screenshot, demo, hosted standalone iOS CI proof

### Travel: TravelPlannerApp

- Type: `Standalone Root + richer source shell`
- Entry: `Templates/TravelPlannerApp/Package.swift`
- Extra route: `Examples/TravelPlannerExample`
- Product shape: trip overview, itinerary timeline, booking health and travel workflow
- Proof today: package root exists, manifest smoke passes, `Templates/TravelPlannerApp/Package.resolved` exists, local standalone `swift test` passes, richer example surface exists, local generic iOS `xcodebuild` passes
- Proof surface: [App-Proofs/TravelPlannerApp.md](./App-Proofs/TravelPlannerApp.md)
- Gap: screenshot, demo, hosted standalone iOS CI proof

### AI: AIAssistantApp

- Type: `Standalone Root + richer source shell`
- Entry: `Templates/AIAssistantApp/Package.swift`
- Extra route: `Examples/AIAssistantExample`
- Product shape: assistant workspace, suggestion queue, trust surface and action workflow
- Proof today: package root exists, manifest smoke passes, `Templates/AIAssistantApp/Package.resolved` exists, local standalone `swift test` passes, richer example surface exists, local generic iOS `xcodebuild` passes
- Proof surface: [App-Proofs/AIAssistantApp.md](./App-Proofs/AIAssistantApp.md)
- Gap: screenshot, demo, hosted standalone iOS CI proof

### News: NewsBlogApp

- Type: `Standalone Root + richer source shell`
- Entry: `Templates/NewsBlogApp/Package.swift`
- Extra route: `Examples/NewsBlogExample`
- Product shape: editorial briefing, section routing, reader mode and newsletter workflow
- Proof today: package root exists, manifest smoke passes, dependency-free package graph needs no external lockfile, local standalone `swift test` passes, richer example surface exists, local generic iOS `xcodebuild` passes
- Proof surface: [App-Proofs/NewsBlogApp.md](./App-Proofs/NewsBlogApp.md)
- Gap: screenshot, demo, hosted standalone iOS CI proof

### Music / Podcast: MusicPodcastApp

- Type: `Standalone Root + richer source shell`
- Entry: `Templates/MusicPodcastApp/Package.swift`
- Extra route: `Examples/MusicPodcastExample`
- Product shape: playback center, playlist routing, podcast queue and offline workflow
- Proof today: package root exists, manifest smoke passes, dependency-free package graph needs no external lockfile, local standalone `swift test` passes, richer example surface exists, local generic iOS `xcodebuild` passes
- Proof surface: [App-Proofs/MusicPodcastApp.md](./App-Proofs/MusicPodcastApp.md)
- Gap: screenshot, demo, hosted standalone iOS CI proof

## Template Family Coverage

These lanes exist today as lane-level source surfaces, but they do not yet carry standalone complete-app proof:

| Lane | Current Type | Best Route |
| --- | --- | --- |
| Finance | Template Family | `Sources/FinanceTemplates/FinanceAppTemplate.swift` |
| Education | Template Family | `Sources/EducationTemplates/EducationAppTemplate.swift` |
| Food Delivery | Template Family | `Sources/FoodTemplates/FoodDeliveryTemplate.swift` |
| AI | Template Family | `Sources/AITemplates/SmartPhotoTemplate.swift` |
| Productivity | Template Family | `Sources/ProductivityTemplates/ProductivityAppTemplate.swift` |

## Generator Coverage

The generator currently produces starter shells for `10` lanes:

```bash
swift Scripts/TemplateGenerator.swift --list
swift Scripts/TemplateGenerator.swift --interactive
```

This coverage proves:

- category breadth
- starter-shell coverage

It is not, by itself, complete-app proof.

## If You Need A Decision Fast

### If you want to inspect UI shells

1. `Templates/SocialMediaApp`
2. `Templates/EcommerceApp`
3. `Templates/FitnessApp`

### If you want to inspect category breadth

1. [Portfolio-Matrix.md](./Portfolio-Matrix.md)
2. [Wave-1-Implementation-Plan.md](./Wave-1-Implementation-Plan.md)
3. [App-Proofs/MarketplaceApp.md](./App-Proofs/MarketplaceApp.md)
4. [App-Proofs/MessagingApp.md](./App-Proofs/MessagingApp.md)
5. `swift Scripts/TemplateGenerator.swift --list`
6. [TemplateGuide.md](./TemplateGuide.md)

### If you want to inspect proof depth

1. [Proof-Matrix.md](./Proof-Matrix.md)
2. [App-Proofs/README.md](./App-Proofs/README.md)
3. [Complete-App-Standard.md](./Complete-App-Standard.md)

## Next Upgrade Path

This page becomes a real world-class gallery only as these two layers arrive:

1. screenshot / demo proof
2. equal standalone iOS proof + hosted CI proof
