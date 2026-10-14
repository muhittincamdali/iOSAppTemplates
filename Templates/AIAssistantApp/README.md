# AIAssistantApp

AI Assistant template: a SwiftUI app for iOS 18 with Workspace, Presets, Memory, Tools and Trust tabs.

All data is in-memory sample data and there is no networking. Replace the sample
data in the store with your own services.

## Layout

| Path | Contents |
| --- | --- |
| `Sources/AIAssistantApp/AIAssistantApp.swift` | `AIAssistantAppShell` (the public `App`), the screens, and `AIAssistantOperationsStore`, a `@MainActor` `ObservableObject` that owns the sample data and every action the screens trigger |
| `Tests/AIAssistantAppTests/` | Swift Testing suite for the app's state and actions |
| `App/` | XcodeGen spec and a host file that calls `AIAssistantAppShell.main()` |

## Test

```bash
xcodebuild test -scheme AIAssistantApp -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Run

```bash
cd App
xcodegen generate
open AIAssistantApp.xcodeproj
```
