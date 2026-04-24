# SubscriptionLifestyleApp

Generated from `Documentation/app-surface-catalog.json`.

`SubscriptionLifestyleApp` is the standalone-root surface for the `Subscription Lifestyle` lane inside `iOSAppTemplates`.

## Today

- Label: `Standalone Root + richer example surface`
- Lane: `Subscription Lifestyle`
- Entry: `Package.swift`
- Product target: `Subscription Lifestyle / Habit Tracker`
- Richer example: `Examples/SubscriptionLifestyleExample`

## Best For / Not For

### Best for

- teams evaluating premium lifestyle and habit starter flows
- readers comparing subscription-oriented packaging surfaces
- maintainers reviewing routine and premium UI patterns

### Not for

- teams expecting production billing and entitlement flows today
- readers who assume demo clips and stable hosted standalone iOS proof already exist
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape

- habit dashboard shell
- streak and progress surface
- premium plan starter cards
- routine detail routing
- lifestyle starter domain model

## Current Proof

- No external dependency lockfile is required today
- `swift package dump-package` passes
- local `swift test` passes
- `xcodebuild -scheme SubscriptionLifestyleApp -destination 'generic/platform=iOS' build` passes
- `bash Scripts/validate-runtime-app-launches.sh SubscriptionLifestyleApp` passes locally
- root repo `swift build -c release` passes
- root repo `swift test` passes
- canonical app proof page exists
- canonical app media page exists
- runtime screenshot is published
- richer example route exists

## Missing Proof

- demo clip
- stable green hosted standalone iOS baseline on current `master`

## Start Here

```bash
open Package.swift
open ../../Examples/SubscriptionLifestyleExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

Standalone generic iOS proof:

```bash
xcodebuild -scheme SubscriptionLifestyleApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/SubscriptionLifestyleApp.md)
- [Media Surface](../../Documentation/App-Media/SubscriptionLifestyleApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
- [Richer Example](../../Examples/SubscriptionLifestyleExample/README.md)
