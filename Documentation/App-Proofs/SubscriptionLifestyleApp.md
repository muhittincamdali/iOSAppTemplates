# SubscriptionLifestyleApp Proof Surface

Last updated: 2026-04-20

## Product Summary

- Lane: `Subscription Lifestyle`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/SubscriptionLifestyleApp/Package.swift`
- Extra route: `Examples/SubscriptionLifestyleExample`
- Product target: `Subscription Lifestyle / Habit Tracker`

## Best For / Not For

### Best for

- subscription-first lifestyle shell, retention workflow ve streak program routing incelemek isteyen ekipler
- standalone root ile richer example surface'i birlikte gormek isteyenler
- Wave 3 premium differentiation lane'i icin gercek packaging kaniti isteyenler

### Not for

- bugun StoreKit parity veya production subscription backend proof bekleyenler
- screenshot/demo proof'un zaten mevcut oldugunu varsayanlar
- teams that assume hosted standalone iOS proof is already green for this app pack

## Product Shape Today

- subscription dashboard shell
- membership and streak program lanes
- churn watch and retention workflow
- richer lifestyle example route

## Current Proof

- standalone root package mevcut
- template-root README mevcut
- `Templates/SubscriptionLifestyleApp/Package.swift` dependency-free app shell graph'i veriyor; no external dependency lockfile is required
- `swift package dump-package` gecerli
- `cd Templates/SubscriptionLifestyleApp && swift test` gecerli
- `xcodebuild -scheme SubscriptionLifestyleApp -destination 'generic/platform=iOS' build` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- `Examples/SubscriptionLifestyleExample` inspection route mevcut

## Missing Proof

- canonical screenshot yok
- demo clip yok
- hosted standalone iOS proof workflow is active; check live GitHub status on master

## Start Path

```bash
open Templates/SubscriptionLifestyleApp/Package.swift
open Examples/SubscriptionLifestyleExample/README.md
```

Root repo proof icin:

```bash
swift build
swift test
```

Standalone generic iOS proof icin:

```bash
cd Templates/SubscriptionLifestyleApp
xcodebuild -scheme SubscriptionLifestyleApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Template Root README](../../Templates/SubscriptionLifestyleApp/README.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Portfolio-Matrix.md](../Portfolio-Matrix.md)
