# EducationApp

Education template: a SwiftUI app for iOS 18 with Home, Courses, Lessons, Assessments and Progress tabs.

All data is in-memory sample data and there is no networking. Replace the sample
data in the store with your own services.

## Layout

| Path | Contents |
| --- | --- |
| `Sources/EducationApp/EducationApp.swift` | `EducationAppShell` (the public `App`), the screens, and `EducationLearningStore`, a `@MainActor` `ObservableObject` that owns the sample data and every action the screens trigger |
| `Tests/EducationAppTests/` | Swift Testing suite for the app's state and actions |
| `App/` | XcodeGen spec and a host file that calls `EducationAppShell.main()` |

## Test

```bash
xcodebuild test -scheme EducationApp -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Run

```bash
cd App
xcodegen generate
open EducationApp.xcodeproj
```
