# FinanceApp

Personal Finance template: a SwiftUI app for iOS 18 with Overview, Accounts, Budgets, Activity and Insights tabs.

All data is in-memory sample data and there is no networking. Replace the sample
data in the store with your own services.

## Layout

| Path | Contents |
| --- | --- |
| `Sources/FinanceApp/FinanceApp.swift` | `FinanceAppShell` (the public `App`), the screens, and `FinanceOperatingStore`, a `@MainActor` `ObservableObject` that owns the sample data and every action the screens trigger |
| `Tests/FinanceAppTests/` | Swift Testing suite for the app's state and actions |
| `App/` | XcodeGen spec and a host file that calls `FinanceAppShell.main()` |

## Test

```bash
xcodebuild test -scheme FinanceApp -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Run

```bash
cd App
xcodegen generate
open FinanceApp.xcodeproj
```

## Start a project from this template

From the repository root:

```bash
swift run create-ios-app new MyApp --template finance
```
