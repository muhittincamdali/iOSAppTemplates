# FitnessApp

Fitness template: a SwiftUI app for iOS 18 with Plan, Session, Progress, Recovery and Profile tabs.

All data is in-memory sample data and there is no networking. Replace the sample
data in the store with your own services.

## Layout

| Path | Contents |
| --- | --- |
| `Sources/FitnessApp/FitnessApp.swift` | `FitnessAppShell` (the public `App`), the screens, and `FitnessStudioStore`, a `@MainActor` `ObservableObject` that owns the sample data and every action the screens trigger |
| `Tests/FitnessAppTests/` | Swift Testing suite for the app's state and actions |
| `App/` | XcodeGen spec and a host file that calls `FitnessAppShell.main()` |

## Test

```bash
xcodebuild test -scheme FitnessApp -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Run

```bash
cd App
xcodegen generate
open FitnessApp.xcodeproj
```
