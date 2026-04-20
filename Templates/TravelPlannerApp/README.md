# TravelPlannerApp

Last updated: 2026-04-20

`TravelPlannerApp`, `iOSAppTemplates` icindeki Travel lane standalone root surface'idir.

## Today

- Label: `Standalone Root + richer example surface`
- Lane: `Travel`
- Entry: `Package.swift`
- Product target: `Travel Planner`

## Best For / Not For

### Best for

- destination, itinerary ve booking shell incelemek isteyen ekipler
- travel lane icin package-entry seviyesinde app surface gormek isteyenler
- Wave 1 icin gercek travel packaging kaniti isteyenler

### Not for

- bugun tam release-grade travel suite parity bekleyenler
- screenshot veya demo proof arayanlar
- explicit standalone iOS CI proof'un verildigini varsayanlar

## Product Shape

- trip overview dashboard
- itinerary timeline
- booking health summary
- flight and hotel management quick actions

## Current Proof

- `Package.resolved` lockfile mevcut
- `swift package dump-package` gecerli
- local `swift test` gecerli
- `xcodebuild -scheme TravelPlannerApp -destination 'generic/platform=iOS' build` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- canonical app proof page mevcut

## Missing Proof

- screenshot
- demo clip
- hosted standalone iOS CI proof

## Start Here

```bash
open Package.swift
open Package.resolved
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
