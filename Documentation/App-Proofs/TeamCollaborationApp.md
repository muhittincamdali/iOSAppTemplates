# TeamCollaborationApp Proof Surface

Generated from `Documentation/app-surface-catalog.json`.

## Product Summary

- Lane: `Team Collaboration`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/TeamCollaborationApp/Package.swift`
- Extra route: `Examples/TeamCollaborationExample`
- Product target: `Team Collaboration`

## Best For / Not For

### Best for

- teams evaluating project and teammate coordination starter flows
- readers comparing productivity and collaboration-oriented roots
- maintainers reviewing collaboration boards and activity surfaces

### Not for

- teams expecting a full collaborative backend today
- readers who expect deeper runtime scenario coverage than the current screenshot and demo proof
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape Today

- workspace shell
- team activity surface
- project board starter flow
- member cards
- collaboration starter model

## Current Proof

- standalone root package exists
- template-root README exists
- `Templates/TeamCollaborationApp/Package.swift` exists
- no external dependency lockfile is required today
- local generic iOS build proof is tracked via `xcodebuild -scheme TeamCollaborationApp -destination 'generic/platform=iOS' build`
- local simulator runtime launch proof is tracked via `bash Scripts/validate-runtime-app-launches.sh TeamCollaborationApp`
- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`
- root repo `swift build -c release` passes
- root repo `swift test` passes
- runtime screenshot is published: [../Assets/AppScreenshots/TeamCollaborationApp.png](../Assets/AppScreenshots/TeamCollaborationApp.png)
- demo clip is published: [../Assets/AppDemoClips/TeamCollaborationApp.mp4](../Assets/AppDemoClips/TeamCollaborationApp.mp4)
- `Examples/TeamCollaborationExample` inspection route exists

## Missing Proof

- stable green hosted standalone iOS baseline should be checked on current `master`

## Start Path

```bash
open Templates/TeamCollaborationApp/Package.swift
open Examples/TeamCollaborationExample/README.md
xcodebuild -scheme TeamCollaborationApp -destination 'generic/platform=iOS' build
```

Then validate the root package:

```bash
swift build -c release
swift test
```

## Canonical References

- [Template Root README](../../Templates/TeamCollaborationApp/README.md)
- [Richer Example](../../Examples/TeamCollaborationExample/README.md)
- [App Media Surface](../App-Media/TeamCollaborationApp.md)
- [Template Showcase](../Template-Showcase.md)
- [Proof Matrix](../Proof-Matrix.md)
- [Portfolio Matrix](../Portfolio-Matrix.md)
