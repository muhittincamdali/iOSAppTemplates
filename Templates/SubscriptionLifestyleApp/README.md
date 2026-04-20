# SubscriptionLifestyleApp

Last updated: 2026-04-20

`SubscriptionLifestyleApp`, `iOSAppTemplates` icindeki Subscription Lifestyle lane standalone root surface'idir.

## Today

- Label: `Standalone Root`
- Lane: `Subscription Lifestyle`
- Entry: `Package.swift`
- Extra route: `../../Examples/SubscriptionLifestyleExample`
- Product target: `Subscription Lifestyle / Habit Tracker`

## Best For / Not For

### Best for

- subscription-first lifestyle shell'i incelemek isteyen ekipler
- churn watch, paywall ve retention workflow icin package-entry seviyesinde app surface gormek isteyenler
- Wave 3 premium differentiation lane'i icin gercek root/package kaniti isteyenler

### Not for

- bugun tam billing backend parity veya StoreKit production proof bekleyenler
- screenshot veya demo proof arayanlar
- hosted standalone iOS CI proof'un verildigini varsayanlar

## Product Shape

- subscription dashboard shell
- membership and streak program lanes
- churn watch workflow
- retention quick actions

## Current Proof

- No external dependency lockfile is required today
- `swift package dump-package` gecerli
- `cd Templates/SubscriptionLifestyleApp && swift test` gecerli
- `xcodebuild -scheme SubscriptionLifestyleApp -destination 'generic/platform=iOS' build` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- canonical app proof page mevcut
- richer example route mevcut

## Missing Proof

- screenshot
- demo clip
- hosted standalone iOS CI proof

## Start Here

```bash
open Package.swift
xcodebuild -scheme SubscriptionLifestyleApp -destination 'generic/platform=iOS' build
open ../../Examples/SubscriptionLifestyleExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/SubscriptionLifestyleApp.md)
- [Media Surface](../../Documentation/App-Media/SubscriptionLifestyleApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
