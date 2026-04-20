# BookingReservationsExample

Generated from `Documentation/app-surface-catalog.json`.

`BookingReservationsExample` is the richer example surface for the `Booking / Reservations` lane.

## Product Shape

- availability shell
- reservation detail surface
- calendar or timeslot routing
- confirmation starter flow

## Best For / Not For

### Best for

- teams that want a second inspection route beyond `BookingReservationsApp`
- readers who want to inspect the `Booking & Reservations` flow in a more product-like format

### Not for

- teams expecting a separate runnable Xcode project
- readers who expect published runtime screenshots or simulator media proof today

## Current Truth

- this example is an inspection surface, not a separate shipped app project
- the canonical standalone package-entry path lives under `Templates/`
- canonical package validation remains the root-level `swift build` and `swift test` flow

## Start Here

```bash
open ../../Templates/BookingReservationsApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Canonical References

- [BookingReservationsApp Proof](../../Documentation/App-Proofs/BookingReservationsApp.md)
- [BookingReservationsApp Media](../../Documentation/App-Media/BookingReservationsApp.md)
- [Wave 1 Plan](../../Documentation/Wave-1-Implementation-Plan.md)
