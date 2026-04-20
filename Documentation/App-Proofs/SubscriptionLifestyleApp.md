# SubscriptionLifestyleApp Proof Surface

Last updated: 2026-04-21

## Product Summary

- Lane: `Subscription Lifestyle`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/SubscriptionLifestyleApp/Package.swift`
- Extra route: `Examples/SubscriptionLifestyleExample`
- Product target: `Subscription Lifestyle / Habit Tracker`

## Best For / Not For

### Best for

- teams evaluating premium lifestyle and habit starter flows
- readers comparing subscription-oriented packaging surfaces
- maintainers reviewing routine and premium UI patterns

### Not for

- teams expecting production billing and entitlement flows today
- readers who assume runtime screenshots and demo clips are already published
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape Today

- habit dashboard shell
- streak and progress surface
- premium plan starter cards
- routine detail routing
- lifestyle starter domain model

## Current Proof

- standalone root package exists
- template-root README exists
- `Templates/SubscriptionLifestyleApp/Package.swift` exists
- local generic iOS build proof is tracked via `xcodebuild -scheme SubscriptionLifestyleApp -destination 'generic/platform=iOS' build`
- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`
- root repo `swift build -c release` passes
- root repo `swift test` passes
- `Examples/SubscriptionLifestyleExample` inspection route exists

## Missing Proof

- runtime screenshot not yet published
- demo clip not yet published
- stable green hosted standalone iOS baseline should be checked on current `master`

## Start Path

```bash
open Templates/SubscriptionLifestyleApp/Package.swift
open Examples/SubscriptionLifestyleExample/README.md
xcodebuild -scheme SubscriptionLifestyleApp -destination 'generic/platform=iOS' build
```

Then validate the root package:

```bash
swift build -c release
swift test
```

## Canonical References

- [Template Root README](../../Templates/SubscriptionLifestyleApp/README.md)
- [Richer Example](../../Examples/SubscriptionLifestyleExample/README.md)
- [App Media Surface](../App-Media/SubscriptionLifestyleApp.md)
- [Template Showcase](../Template-Showcase.md)
- [Proof Matrix](../Proof-Matrix.md)
- [Portfolio Matrix](../Portfolio-Matrix.md)
