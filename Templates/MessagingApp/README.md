# MessagingApp

Messaging template: a SwiftUI app for iOS 18 with Inbox, Rooms, Safety and Profile tabs.

All data is in-memory sample data and there is no networking. Replace the sample
data in the store with your own services.

## Layout

| Path | Contents |
| --- | --- |
| `Sources/MessagingApp/MessagingApp.swift` | `MessagingAppShell` (the public `App`), the screens, and `MessagingCommandCenterStore`, a `@MainActor` `ObservableObject` that owns the sample data and every action the screens trigger |
| `Tests/MessagingAppTests/` | Swift Testing suite for the app's state and actions |
| `App/` | XcodeGen spec and a host file that calls `MessagingAppShell.main()` |

## Test

```bash
xcodebuild test -scheme MessagingApp -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Run

```bash
cd App
xcodegen generate
open MessagingApp.xcodeproj
```

## Start a project from this template

From the repository root:

```bash
swift run create-ios-app new MyApp --template messaging
```
