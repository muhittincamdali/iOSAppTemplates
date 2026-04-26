# AIAssistantApp

Generated from `Documentation/app-surface-catalog.json`.

`AIAssistantApp` is the standalone-root surface for the `AI` lane inside `iOSAppTemplates`.

## Today

- Label: `Standalone Root + richer example surface`
- Lane: `AI`
- Entry: `Package.swift`
- Product target: `AI Assistant`
- Richer example: `Examples/AIAssistantExample`

## Best For / Not For

### Best for

- teams reviewing an assistant-style conversation shell
- readers comparing AI lane packaging with a richer example route
- maintainers validating a privacy-aware assistant starter surface

### Not for

- teams expecting a production AI stack today
- readers who expect deeper interactive runtime flows than the current launch-to-ready scenario proof
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape

- conversation shell
- prompt and response surface
- assistant suggestion cards
- starter tool action surface
- AI lane example route

## Current Proof

- `Package.resolved` exists as the tracked dependency lockfile
- `swift package dump-package` passes
- local `swift test` passes
- `xcodebuild -scheme AIAssistantApp -destination 'generic/platform=iOS' build` passes
- `bash Scripts/validate-runtime-app-launches.sh AIAssistantApp` passes locally
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
open Package.resolved
open ../../Examples/AIAssistantExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

Standalone generic iOS proof:

```bash
xcodebuild -scheme AIAssistantApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/AIAssistantApp.md)
- [Media Surface](../../Documentation/App-Media/AIAssistantApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
- [Richer Example](../../Examples/AIAssistantExample/README.md)
