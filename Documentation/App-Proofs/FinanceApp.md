# FinanceApp Proof Surface

Generated from `Documentation/app-surface-catalog.json`.

## Product Summary

- Lane: `Finance`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/FinanceApp/Package.swift`
- Extra route: `Examples/FinanceExample`
- Product target: `Finance / Budgeting`

## Best For / Not For

### Best for

- teams inspecting budgeting and account-summary starter flows
- readers who want a finance lane with root packaging and richer example coverage
- maintainers reviewing starter financial UI patterns without backend claims

### Not for

- teams expecting bank-grade integrations today
- readers who assume demo clips and stable hosted standalone iOS proof already exist
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape Today

- account summary shell
- transaction overview
- budget category surface
- spending insight cards
- starter finance domain model

## Current Proof

- standalone root package exists
- template-root README exists
- `Templates/FinanceApp/Package.swift` exists
- `Templates/FinanceApp/Package.resolved` exists as the tracked dependency lockfile
- local generic iOS build proof is tracked via `xcodebuild -scheme FinanceApp -destination 'generic/platform=iOS' build`
- local simulator runtime launch proof is tracked via `bash Scripts/validate-runtime-app-launches.sh FinanceApp`
- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`
- root repo `swift build -c release` passes
- root repo `swift test` passes
- runtime screenshot is published: [../Assets/AppScreenshots/FinanceApp.png](../Assets/AppScreenshots/FinanceApp.png)
- demo clip is published: [../Assets/AppDemoClips/FinanceApp.mp4](../Assets/AppDemoClips/FinanceApp.mp4)
- `Examples/FinanceExample` inspection route exists

## Missing Proof

- stable green hosted standalone iOS baseline should be checked on current `master`

## Start Path

```bash
open Templates/FinanceApp/Package.swift
open Templates/FinanceApp/Package.resolved
open Examples/FinanceExample/README.md
xcodebuild -scheme FinanceApp -destination 'generic/platform=iOS' build
```

Then validate the root package:

```bash
swift build -c release
swift test
```

## Canonical References

- [Template Root README](../../Templates/FinanceApp/README.md)
- [Richer Example](../../Examples/FinanceExample/README.md)
- [App Media Surface](../App-Media/FinanceApp.md)
- [Template Showcase](../Template-Showcase.md)
- [Proof Matrix](../Proof-Matrix.md)
- [Portfolio Matrix](../Portfolio-Matrix.md)
