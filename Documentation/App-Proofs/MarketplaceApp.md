# MarketplaceApp Proof Surface

Generated from `Documentation/app-surface-catalog.json`.

## Product Summary

- Lane: `Marketplace`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/MarketplaceApp/Package.swift`
- Extra route: `Examples/MarketplaceExample`
- Product target: `Marketplace`

## Best For / Not For

### Best for

- teams comparing commerce and multi-seller starter flows
- readers who want a marketplace-specific root and example route
- maintainers reviewing listing and seller-oriented starter surfaces

### Not for

- teams expecting production seller operations today
- readers who assume runtime screenshots and clips are already published
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape Today

- listing discovery shell
- seller highlight cards
- product detail starter flow
- saved or cart-adjacent surface
- starter marketplace domain model

## Current Proof

- standalone root package exists
- template-root README exists
- `Templates/MarketplaceApp/Package.swift` exists
- no external dependency lockfile is required today
- local generic iOS build proof is tracked via `xcodebuild -scheme MarketplaceApp -destination 'generic/platform=iOS' build`
- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`
- root repo `swift build -c release` passes
- root repo `swift test` passes
- `Examples/MarketplaceExample` inspection route exists

## Missing Proof

- runtime screenshot not yet published
- demo clip not yet published
- stable green hosted standalone iOS baseline should be checked on current `master`

## Start Path

```bash
open Templates/MarketplaceApp/Package.swift
open Examples/MarketplaceExample/README.md
xcodebuild -scheme MarketplaceApp -destination 'generic/platform=iOS' build
```

Then validate the root package:

```bash
swift build -c release
swift test
```

## Canonical References

- [Template Root README](../../Templates/MarketplaceApp/README.md)
- [Richer Example](../../Examples/MarketplaceExample/README.md)
- [App Media Surface](../App-Media/MarketplaceApp.md)
- [Template Showcase](../Template-Showcase.md)
- [Proof Matrix](../Proof-Matrix.md)
- [Portfolio Matrix](../Portfolio-Matrix.md)
