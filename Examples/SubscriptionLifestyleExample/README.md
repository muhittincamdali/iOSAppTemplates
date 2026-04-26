# SubscriptionLifestyleExample

Generated from `Documentation/app-surface-catalog.json`.

`SubscriptionLifestyleExample` is the richer example surface for the `Subscription Lifestyle` lane.

## Product Shape

- habit dashboard shell
- streak and progress surface
- premium plan starter cards
- routine detail routing

## Best For / Not For

### Best for

- teams that want a second inspection route beyond `SubscriptionLifestyleApp`
- readers who want to inspect the `Subscription Lifestyle / Habit Tracker` flow in a more product-like format

### Not for

- teams expecting a separate runnable Xcode project
- readers who expect deeper interactive runtime flows than the current launch-to-ready scenario set

## Current Truth

- this example is an inspection surface, not a separate shipped app project
- the canonical standalone package-entry path lives under `Templates/`
- canonical package validation remains the root-level `swift build` and `swift test` flow

## Start Here

```bash
open ../../Templates/SubscriptionLifestyleApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Canonical References

- [SubscriptionLifestyleApp Proof](../../Documentation/App-Proofs/SubscriptionLifestyleApp.md)
- [SubscriptionLifestyleApp Media](../../Documentation/App-Media/SubscriptionLifestyleApp.md)
- [Wave 1 Plan](../../Documentation/Wave-1-Implementation-Plan.md)
