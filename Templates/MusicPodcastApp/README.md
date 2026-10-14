# MusicPodcastApp

Music & Podcasts template: a SwiftUI app for iOS 18 with Library, Queue, Downloads, Discover and Profile tabs.

All data is in-memory sample data and there is no networking. Replace the sample
data in the store with your own services.

## Layout

| Path | Contents |
| --- | --- |
| `Sources/MusicPodcastApp/MusicPodcastApp.swift` | `MusicPodcastAppShell` (the public `App`), the screens, and `MusicPodcastOperationsStore`, a `@MainActor` `ObservableObject` that owns the sample data and every action the screens trigger |
| `Tests/MusicPodcastAppTests/` | Swift Testing suite for the app's state and actions |
| `App/` | XcodeGen spec and a host file that calls `MusicPodcastAppShell.main()` |

## Test

```bash
xcodebuild test -scheme MusicPodcastApp -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Run

```bash
cd App
xcodegen generate
open MusicPodcastApp.xcodeproj
```
