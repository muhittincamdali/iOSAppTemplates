# TravelPlannerApp

Generated from `Documentation/app-surface-catalog.json`.

`TravelPlannerApp` is the standalone-root surface for the `Travel` lane inside `iOSAppTemplates`.

## Today

- Label: `Standalone Root + richer example + rebuilt runtime flow`
- Lane: `Travel`
- Entry: `Package.swift`
- Product target: `Travel Planner`
- Richer example: `Examples/TravelPlannerExample`

## Best For / Not For

### Best for

- teams evaluating trip and itinerary planning flows
- readers comparing travel lane packaging and richer example routing
- maintainers reviewing booking-adjacent trip surfaces

### Not for

- teams expecting full booking network integrations today
- readers who expect automated multi-step interaction proof beyond the current first-screen runtime proof set
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape

- trip overview flow
- itinerary cards
- destination highlights
- booking-adjacent planning surface
- starter travel domain model

## Current Proof

- `Package.resolved` exists as the tracked dependency lockfile
- `swift package dump-package` passes
- local `swift test` passes
- `xcodebuild -scheme TravelPlannerApp -destination 'generic/platform=iOS' build` passes
- `bash Scripts/validate-runtime-app-launches.sh TravelPlannerApp` passes locally
- root repo `swift build -c release` passes
- root repo `swift test` passes
- canonical app proof page exists
- canonical app media page exists
- runtime screenshot is published
- demo clip is published
- richer example route exists

## Missing Proof

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
