# BookingReservationsApp Proof Surface

Last updated: 2026-04-20

## Product Summary

- Lane: `Booking / Reservations`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/BookingReservationsApp/Package.swift`
- Extra route: `Examples/BookingReservationsExample`
- Product target: `Booking & Reservations`

## Best For / Not For

### Best for

- reservation dashboard, property routing ve guest operations flow incelemek isteyen ekipler
- standalone root ile richer example surface'i birlikte gormek isteyenler
- Wave 2 icin gercek booking/reservations packaging kaniti isteyenler

### Not for

- bugun complete hospitality parity bekleyenler
- screenshot/demo proof'un zaten mevcut oldugunu varsayanlar
- hosted standalone iOS CI proof'unun verildigini dusunenler

## Product Shape Today

- reservation operations shell
- property and stay routing
- support and payment health surface
- richer booking example route

## Current Proof

- standalone root package mevcut
- template-root README mevcut
- `Templates/BookingReservationsApp/Package.swift` dependency-free app shell graph'i veriyor; no external dependency lockfile is required
- `swift package dump-package` gecerli
- `cd Templates/BookingReservationsApp && swift test` gecerli
- `xcodebuild -scheme BookingReservationsApp -destination 'generic/platform=iOS' build` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- `Examples/BookingReservationsExample` inspection route mevcut

## Missing Proof

- canonical screenshot yok
- demo clip yok
- hosted standalone iOS CI proof yok

## Start Path

```bash
open Templates/BookingReservationsApp/Package.swift
open Examples/BookingReservationsExample/README.md
```

Root repo proof icin:

```bash
swift build
swift test
```

Standalone generic iOS proof icin:

```bash
cd Templates/BookingReservationsApp
xcodebuild -scheme BookingReservationsApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Template Root README](../../Templates/BookingReservationsApp/README.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Portfolio-Matrix.md](../Portfolio-Matrix.md)
