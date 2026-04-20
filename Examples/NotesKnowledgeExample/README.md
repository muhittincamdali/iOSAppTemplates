# NotesKnowledgeExample

Generated from `Documentation/app-surface-catalog.json`.

`NotesKnowledgeExample` is the richer example surface for the `Notes / Knowledge` lane.

## Product Shape

- notes list shell
- note detail surface
- tag or workspace routing
- search starter flow

## Best For / Not For

### Best for

- teams that want a second inspection route beyond `NotesKnowledgeApp`
- readers who want to inspect the `Notes / Knowledge Base` flow in a more product-like format

### Not for

- teams expecting a separate runnable Xcode project
- readers who expect published runtime screenshots or simulator media proof today

## Current Truth

- this example is an inspection surface, not a separate shipped app project
- the canonical standalone package-entry path lives under `Templates/`
- canonical package validation remains the root-level `swift build` and `swift test` flow

## Start Here

```bash
open ../../Templates/NotesKnowledgeApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Canonical References

- [NotesKnowledgeApp Proof](../../Documentation/App-Proofs/NotesKnowledgeApp.md)
- [NotesKnowledgeApp Media](../../Documentation/App-Media/NotesKnowledgeApp.md)
- [Wave 1 Plan](../../Documentation/Wave-1-Implementation-Plan.md)
