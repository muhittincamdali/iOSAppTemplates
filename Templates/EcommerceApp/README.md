# EcommerceApp

E-commerce template: a SwiftUI app for iOS 18 with Shop, Browse, Cart, Orders and Profile tabs.

All data is in-memory sample data and there is no networking. Replace the sample
data in the store with your own services.

## Layout

| Path | Contents |
| --- | --- |
| `Sources/EcommerceApp/EcommerceApp.swift` | `EcommerceAppShell` (the public `App`) and the root tab view |
| `Sources/EcommerceApp/CommerceStore.swift` | `CommerceStore`, a `@MainActor` `ObservableObject` that owns the sample data and every action the screens trigger |
| `Sources/EcommerceApp/CommerceModels.swift` | Value types for categories, products, cart items, addresses, payment methods, orders and their fulfillment and return states |
| `Sources/EcommerceApp/Commerce*View.swift`, `Commerce*Views.swift` | Home, catalog and product detail, cart and checkout, orders and profile screens |
| `Tests/EcommerceAppTests/` | Swift Testing suite for the app's state and actions |
| `App/` | XcodeGen spec and a host file that calls `EcommerceAppShell.main()` |

## Test

```bash
xcodebuild test -scheme EcommerceApp -destination 'platform=iOS Simulator,name=iPhone 17'
```

`iPhone 17` is an example; use any simulator that `xcrun simctl list devices available` lists.

## Run

```bash
cd App
xcodegen generate
open EcommerceApp.xcodeproj
```
