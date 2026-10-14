# ProductivityApp

Productivity template: a SwiftUI app for iOS 18 with Dashboard, Inbox, Projects, Focus and Review tabs.

All data is in-memory sample data and there is no networking. Replace the sample
data in the store with your own services.

## Layout

| Path | Contents |
| --- | --- |
| `Sources/ProductivityApp/ProductivityApp.swift` | `ProductivityAppShell` (the public `App`), the screens, and `ProductivityOperationsStore`, a `@MainActor` `ObservableObject` that owns the sample data and every action the screens trigger |
| `Tests/ProductivityAppTests/` | Swift Testing suite for the app's state and actions |
| `App/` | XcodeGen spec and a host file that calls `ProductivityAppShell.main()` |

## Test

```bash
xcodebuild test -scheme ProductivityApp -destination 'platform=iOS Simulator,name=iPhone 17'
```

`iPhone 17` is an example; use any simulator that `xcrun simctl list devices available` lists.

## Run

```bash
cd App
xcodegen generate
open ProductivityApp.xcodeproj
```
