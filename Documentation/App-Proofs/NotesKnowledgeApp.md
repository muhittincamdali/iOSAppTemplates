# NotesKnowledgeApp Proof Surface

Generated from `Documentation/app-surface-catalog.json`.

## Product Summary

- Lane: `Notes / Knowledge`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/NotesKnowledgeApp/Package.swift`
- Extra route: `Examples/NotesKnowledgeExample`
- Product target: `Notes / Knowledge Base`

## Best For / Not For

### Best for

- teams evaluating note and knowledge starter flows
- readers comparing productivity and PKM-oriented surfaces
- maintainers reviewing list and detail note patterns

### Not for

- teams expecting a full PKM platform today
- readers who assume runtime screenshots and demo clips are already published
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape Today

- notes list shell
- note detail surface
- tag or workspace routing
- search starter flow
- knowledge starter model

## Current Proof

- standalone root package exists
- template-root README exists
- `Templates/NotesKnowledgeApp/Package.swift` exists
- local generic iOS build proof is tracked via `xcodebuild -scheme NotesKnowledgeApp -destination 'generic/platform=iOS' build`
- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`
- root repo `swift build -c release` passes
- root repo `swift test` passes
- `Examples/NotesKnowledgeExample` inspection route exists

## Missing Proof

- runtime screenshot not yet published
- demo clip not yet published
- stable green hosted standalone iOS baseline should be checked on current `master`

## Start Path

```bash
open Templates/NotesKnowledgeApp/Package.swift
open Examples/NotesKnowledgeExample/README.md
xcodebuild -scheme NotesKnowledgeApp -destination 'generic/platform=iOS' build
```

Then validate the root package:

```bash
swift build -c release
swift test
```

## Canonical References

- [Template Root README](../../Templates/NotesKnowledgeApp/README.md)
- [Richer Example](../../Examples/NotesKnowledgeExample/README.md)
- [App Media Surface](../App-Media/NotesKnowledgeApp.md)
- [Template Showcase](../Template-Showcase.md)
- [Proof Matrix](../Proof-Matrix.md)
- [Portfolio Matrix](../Portfolio-Matrix.md)
