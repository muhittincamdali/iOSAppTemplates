# CreatorShortVideoApp

Creator Short Video template: a SwiftUI app for iOS 18 with Studio, Pipeline, Analytics, Moderation and Profile tabs.

All data is in-memory sample data and there is no networking. Replace the sample
data in the store with your own services.

## Layout

| Path | Contents |
| --- | --- |
| `Sources/CreatorShortVideoApp/CreatorShortVideoApp.swift` | `CreatorShortVideoAppShell` (the public `App`), the screens, and `CreatorShortVideoStudioStore`, a `@MainActor` `ObservableObject` that owns the sample data and every action the screens trigger |
| `Tests/CreatorShortVideoAppTests/` | Swift Testing suite for the app's state and actions |
| `App/` | XcodeGen spec and a host file that calls `CreatorShortVideoAppShell.main()` |

## Test

```bash
xcodebuild test -scheme CreatorShortVideoApp -destination 'platform=iOS Simulator,name=iPhone 17'
```

`iPhone 17` is an example; use any simulator that `xcrun simctl list devices available` lists.

## Run

```bash
cd App
xcodegen generate
open CreatorShortVideoApp.xcodeproj
```
