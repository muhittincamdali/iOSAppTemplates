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
| `Sources/SocialMediaApp/SocialMediaApp.swift` | `SocialMediaAppShell` (the public `App`), the screens, and `AuthManager`, `DataManager` and `NotificationManager` |
| `Sources/SocialMediaApp/AuthService.swift` | `AuthService` protocol and `LocalAuthService` |
| `Tests/SocialMediaAppTests/` | Swift Testing suite for the app's state and actions |
| `App/` | XcodeGen spec and a host file that calls `SocialMediaAppShell.main()` |

## Test

```bash
xcodebuild test -scheme SocialMediaApp -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Run

```bash
cd App
xcodegen generate
open SocialMediaApp.xcodeproj
```

## Start a project from this template

From the repository root:

```bash
swift run create-ios-app new MyApp --template social
```
