# FoodDeliveryApp

Food Delivery template: a SwiftUI app for iOS 18 with Home, Browse, Cart, Orders and Profile tabs.

All data is in-memory sample data and there is no networking. Replace the sample
data in the store with your own services.

## Layout

| Path | Contents |
| --- | --- |
| `Sources/FoodDeliveryApp/FoodDeliveryApp.swift` | `FoodDeliveryAppShell` (the public `App`), the screens, and `FoodDeliveryOperationsStore`, a `@MainActor` `ObservableObject` that owns the sample data and every action the screens trigger |
| `Tests/FoodDeliveryAppTests/` | Swift Testing suite for the app's state and actions |
| `App/` | XcodeGen spec and a host file that calls `FoodDeliveryAppShell.main()` |

## Test

```bash
xcodebuild test -scheme FoodDeliveryApp -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Run

```bash
cd App
xcodegen generate
open FoodDeliveryApp.xcodeproj
```

## Start a project from this template

From the repository root:

```bash
swift run create-ios-app new MyApp --template food-delivery
```
