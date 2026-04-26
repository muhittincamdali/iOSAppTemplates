# EcommerceApp

Generated from `Documentation/app-surface-catalog.json`.

`EcommerceApp` is the standalone-root surface for the `Commerce` lane inside `iOSAppTemplates`.

## Today

- Label: `Standalone Root + richer example surface`
- Lane: `Commerce`
- Entry: `Package.swift`
- Product target: `E-Commerce Store`
- Richer example: `Examples/EcommerceExample`

## Best For / Not For

### Best for

- teams evaluating a catalog and checkout starter shell
- commerce lanes that need a SwiftUI package entry first
- maintainers comparing standalone root packaging against the richer example

### Not for

- teams that expect release-grade commerce integrations today
- readers who expect deeper runtime scenario coverage than the current screenshot and demo proof
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape

- auth shell
- catalog and featured-product surface
- cart flow
- checkout shell
- order domain surface

## Current Proof

- No external dependency lockfile is required today
- `swift package dump-package` passes
- local `swift test` passes
- `xcodebuild -scheme EcommerceApp -destination 'generic/platform=iOS' build` passes
- `bash Scripts/validate-runtime-app-launches.sh EcommerceApp` passes locally
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
open ../../Examples/EcommerceExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

Standalone generic iOS proof:

```bash
xcodebuild -scheme EcommerceApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/EcommerceApp.md)
- [Media Surface](../../Documentation/App-Media/EcommerceApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
- [Richer Example](../../Examples/EcommerceExample/README.md)
