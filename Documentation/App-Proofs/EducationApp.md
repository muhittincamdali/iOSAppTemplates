# EducationApp Proof Surface

Generated from `Documentation/app-surface-catalog.json`.

## Product Summary

- Lane: `Education`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/EducationApp/Package.swift`
- Extra route: `Examples/EducationExample`
- Product target: `Education / Learning`

## Best For / Not For

### Best for

- teams evaluating a course and lesson starter shell
- readers comparing education family targets with a standalone root
- maintainers reviewing study-session and content models

### Not for

- teams expecting a fully instrumented LMS today
- readers who assume runtime screenshots and clips are already published
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape Today

- course overview shell
- lesson routing
- assignment and quiz models
- study-session summary
- starter learning progress surface

## Current Proof

- standalone root package exists
- template-root README exists
- `Templates/EducationApp/Package.swift` exists
- `Templates/EducationApp/Package.resolved` exists as the tracked dependency lockfile
- local generic iOS build proof is tracked via `xcodebuild -scheme EducationApp -destination 'generic/platform=iOS' build`
- local simulator runtime launch proof is tracked via `bash Scripts/validate-runtime-app-launches.sh EducationApp`
- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`
- root repo `swift build -c release` passes
- root repo `swift test` passes
- runtime screenshot is published: [../Assets/AppScreenshots/EducationApp.png](../Assets/AppScreenshots/EducationApp.png)
- demo clip is published: [../Assets/AppDemoClips/EducationApp.mp4](../Assets/AppDemoClips/EducationApp.mp4)
- `Examples/EducationExample` inspection route exists

## Missing Proof

- stable green hosted standalone iOS baseline should be checked on current `master`

## Start Path

```bash
open Templates/EducationApp/Package.swift
open Templates/EducationApp/Package.resolved
open Examples/EducationExample/README.md
xcodebuild -scheme EducationApp -destination 'generic/platform=iOS' build
```

Then validate the root package:

```bash
swift build -c release
swift test
```

## Canonical References

- [Template Root README](../../Templates/EducationApp/README.md)
- [Richer Example](../../Examples/EducationExample/README.md)
- [App Media Surface](../App-Media/EducationApp.md)
- [Template Showcase](../Template-Showcase.md)
- [Proof Matrix](../Proof-Matrix.md)
- [Portfolio Matrix](../Portfolio-Matrix.md)
