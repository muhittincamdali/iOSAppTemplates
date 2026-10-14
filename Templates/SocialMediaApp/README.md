# SocialMediaApp

Social Media template: a SwiftUI app for iOS 18 with Feed, Explore, Create, Notifications and Profile tabs.

Posts, profiles and notifications are in-memory sample data and there is no networking.
Sign-in goes through the `AuthService` protocol in `AuthService.swift`. The bundled
`LocalAuthService` keeps accounts in memory, remembers the signed-in email in
`UserDefaults` and includes a demo account (`demo@example.com` / `password123`).
Conform another type to `AuthService` to use Firebase, Sign in with Apple or your backend.

## Layout

| Path | Contents |
| --- | --- |
| `Sources/SocialMediaApp/SocialMediaApp.swift` | `SocialMediaAppShell` (the public `App`) and the view that switches between the splash screen, sign-in and the main tabs |
| `Sources/SocialMediaApp/AuthManager.swift`, `DataManager.swift`, `NotificationManager.swift` | The `@MainActor` `ObservableObject` types that own the session, the feed data and the notifications |
| `Sources/SocialMediaApp/Models.swift`, `FeedViewModel.swift` | Value types for users, suggested profiles, posts, comments and notifications, and the feed's view model |
| `Sources/SocialMediaApp/*View.swift`, `*Views.swift`, `Components.swift` | Sign-in, feed, explore, post creation, notifications, profile and comment screens, and shared controls |
| `Sources/SocialMediaApp/AuthService.swift` | `AuthService` protocol and `LocalAuthService` |
| `Tests/SocialMediaAppTests/` | Swift Testing suite for the app's state and actions |
| `App/` | XcodeGen spec and a host file that calls `SocialMediaAppShell.main()` |

## Test

```bash
xcodebuild test -scheme SocialMediaApp -destination 'platform=iOS Simulator,name=iPhone 17'
```

`iPhone 17` is an example; use any simulator that `xcrun simctl list devices available` lists.

## Run

```bash
cd App
xcodegen generate
open SocialMediaApp.xcodeproj
```
