# NewsBlogApp Proof Surface

Last updated: 2026-04-21

## Product Summary

- Lane: `News`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/NewsBlogApp/Package.swift`
- Extra route: `Examples/NewsBlogExample`
- Product target: `News / Editorial`

## Best For / Not For

### Best for

- teams evaluating editorial and article-list starter shells
- readers comparing news lane packaging and richer example routing
- maintainers reviewing content-first list and detail patterns

### Not for

- teams expecting a production newsroom platform today
- readers who assume runtime screenshots and clips are already published
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape Today

- headline list shell
- article detail surface
- category routing
- saved or trending content shell
- starter editorial model

## Current Proof

- standalone root package exists
- template-root README exists
- `Templates/NewsBlogApp/Package.swift` exists
- local generic iOS build proof is tracked via `xcodebuild -scheme NewsBlogApp -destination 'generic/platform=iOS' build`
- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`
- root repo `swift build -c release` passes
- root repo `swift test` passes
- `Examples/NewsBlogExample` inspection route exists

## Missing Proof

- runtime screenshot not yet published
- demo clip not yet published
- stable green hosted standalone iOS baseline should be checked on current `master`

## Start Path

```bash
open Templates/NewsBlogApp/Package.swift
open Examples/NewsBlogExample/README.md
xcodebuild -scheme NewsBlogApp -destination 'generic/platform=iOS' build
```

Then validate the root package:

```bash
swift build -c release
swift test
```

## Canonical References

- [Template Root README](../../Templates/NewsBlogApp/README.md)
- [Richer Example](../../Examples/NewsBlogExample/README.md)
- [App Media Surface](../App-Media/NewsBlogApp.md)
- [Template Showcase](../Template-Showcase.md)
- [Proof Matrix](../Proof-Matrix.md)
- [Portfolio Matrix](../Portfolio-Matrix.md)
