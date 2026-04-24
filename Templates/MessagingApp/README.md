# MessagingApp

Generated from `Documentation/app-surface-catalog.json`.

`MessagingApp` is the standalone-root surface for the `Messaging / Community` lane inside `iOSAppTemplates`.

## Today

- Label: `Standalone Root + richer example surface`
- Lane: `Messaging / Community`
- Entry: `Package.swift`
- Product target: `Messaging / Community`
- Richer example: `Examples/MessagingExample`

## Best For / Not For

### Best for

- teams evaluating conversation-list and chat starter flows
- readers comparing community lanes across social and messaging surfaces
- maintainers reviewing message-thread starter patterns

### Not for

- teams expecting production realtime messaging today
- readers who assume demo clips and stable hosted standalone iOS proof already exist
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape

- conversation list shell
- chat thread surface
- contact or member routing
- composer starter flow
- starter messaging model

## Current Proof

- No external dependency lockfile is required today
- `swift package dump-package` passes
- local `swift test` passes
- `xcodebuild -scheme MessagingApp -destination 'generic/platform=iOS' build` passes
- `bash Scripts/validate-runtime-app-launches.sh MessagingApp` passes locally
- root repo `swift build -c release` passes
- root repo `swift test` passes
- canonical app proof page exists
- canonical app media page exists
- runtime screenshot is published
- richer example route exists

## Missing Proof

- demo clip
- stable green hosted standalone iOS baseline on current `master`

## Start Here

```bash
open Package.swift
open ../../Examples/MessagingExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

Standalone generic iOS proof:

```bash
xcodebuild -scheme MessagingApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/MessagingApp.md)
- [Media Surface](../../Documentation/App-Media/MessagingApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
- [Richer Example](../../Examples/MessagingExample/README.md)
