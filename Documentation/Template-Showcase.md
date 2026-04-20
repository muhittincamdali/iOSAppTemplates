# Template Showcase

Last updated: 2026-04-19

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
- Product shape: store, cart, checkout, auth shell
- Proof today: package root exists, manifest smoke passes, `Templates/EcommerceApp/Package.resolved` exists, source shell exists
- Proof surface: [App-Proofs/EcommerceApp.md](./App-Proofs/EcommerceApp.md)
- Gap: tracked generic iOS build proof, screenshot, demo

### Social: SocialMediaApp

- Type: `Standalone Root + richer source shell`
- Entry: `Templates/SocialMediaApp/Package.swift`
- Extra route: `Examples/SocialMediaExample`
- Product shape: auth, feed/community shell, richer UI fragments
- Proof today: package root exists, manifest smoke passes, `Templates/SocialMediaApp/Package.resolved` exists, richer example surface exists, local generic iOS `xcodebuild` passes
- Proof surface: [App-Proofs/SocialMediaApp.md](./App-Proofs/SocialMediaApp.md)
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

## Template Family Coverage

These lanes exist today as lane-level source surfaces, but they do not yet carry standalone complete-app proof:

| Lane | Current Type | Best Route |
| --- | --- | --- |
| News | Template Family | `Sources/NewsTemplates/NewsBlogTemplate.swift` |
| Finance | Template Family | `Sources/FinanceTemplates/FinanceAppTemplate.swift` |
| Education | Template Family | `Sources/EducationTemplates/EducationAppTemplate.swift` |
| Food Delivery | Template Family | `Sources/FoodTemplates/FoodDeliveryTemplate.swift` |
| AI | Template Family | `Sources/AITemplates/SmartPhotoTemplate.swift` |
| Music / Podcast | Template Family | `Sources/MusicTemplates/MusicPodcastTemplate.swift` |
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
3. `swift Scripts/TemplateGenerator.swift --list`
4. [TemplateGuide.md](./TemplateGuide.md)

### If you want to inspect proof depth

1. [Proof-Matrix.md](./Proof-Matrix.md)
2. [App-Proofs/README.md](./App-Proofs/README.md)
3. [Complete-App-Standard.md](./Complete-App-Standard.md)

## Next Upgrade Path

This page becomes a real world-class gallery only as these two layers arrive:

1. screenshot / demo proof
2. equal standalone iOS proof + hosted CI proof
