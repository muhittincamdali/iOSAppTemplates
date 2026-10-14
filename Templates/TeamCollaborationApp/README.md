# TeamCollaborationApp

Team Collaboration template: a SwiftUI app for iOS 18 with Workspace, Tasks, Decisions, Handoffs and Profile tabs.

All data is in-memory sample data and there is no networking. Replace the sample
data in the store with your own services.

## Layout

| Path | Contents |
| --- | --- |
| `Sources/TeamCollaborationApp/TeamCollaborationApp.swift` | `TeamCollaborationAppShell` (the public `App`), the screens, and `TeamCollaborationOperationsStore`, a `@MainActor` `ObservableObject` that owns the sample data and every action the screens trigger |
| `Tests/TeamCollaborationAppTests/` | Swift Testing suite for the app's state and actions |
| `App/` | XcodeGen spec and a host file that calls `TeamCollaborationAppShell.main()` |

## Test

```bash
xcodebuild test -scheme TeamCollaborationApp -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Run

```bash
cd App
xcodegen generate
open TeamCollaborationApp.xcodeproj
```

## Start a project from this template

From the repository root:

```bash
swift run create-ios-app new MyApp --template team-collaboration
```
