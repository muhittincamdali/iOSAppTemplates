# MarketplaceApp

Generated from `Documentation/app-surface-catalog.json`.

`MarketplaceApp` is the standalone-root surface for the `Marketplace` lane inside `iOSAppTemplates`.

## Today

- Label: `Standalone Root + richer example surface`
- Lane: `Marketplace`
- Entry: `Package.swift`
- Product target: `Marketplace`
- Richer example: `Examples/MarketplaceExample`

## Best For / Not For

### Best for

- teams comparing commerce and multi-seller starter flows
- readers who want a marketplace-specific root and example route
- maintainers reviewing listing and seller-oriented starter surfaces

### Not for

- teams expecting production seller operations today
- readers who expect deeper interactive runtime flows than the current launch-to-ready scenario proof
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape

- listing discovery shell
- seller highlight cards
- product detail starter flow
- saved or cart-adjacent surface
- starter marketplace domain model

## Current Proof

- No external dependency lockfile is required today
- `swift package dump-package` passes
- local `swift test` passes
- `xcodebuild -scheme MarketplaceApp -destination 'generic/platform=iOS' build` passes
- `bash Scripts/validate-runtime-app-launches.sh MarketplaceApp` passes locally
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
open ../../Examples/MarketplaceExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

Standalone generic iOS proof:

```bash
xcodebuild -scheme MarketplaceApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/MarketplaceApp.md)
- [Media Surface](../../Documentation/App-Media/MarketplaceApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
- [Richer Example](../../Examples/MarketplaceExample/README.md)
