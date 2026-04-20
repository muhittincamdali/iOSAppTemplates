# TravelPlannerApp Proof Surface

Last updated: 2026-04-20

## Product Summary

- Lane: `Travel`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/TravelPlannerApp/Package.swift`
- Extra route: `Examples/TravelPlannerExample`
- Product target: `Travel Planner`

## Best For / Not For

### Best for

- destination, booking ve itinerary shell incelemek isteyen ekipler
- standalone root ile richer example surface'i birlikte gormek isteyenler
- Wave 1 icin gercek travel packaging kaniti isteyenler

### Not for

- bugun complete travel parity bekleyenler
- screenshot/demo proof'un zaten mevcut oldugunu varsayanlar
- hosted standalone iOS CI proof'unun verildigini dusunenler

## Product Shape Today

- trip dashboard shell
- itinerary timeline
- booking health summary
- flight and hotel quick actions
- richer travel example route

## Current Proof

- standalone root package mevcut
- template-root README mevcut
- `Templates/TravelPlannerApp/Package.resolved` lockfile mevcut
- `swift package dump-package` gecerli
- `cd Templates/TravelPlannerApp && swift test` gecerli
- `xcodebuild -scheme TravelPlannerApp -destination 'generic/platform=iOS' build` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- `Examples/TravelPlannerExample` inspection route mevcut

## Missing Proof

- canonical screenshot yok
- demo clip yok
- hosted standalone iOS CI proof yok

## Start Path

```bash
open Templates/TravelPlannerApp/Package.swift
open Templates/TravelPlannerApp/Package.resolved
open Examples/TravelPlannerExample/README.md
```

Root repo proof icin:

```bash
swift build
swift test
```

Standalone generic iOS proof icin:

```bash
cd Templates/TravelPlannerApp
xcodebuild -scheme TravelPlannerApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Template Root README](../../Templates/TravelPlannerApp/README.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Portfolio-Matrix.md](../Portfolio-Matrix.md)
