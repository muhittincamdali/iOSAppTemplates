# TravelPlannerApp

Generated from `Documentation/app-surface-catalog.json`.

`TravelPlannerApp` is the standalone-root surface for the `Travel` lane inside `iOSAppTemplates`.

## Today

- Label: `Standalone Root + richer example surface`
- Lane: `Travel`
- Entry: `Package.swift`
- Product target: `Travel Planner`
- Richer example: `Examples/TravelPlannerExample`

## Best For / Not For

### Best for

- teams evaluating trip and itinerary planning shells
- readers comparing travel lane packaging and richer example routing
- maintainers reviewing booking-adjacent trip surfaces

### Not for

- teams expecting full booking network integrations today
- readers who assume published runtime screenshots and clips already exist
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape

- trip overview shell
- itinerary cards
- destination highlights
- booking-adjacent planning surface
- starter travel domain model

## Current Proof

- `Package.resolved` exists as the tracked dependency lockfile
- `swift package dump-package` passes
- local `swift test` passes
- `xcodebuild -scheme TravelPlannerApp -destination 'generic/platform=iOS' build` passes
- root repo `swift build -c release` passes
- root repo `swift test` passes
- canonical app proof page exists
- canonical app media page exists
- richer example route exists

## Missing Proof

- runtime screenshot
- demo clip
- stable green hosted standalone iOS baseline on current `master`

## Start Here

```bash
open Package.swift
open Package.resolved
open ../../Examples/TravelPlannerExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

Standalone generic iOS proof:

```bash
xcodebuild -scheme TravelPlannerApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/TravelPlannerApp.md)
- [Media Surface](../../Documentation/App-Media/TravelPlannerApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
- [Richer Example](../../Examples/TravelPlannerExample/README.md)
