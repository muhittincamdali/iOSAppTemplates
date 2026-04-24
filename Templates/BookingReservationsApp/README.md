# BookingReservationsApp

Generated from `Documentation/app-surface-catalog.json`.

`BookingReservationsApp` is the standalone-root surface for the `Booking / Reservations` lane inside `iOSAppTemplates`.

## Today

- Label: `Standalone Root + richer example surface`
- Lane: `Booking / Reservations`
- Entry: `Package.swift`
- Product target: `Booking & Reservations`
- Richer example: `Examples/BookingReservationsExample`

## Best For / Not For

### Best for

- teams evaluating booking, calendar, and reservation starter flows
- readers comparing travel-adjacent booking surfaces
- maintainers reviewing appointment or reservation starter patterns

### Not for

- teams expecting production reservation backends today
- readers who assume runtime screenshots and clips are already published
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape

- availability shell
- reservation detail surface
- calendar or timeslot routing
- confirmation starter flow
- reservation domain model

## Current Proof

- No external dependency lockfile is required today
- `swift package dump-package` passes
- local `swift test` passes
- `xcodebuild -scheme BookingReservationsApp -destination 'generic/platform=iOS' build` passes
- `bash Scripts/validate-runtime-app-launches.sh BookingReservationsApp` passes locally
- root repo `swift build -c release` passes
- root repo `swift test` passes
- canonical app proof page exists
- canonical app media page exists
- runtime screenshot is published
- richer example route exists

## Missing Proof

- demo clip
- stable green hosted standalone iOS baseline on current `master`

## Start Here

```bash
open Package.swift
open ../../Examples/BookingReservationsExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

Standalone generic iOS proof:

```bash
xcodebuild -scheme BookingReservationsApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/BookingReservationsApp.md)
- [Media Surface](../../Documentation/App-Media/BookingReservationsApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
- [Richer Example](../../Examples/BookingReservationsExample/README.md)
