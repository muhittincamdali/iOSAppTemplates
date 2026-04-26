# TeamCollaborationApp

Generated from `Documentation/app-surface-catalog.json`.

`TeamCollaborationApp` is the standalone-root surface for the `Team Collaboration` lane inside `iOSAppTemplates`.

## Today

- Label: `Standalone Root + richer example surface`
- Lane: `Team Collaboration`
- Entry: `Package.swift`
- Product target: `Team Collaboration`
- Richer example: `Examples/TeamCollaborationExample`

## Best For / Not For

### Best for

- teams evaluating project and teammate coordination starter flows
- readers comparing productivity and collaboration-oriented roots
- maintainers reviewing collaboration boards and activity surfaces

### Not for

- teams expecting a full collaborative backend today
- readers who assume demo clips and stable hosted standalone iOS proof already exist
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape

- workspace shell
- team activity surface
- project board starter flow
- member cards
- collaboration starter model

## Current Proof

- No external dependency lockfile is required today
- `swift package dump-package` passes
- local `swift test` passes
- `xcodebuild -scheme TeamCollaborationApp -destination 'generic/platform=iOS' build` passes
- `bash Scripts/validate-runtime-app-launches.sh TeamCollaborationApp` passes locally
- root repo `swift build -c release` passes
- root repo `swift test` passes
- canonical app proof page exists
- canonical app media page exists
- runtime screenshot is published
- demo clip is published
- richer example route exists

## Missing Proof

- stable green hosted standalone iOS baseline on current `master`

## Start Here

```bash
open Package.swift
open ../../Examples/TeamCollaborationExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

Standalone generic iOS proof:

```bash
xcodebuild -scheme TeamCollaborationApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/TeamCollaborationApp.md)
- [Media Surface](../../Documentation/App-Media/TeamCollaborationApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
- [Richer Example](../../Examples/TeamCollaborationExample/README.md)
