# NewsBlogApp

News & Blog template: a SwiftUI app for iOS 18 with Today, Sections, Saved, Digest and Profile tabs.

All data is in-memory sample data and there is no networking. Replace the sample
data in the store with your own services.

## Layout

| Path | Contents |
| --- | --- |
| `Sources/NewsBlogApp/NewsBlogApp.swift` | `NewsBlogAppShell` (the public `App`), the screens, and `NewsBlogOperationsStore`, a `@MainActor` `ObservableObject` that owns the sample data and every action the screens trigger |
| `Tests/NewsBlogAppTests/` | Swift Testing suite for the app's state and actions |
| `App/` | XcodeGen spec and a host file that calls `NewsBlogAppShell.main()` |

## Test

```bash
xcodebuild test -scheme NewsBlogApp -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Run

```bash
cd App
xcodegen generate
open NewsBlogApp.xcodeproj
```
