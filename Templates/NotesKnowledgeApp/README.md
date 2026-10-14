# NotesKnowledgeApp

Notes & Knowledge template: a SwiftUI app for iOS 18 with Capture, Library, Links, Spaces and Profile tabs.

All data is in-memory sample data and there is no networking. Replace the sample
data in the store with your own services.

## Layout

| Path | Contents |
| --- | --- |
| `Sources/NotesKnowledgeApp/NotesKnowledgeApp.swift` | `NotesKnowledgeAppShell` (the public `App`), the screens, and `NotesKnowledgeOperationsStore`, a `@MainActor` `ObservableObject` that owns the sample data and every action the screens trigger |
| `Tests/NotesKnowledgeAppTests/` | Swift Testing suite for the app's state and actions |
| `App/` | XcodeGen spec and a host file that calls `NotesKnowledgeAppShell.main()` |

## Test

```bash
xcodebuild test -scheme NotesKnowledgeApp -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Run

```bash
cd App
xcodegen generate
open NotesKnowledgeApp.xcodeproj
```

## Start a project from this template

From the repository root:

```bash
swift run create-ios-app new MyApp --template notes
```
