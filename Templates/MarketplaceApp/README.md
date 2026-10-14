# MarketplaceApp

Marketplace template: a SwiftUI app for iOS 18 with Home, Browse, Seller, Orders and Trust tabs.

All data is in-memory sample data and there is no networking. Replace the sample
data in the store with your own services.

## Layout

| Path | Contents |
| --- | --- |
| `Sources/MarketplaceApp/MarketplaceApp.swift` | `MarketplaceAppShell` (the public `App`), the screens, and `MarketplaceOperationsStore`, a `@MainActor` `ObservableObject` that owns the sample data and every action the screens trigger |
| `Tests/MarketplaceAppTests/` | Swift Testing suite for the app's state and actions |
| `App/` | XcodeGen spec and a host file that calls `MarketplaceAppShell.main()` |

## Test

```bash
xcodebuild test -scheme MarketplaceApp -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Run

```bash
cd App
xcodegen generate
open MarketplaceApp.xcodeproj
```
