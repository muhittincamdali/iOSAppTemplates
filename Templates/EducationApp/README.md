# EducationApp

Generated from `Documentation/app-surface-catalog.json`.

`EducationApp` is the standalone-root surface for the `Education` lane inside `iOSAppTemplates`.

## Today

- Label: `Standalone Root + richer example surface`
- Lane: `Education`
- Entry: `Package.swift`
- Product target: `Education / Learning`
- Richer example: `Examples/EducationExample`

## Best For / Not For

### Best for

- teams evaluating a course and lesson starter shell
- readers comparing education family targets with a standalone root
- maintainers reviewing study-session and content models

### Not for

- teams expecting a fully instrumented LMS today
- readers who assume runtime screenshots and clips are already published
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape

- course overview shell
- lesson routing
- assignment and quiz models
- study-session summary
- starter learning progress surface

## Current Proof

- `Package.resolved` exists as the tracked dependency lockfile
- `swift package dump-package` passes
- local `swift test` passes
- `xcodebuild -scheme EducationApp -destination 'generic/platform=iOS' build` passes
- `bash Scripts/validate-runtime-app-launches.sh EducationApp` passes locally
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
open Package.resolved
open ../../Examples/EducationExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

Standalone generic iOS proof:

```bash
xcodebuild -scheme EducationApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/EducationApp.md)
- [Media Surface](../../Documentation/App-Media/EducationApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
- [Richer Example](../../Examples/EducationExample/README.md)
