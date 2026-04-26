# SocialMediaApp Proof Surface

Generated from `Documentation/app-surface-catalog.json`.

## Product Summary

- Lane: `Social`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/SocialMediaApp/Package.swift`
- Extra route: `Examples/SocialMediaExample`
- Product target: `Social Media`

## Best For / Not For

### Best for

- teams inspecting feed and community starter flows
- teams that want a standalone root plus richer example route
- maintainers reviewing auth, feed, and interaction shells at source level

### Not for

- teams expecting full production social parity today
- readers who expect deeper interactive runtime flows than the current launch-to-ready scenario proof
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape Today

- auth shell
- profile model surface
- feed and community shell
- notification manager surface
- richer social example route

## Current Proof

- standalone root package exists
- template-root README exists
- `Templates/SocialMediaApp/Package.swift` exists
- `Templates/SocialMediaApp/Package.resolved` exists as the tracked dependency lockfile
- local generic iOS build proof is tracked via `xcodebuild -scheme SocialMediaApp -destination 'generic/platform=iOS' build`
- local simulator runtime launch proof is tracked via `bash Scripts/validate-runtime-app-launches.sh SocialMediaApp`
- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`
- root repo `swift build -c release` passes
- root repo `swift test` passes
- runtime screenshot is published: [../Assets/AppScreenshots/SocialMediaApp.png](../Assets/AppScreenshots/SocialMediaApp.png)
- demo clip is published: [../Assets/AppDemoClips/SocialMediaApp.mp4](../Assets/AppDemoClips/SocialMediaApp.mp4)
- launch-to-ready scenario frames are published: [launch](../Assets/AppScenarioShots/SocialMediaApp-launch.png) / [ready](../Assets/AppScenarioShots/SocialMediaApp-ready.png)
- `Examples/SocialMediaExample` inspection route exists

## Missing Proof

- stable green hosted standalone iOS baseline should be checked on current `master`

## Start Path

```bash
open Templates/SocialMediaApp/Package.swift
open Templates/SocialMediaApp/Package.resolved
open Examples/SocialMediaExample/README.md
xcodebuild -scheme SocialMediaApp -destination 'generic/platform=iOS' build
```

Then validate the root package:

```bash
swift build -c release
swift test
```

## Canonical References

- [Template Root README](../../Templates/SocialMediaApp/README.md)
- [Richer Example](../../Examples/SocialMediaExample/README.md)
- [App Media Surface](../App-Media/SocialMediaApp.md)
- [Template Showcase](../Template-Showcase.md)
- [Proof Matrix](../Proof-Matrix.md)
- [Portfolio Matrix](../Portfolio-Matrix.md)
