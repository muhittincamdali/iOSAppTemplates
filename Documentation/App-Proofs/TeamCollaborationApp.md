# TeamCollaborationApp Proof Surface

Last updated: 2026-04-21

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
- readers who assume runtime screenshots and demo clips are already published
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
- local generic iOS build proof is tracked via `xcodebuild -scheme TeamCollaborationApp -destination 'generic/platform=iOS' build`
- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`
- root repo `swift build -c release` passes
- root repo `swift test` passes
- `Examples/TeamCollaborationExample` inspection route exists

## Missing Proof

- runtime screenshot not yet published
- demo clip not yet published
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
