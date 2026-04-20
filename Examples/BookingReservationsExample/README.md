# Booking Reservations Example

Bu klasor tek basina ship edilen bir Xcode app projesi degil. `BookingReservationsApp` hedef UX'inin daha zengin bir inspection surface'idir.

## Current Truth

- Ayrik `.xcodeproj` veya `.xcworkspace` burada ship edilmiyor.
- Screenshot, UI test ve reservation workflow proof bu klasore bagli degil.
- Canonical standalone package-entry root su an `Templates/BookingReservationsApp`.
- Canonical package validation root seviyedeki `swift build` ve `swift test`.

## What This Example Is Good For

- booking lane icin property, guest operations ve occupancy workflow yonunu gormek
- Wave 2 app-pack icin richer example surface'i takip etmek
- reservation decision surface ve operations naming incelemek

## Start Here

```bash
open ../../Templates/BookingReservationsApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Related Docs

- [Portfolio Matrix](../../Documentation/Portfolio-Matrix.md)
- [BookingReservations Proof](../../Documentation/App-Proofs/BookingReservationsApp.md)
- [BookingReservations Media](../../Documentation/App-Media/BookingReservationsApp.md)
