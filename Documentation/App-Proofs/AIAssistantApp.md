# AIAssistantApp Proof Surface

Generated from `Documentation/app-surface-catalog.json`.

## Product Summary

- Lane: `AI`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/AIAssistantApp/Package.swift`
- Extra route: `Examples/AIAssistantExample`
- Product target: `AI Assistant`

## Best For / Not For

### Best for

- teams reviewing an assistant-style conversation shell
- readers comparing AI lane packaging with a richer example route
- maintainers validating a privacy-aware assistant starter surface

### Not for

- teams expecting a production AI stack today
- readers who expect deeper interactive runtime flows than the current launch-to-ready scenario proof
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape Today

- conversation shell
- prompt and response surface
- assistant suggestion cards
- starter tool action surface
- AI lane example route

## Current Proof

- standalone root package exists
- template-root README exists
- `Templates/AIAssistantApp/Package.swift` exists
- `Templates/AIAssistantApp/Package.resolved` exists as the tracked dependency lockfile
- local generic iOS build proof is tracked via `xcodebuild -scheme AIAssistantApp -destination 'generic/platform=iOS' build`
- local simulator runtime launch proof is tracked via `bash Scripts/validate-runtime-app-launches.sh AIAssistantApp`
- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`
- root repo `swift build -c release` passes
- root repo `swift test` passes
- runtime screenshot is published: [../Assets/AppScreenshots/AIAssistantApp.png](../Assets/AppScreenshots/AIAssistantApp.png)
- demo clip is published: [../Assets/AppDemoClips/AIAssistantApp.mp4](../Assets/AppDemoClips/AIAssistantApp.mp4)
- launch-to-ready scenario frames are published: [launch](../Assets/AppScenarioShots/AIAssistantApp-launch.png) / [ready](../Assets/AppScenarioShots/AIAssistantApp-ready.png)
- `Examples/AIAssistantExample` inspection route exists

## Missing Proof

- stable green hosted standalone iOS baseline should be checked on current `master`

## Start Path

```bash
open Templates/AIAssistantApp/Package.swift
open Templates/AIAssistantApp/Package.resolved
open Examples/AIAssistantExample/README.md
xcodebuild -scheme AIAssistantApp -destination 'generic/platform=iOS' build
```

Then validate the root package:

```bash
swift build -c release
swift test
```

## Canonical References

- [Template Root README](../../Templates/AIAssistantApp/README.md)
- [Richer Example](../../Examples/AIAssistantExample/README.md)
- [App Media Surface](../App-Media/AIAssistantApp.md)
- [Template Showcase](../Template-Showcase.md)
- [Proof Matrix](../Proof-Matrix.md)
- [Portfolio Matrix](../Portfolio-Matrix.md)
