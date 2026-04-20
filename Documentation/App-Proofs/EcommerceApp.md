# EcommerceApp Proof Surface

Last updated: 2026-04-21

## Product Summary

- Lane: `Commerce`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/EcommerceApp/Package.swift`
- Extra route: `Examples/EcommerceExample`
- Product target: `E-Commerce Store`

## Best For / Not For

### Best for

- teams evaluating a catalog and checkout starter shell
- commerce lanes that need a SwiftUI package entry first
- maintainers comparing standalone root packaging against the richer example

### Not for

- teams that expect release-grade commerce integrations today
- readers who assume runtime screenshots and demo clips are already published
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape Today

- auth shell
- catalog and featured-product surface
- cart flow
- checkout shell
- order domain surface

## Current Proof

- standalone root package exists
- template-root README exists
- `Templates/EcommerceApp/Package.swift` exists
- local generic iOS build proof is tracked via `xcodebuild -scheme EcommerceApp -destination 'generic/platform=iOS' build`
- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`
- root repo `swift build -c release` passes
- root repo `swift test` passes
- `Examples/EcommerceExample` inspection route exists

## Missing Proof

- runtime screenshot not yet published
- demo clip not yet published
- stable green hosted standalone iOS baseline should be checked on current `master`

## Start Path

```bash
open Templates/EcommerceApp/Package.swift
open Examples/EcommerceExample/README.md
xcodebuild -scheme EcommerceApp -destination 'generic/platform=iOS' build
```

Then validate the root package:

```bash
swift build -c release
swift test
```

## Canonical References

- [Template Root README](../../Templates/EcommerceApp/README.md)
- [Richer Example](../../Examples/EcommerceExample/README.md)
- [App Media Surface](../App-Media/EcommerceApp.md)
- [Template Showcase](../Template-Showcase.md)
- [Proof Matrix](../Proof-Matrix.md)
- [Portfolio Matrix](../Portfolio-Matrix.md)
