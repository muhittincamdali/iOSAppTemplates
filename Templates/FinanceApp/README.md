# FinanceApp

Generated from `Documentation/app-surface-catalog.json`.

`FinanceApp` is the standalone-root surface for the `Finance` lane inside `iOSAppTemplates`.

## Today

- Label: `Standalone Root + richer example surface`
- Lane: `Finance`
- Entry: `Package.swift`
- Product target: `Finance / Budgeting`
- Richer example: `Examples/FinanceExample`

## Best For / Not For

### Best for

- teams inspecting budgeting and account-summary starter flows
- readers who want a finance lane with root packaging and richer example coverage
- maintainers reviewing starter financial UI patterns without backend claims

### Not for

- teams expecting bank-grade integrations today
- readers who assume published runtime screenshots and clips already exist
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape

- account summary shell
- transaction overview
- budget category surface
- spending insight cards
- starter finance domain model

## Current Proof

- `Package.resolved` exists as the tracked dependency lockfile
- `swift package dump-package` passes
- local `swift test` passes
- `xcodebuild -scheme FinanceApp -destination 'generic/platform=iOS' build` passes
- root repo `swift build -c release` passes
- root repo `swift test` passes
- canonical app proof page exists
- canonical app media page exists
- richer example route exists

## Missing Proof

- demo clip
- stable green hosted standalone iOS baseline on current `master`

## Start Here

```bash
open Package.swift
open Package.resolved
open ../../Examples/FinanceExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

Standalone generic iOS proof:

```bash
xcodebuild -scheme FinanceApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/FinanceApp.md)
- [Media Surface](../../Documentation/App-Media/FinanceApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
- [Richer Example](../../Examples/FinanceExample/README.md)
