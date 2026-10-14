# TravelPlannerApp

Travel Planner template: a SwiftUI app for iOS 18 with Trips, Timeline, Bookings, Essentials and Profile tabs.

All data is in-memory sample data and there is no networking. Replace the sample
data in the store with your own services.

## Layout

| Path | Contents |
| --- | --- |
| `Sources/TravelPlannerApp/TravelPlannerApp.swift` | `TravelPlannerAppShell` (the public `App`), the screens, and `TravelPlannerOperationsStore`, a `@MainActor` `ObservableObject` that owns the sample data and every action the screens trigger |
| `Tests/TravelPlannerAppTests/` | Swift Testing suite for the app's state and actions |
| `App/` | XcodeGen spec and a host file that calls `TravelPlannerAppShell.main()` |

## Test

```bash
xcodebuild test -scheme TravelPlannerApp -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Run

```bash
cd App
xcodegen generate
open TravelPlannerApp.xcodeproj
```

## Start a project from this template

From the repository root:

```bash
swift run create-ios-app new MyApp --template travel
```
