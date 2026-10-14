# SubscriptionLifestyleApp

Subscription Lifestyle template: a SwiftUI app for iOS 18 with Dashboard, Programs, Streaks, Plans and Profile tabs.

All data is in-memory sample data and there is no networking. Replace the sample
data in the store with your own services.

## Layout

| Path | Contents |
| --- | --- |
| `Sources/SubscriptionLifestyleApp/SubscriptionLifestyleApp.swift` | `SubscriptionLifestyleAppShell` (the public `App`), the screens, and `SubscriptionLifestyleOperationsStore`, a `@MainActor` `ObservableObject` that owns the sample data and every action the screens trigger |
| `Tests/SubscriptionLifestyleAppTests/` | Swift Testing suite for the app's state and actions |
| `App/` | XcodeGen spec and a host file that calls `SubscriptionLifestyleAppShell.main()` |

## Test

```bash
xcodebuild test -scheme SubscriptionLifestyleApp -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Run

```bash
cd App
xcodegen generate
open SubscriptionLifestyleApp.xcodeproj
```
