# BookingReservationsApp

Booking & Reservations template: a SwiftUI app for iOS 18 with Home, Calendar, Guests, Requests and Profile tabs.

All data is in-memory sample data and there is no networking. Replace the sample
data in the store with your own services.

## Layout

| Path | Contents |
| --- | --- |
| `Sources/BookingReservationsApp/BookingReservationsApp.swift` | `BookingReservationsAppShell` (the public `App`), the screens, and `BookingOperationsStore`, a `@MainActor` `ObservableObject` that owns the sample data and every action the screens trigger |
| `Tests/BookingReservationsAppTests/` | Swift Testing suite for the app's state and actions |
| `App/` | XcodeGen spec and a host file that calls `BookingReservationsAppShell.main()` |

## Test

```bash
xcodebuild test -scheme BookingReservationsApp -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Run

```bash
cd App
xcodegen generate
open BookingReservationsApp.xcodeproj
```
