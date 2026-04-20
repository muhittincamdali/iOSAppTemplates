# BookingReservationsApp Proof Surface

Last updated: 2026-04-21

## Product Summary

- Lane: `Booking / Reservations`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/BookingReservationsApp/Package.swift`
- Extra route: `Examples/BookingReservationsExample`
- Product target: `Booking & Reservations`

## Best For / Not For

### Best for

- teams evaluating booking, calendar, and reservation starter flows
- readers comparing travel-adjacent booking surfaces
- maintainers reviewing appointment or reservation starter patterns

### Not for

- teams expecting production reservation backends today
- readers who assume runtime screenshots and clips are already published
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape Today

- availability shell
- reservation detail surface
- calendar or timeslot routing
- confirmation starter flow
- reservation domain model

## Current Proof

- standalone root package exists
- template-root README exists
- `Templates/BookingReservationsApp/Package.swift` exists
- local generic iOS build proof is tracked via `xcodebuild -scheme BookingReservationsApp -destination 'generic/platform=iOS' build`
- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`
- root repo `swift build -c release` passes
- root repo `swift test` passes
- `Examples/BookingReservationsExample` inspection route exists

## Missing Proof

- runtime screenshot not yet published
- demo clip not yet published
- stable green hosted standalone iOS baseline should be checked on current `master`

## Start Path

```bash
open Templates/BookingReservationsApp/Package.swift
open Examples/BookingReservationsExample/README.md
xcodebuild -scheme BookingReservationsApp -destination 'generic/platform=iOS' build
```

Then validate the root package:

```bash
swift build -c release
swift test
```

## Canonical References

- [Template Root README](../../Templates/BookingReservationsApp/README.md)
- [Richer Example](../../Examples/BookingReservationsExample/README.md)
- [App Media Surface](../App-Media/BookingReservationsApp.md)
- [Template Showcase](../Template-Showcase.md)
- [Proof Matrix](../Proof-Matrix.md)
- [Portfolio Matrix](../Portfolio-Matrix.md)
