# MessagingApp Proof Surface

Generated from `Documentation/app-surface-catalog.json`.

## Product Summary

- Lane: `Messaging / Community`
- Label today: `Standalone Root + richer example + chained runtime flow`
- Entry path: `Templates/MessagingApp/Package.swift`
- Extra route: `Examples/MessagingExample`
- Product target: `Messaging / Community`

## Best For / Not For

### Best for

- teams evaluating conversation-list and chat starter flows
- readers comparing community lanes across social and messaging surfaces
- maintainers reviewing message-thread starter patterns

### Not for

- teams expecting production realtime messaging today
- readers who expect automated multi-step interaction proof beyond the current first-screen runtime proof set
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape Today

- conversation list flow
- chat thread surface
- contact or member routing
- composer starter flow
- starter messaging model

## Current Proof

- standalone root package exists
- template-root README exists
- `Templates/MessagingApp/Package.swift` exists
- no external dependency lockfile is required today
- local generic iOS build proof is tracked via `xcodebuild -scheme MessagingApp -destination 'generic/platform=iOS' build`
- local simulator runtime launch proof is tracked via `bash Scripts/validate-runtime-app-launches.sh MessagingApp`
- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`
- root repo `swift build -c release` passes
- root repo `swift test` passes
- runtime screenshot is published: [../Assets/AppScreenshots/MessagingApp.png](../Assets/AppScreenshots/MessagingApp.png)
- demo clip is published: [../Assets/AppDemoClips/MessagingApp.mp4](../Assets/AppDemoClips/MessagingApp.mp4)
- launch-to-ready scenario frames are published: [launch](../Assets/AppScenarioShots/MessagingApp-launch.png) / [ready](../Assets/AppScenarioShots/MessagingApp-ready.png)
- `Examples/MessagingExample` inspection route exists

## Missing Proof

- stable green hosted standalone iOS baseline should be checked on current `master`

## Start Path

```bash
open Templates/MessagingApp/Package.swift
open Examples/MessagingExample/README.md
xcodebuild -scheme MessagingApp -destination 'generic/platform=iOS' build
```

Then validate the root package:

```bash
swift build -c release
swift test
```

## Canonical References

- [Template Root README](../../Templates/MessagingApp/README.md)
- [Richer Example](../../Examples/MessagingExample/README.md)
- [App Media Surface](../App-Media/MessagingApp.md)
- [Template Showcase](../Template-Showcase.md)
- [Proof Matrix](../Proof-Matrix.md)
- [Portfolio Matrix](../Portfolio-Matrix.md)
