# PrivacyVaultApp

Privacy Vault template: a SwiftUI app for iOS 18 with Vault, Alerts, Recovery, Audit and Profile tabs.

All data is in-memory sample data and there is no networking. Replace the sample
data in the store with your own services.

## Layout

| Path | Contents |
| --- | --- |
| `Sources/PrivacyVaultApp/PrivacyVaultApp.swift` | `PrivacyVaultAppShell` (the public `App`), the screens, and `PrivacyVaultOperationsStore`, a `@MainActor` `ObservableObject` that owns the sample data and every action the screens trigger |
| `Sources/PrivacyVaultApp/PrivacyVaultModels.swift` | Dashboard snapshot, collection and health value types |
| `Tests/PrivacyVaultAppTests/` | Swift Testing suite for the app's state and actions |
| `App/` | XcodeGen spec and a host file that calls `PrivacyVaultAppShell.main()` |

## Test

```bash
xcodebuild test -scheme PrivacyVaultApp -destination 'platform=iOS Simulator,name=iPhone 17'
```

`iPhone 17` is an example; use any simulator that `xcrun simctl list devices available` lists.

## Run

```bash
cd App
xcodegen generate
open PrivacyVaultApp.xcodeproj
```
