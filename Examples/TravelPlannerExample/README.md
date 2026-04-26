# TravelPlannerExample

Generated from `Documentation/app-surface-catalog.json`.

`TravelPlannerExample` is the richer example surface for the `Travel` lane.

## Product Shape

- trip overview shell
- itinerary cards
- destination highlights
- booking-adjacent planning surface

## Best For / Not For

### Best for

- teams that want a second inspection route beyond `TravelPlannerApp`
- readers who want to inspect the `Travel Planner` flow in a more product-like format

### Not for

- teams expecting a separate runnable Xcode project
- readers who expect deeper interactive runtime flows than the current launch-to-ready scenario set

## Current Truth

- this example is an inspection surface, not a separate shipped app project
- the canonical standalone package-entry path lives under `Templates/`
- canonical package validation remains the root-level `swift build` and `swift test` flow

## Start Here

```bash
open TravelPlannerFlowExample.swift
open ../../Templates/TravelPlannerApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Canonical References

- [TravelPlannerApp Proof](../../Documentation/App-Proofs/TravelPlannerApp.md)
- [TravelPlannerApp Media](../../Documentation/App-Media/TravelPlannerApp.md)
- [Wave 1 Plan](../../Documentation/Wave-1-Implementation-Plan.md)
