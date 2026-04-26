# TravelPlannerApp Proof Surface

Generated from `Documentation/app-surface-catalog.json`.

## Product Summary

- Lane: `Travel`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/TravelPlannerApp/Package.swift`
- Extra route: `Examples/TravelPlannerExample`
- Product target: `Travel Planner`

## Best For / Not For

### Best for

- teams evaluating trip and itinerary planning shells
- readers comparing travel lane packaging and richer example routing
- maintainers reviewing booking-adjacent trip surfaces

### Not for

- teams expecting full booking network integrations today
- readers who expect deeper interactive runtime flows than the current launch-to-ready scenario proof
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape Today

- trip overview shell
- itinerary cards
- destination highlights
- booking-adjacent planning surface
- starter travel domain model

## Current Proof

- standalone root package exists
- template-root README exists
- `Templates/TravelPlannerApp/Package.swift` exists
- `Templates/TravelPlannerApp/Package.resolved` exists as the tracked dependency lockfile
- local generic iOS build proof is tracked via `xcodebuild -scheme TravelPlannerApp -destination 'generic/platform=iOS' build`
- local simulator runtime launch proof is tracked via `bash Scripts/validate-runtime-app-launches.sh TravelPlannerApp`
- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`
- root repo `swift build -c release` passes
- root repo `swift test` passes
- runtime screenshot is published: [../Assets/AppScreenshots/TravelPlannerApp.png](../Assets/AppScreenshots/TravelPlannerApp.png)
- demo clip is published: [../Assets/AppDemoClips/TravelPlannerApp.mp4](../Assets/AppDemoClips/TravelPlannerApp.mp4)
- launch-to-ready scenario frames are published: [launch](../Assets/AppScenarioShots/TravelPlannerApp-launch.png) / [ready](../Assets/AppScenarioShots/TravelPlannerApp-ready.png)
- `Examples/TravelPlannerExample` inspection route exists

## Missing Proof

- stable green hosted standalone iOS baseline should be checked on current `master`

## Start Path

```bash
open Templates/TravelPlannerApp/Package.swift
open Templates/TravelPlannerApp/Package.resolved
open Examples/TravelPlannerExample/README.md
xcodebuild -scheme TravelPlannerApp -destination 'generic/platform=iOS' build
```

Then validate the root package:

```bash
swift build -c release
swift test
```

## Canonical References

- [Template Root README](../../Templates/TravelPlannerApp/README.md)
- [Richer Example](../../Examples/TravelPlannerExample/README.md)
- [App Media Surface](../App-Media/TravelPlannerApp.md)
- [Template Showcase](../Template-Showcase.md)
- [Proof Matrix](../Proof-Matrix.md)
- [Portfolio Matrix](../Portfolio-Matrix.md)
