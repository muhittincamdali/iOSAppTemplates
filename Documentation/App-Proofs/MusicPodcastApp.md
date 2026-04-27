# MusicPodcastApp Proof Surface

Generated from `Documentation/app-surface-catalog.json`.

## Product Summary

- Lane: `Music / Podcast`
- Label today: `Standalone Root + richer example + rebuilt runtime flow`
- Entry path: `Templates/MusicPodcastApp/Package.swift`
- Extra route: `Examples/MusicPodcastExample`
- Product target: `Music / Podcast`

## Best For / Not For

### Best for

- teams evaluating media-library and player starter flows
- readers comparing entertainment packaging and richer example routing
- maintainers reviewing audio-first UI patterns

### Not for

- teams expecting production streaming infrastructure today
- readers who expect automated multi-step interaction proof beyond the current first-screen runtime proof set
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape Today

- library flow
- player surface
- episode or track cards
- queue starter flow
- media content model

## Current Proof

- standalone root package exists
- template-root README exists
- `Templates/MusicPodcastApp/Package.swift` exists
- no external dependency lockfile is required today
- local generic iOS build proof is tracked via `xcodebuild -scheme MusicPodcastApp -destination 'generic/platform=iOS' build`
- local simulator runtime launch proof is tracked via `bash Scripts/validate-runtime-app-launches.sh MusicPodcastApp`
- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`
- root repo `swift build -c release` passes
- root repo `swift test` passes
- runtime screenshot is published: [../Assets/AppScreenshots/MusicPodcastApp.png](../Assets/AppScreenshots/MusicPodcastApp.png)
- demo clip is published: [../Assets/AppDemoClips/MusicPodcastApp.mp4](../Assets/AppDemoClips/MusicPodcastApp.mp4)
- launch-to-ready scenario frames are published: [launch](../Assets/AppScenarioShots/MusicPodcastApp-launch.png) / [ready](../Assets/AppScenarioShots/MusicPodcastApp-ready.png)
- `Examples/MusicPodcastExample` inspection route exists

## Missing Proof

- stable green hosted standalone iOS baseline should be checked on current `master`

## Start Path

```bash
open Templates/MusicPodcastApp/Package.swift
open Examples/MusicPodcastExample/README.md
xcodebuild -scheme MusicPodcastApp -destination 'generic/platform=iOS' build
```

Then validate the root package:

```bash
swift build -c release
swift test
```

## Canonical References

- [Template Root README](../../Templates/MusicPodcastApp/README.md)
- [Richer Example](../../Examples/MusicPodcastExample/README.md)
- [App Media Surface](../App-Media/MusicPodcastApp.md)
- [Template Showcase](../Template-Showcase.md)
- [Proof Matrix](../Proof-Matrix.md)
- [Portfolio Matrix](../Portfolio-Matrix.md)
