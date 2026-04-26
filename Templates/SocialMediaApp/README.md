# SocialMediaApp

Generated from `Documentation/app-surface-catalog.json`.

`SocialMediaApp` is the standalone-root surface for the `Social` lane inside `iOSAppTemplates`.

## Today

- Label: `Standalone Root + richer example surface`
- Lane: `Social`
- Entry: `Package.swift`
- Product target: `Social Media`
- Richer example: `Examples/SocialMediaExample`

## Best For / Not For

### Best for

- teams inspecting feed and community starter flows
- teams that want a standalone root plus richer example route
- maintainers reviewing auth, feed, and interaction shells at source level

### Not for

- teams expecting full production social parity today
- readers who expect deeper interactive runtime flows than the current launch-to-ready scenario proof
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape

- auth shell
- profile model surface
- feed and community shell
- notification manager surface
- richer social example route

## Current Proof

- `Package.resolved` exists as the tracked dependency lockfile
- `swift package dump-package` passes
- local `swift test` passes
- `xcodebuild -scheme SocialMediaApp -destination 'generic/platform=iOS' build` passes
- `bash Scripts/validate-runtime-app-launches.sh SocialMediaApp` passes locally
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
open ../../Examples/SocialMediaExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

Standalone generic iOS proof:

```bash
xcodebuild -scheme SocialMediaApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/SocialMediaApp.md)
- [Media Surface](../../Documentation/App-Media/SocialMediaApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
- [Richer Example](../../Examples/SocialMediaExample/README.md)
