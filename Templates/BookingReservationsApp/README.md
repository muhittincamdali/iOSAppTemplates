# BookingReservationsApp

Last updated: 2026-04-20

`BookingReservationsApp`, `iOSAppTemplates` icindeki Booking / Reservations lane standalone root surface'idir.

## Today

- Label: `Standalone Root`
- Lane: `Booking / Reservations`
- Entry: `Package.swift`
- Extra route: `../../Examples/BookingReservationsExample`
- Product target: `Booking & Reservations`

## Best For / Not For

### Best for

- reservation dashboard, property routing ve guest operations flow incelemek isteyen ekipler
- booking lane icin package-entry seviyesinde app surface gormek isteyenler
- Wave 2 expansion icin gercek root/package kaniti isteyenler

### Not for

- bugun tam hospitality suite parity bekleyenler
- screenshot veya demo proof arayanlar
- hosted standalone iOS CI proof'un verildigini varsayanlar

## Product Shape

- reservation operations dashboard
- property and stay routing
- guest support and payment shell
- occupancy quick actions

## Current Proof

- No external dependency lockfile is required today
- `swift package dump-package` gecerli
- `cd Templates/BookingReservationsApp && swift test` gecerli
- `xcodebuild -scheme BookingReservationsApp -destination 'generic/platform=iOS' build` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- canonical app proof page mevcut
- richer example route mevcut

## Missing Proof

- screenshot
- demo clip
- hosted standalone iOS CI proof

## Start Here

```bash
open Package.swift
xcodebuild -scheme BookingReservationsApp -destination 'generic/platform=iOS' build
open ../../Examples/BookingReservationsExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/BookingReservationsApp.md)
- [Media Surface](../../Documentation/App-Media/BookingReservationsApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
