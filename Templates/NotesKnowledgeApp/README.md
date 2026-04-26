# NotesKnowledgeApp

Generated from `Documentation/app-surface-catalog.json`.

`NotesKnowledgeApp` is the standalone-root surface for the `Notes / Knowledge` lane inside `iOSAppTemplates`.

## Today

- Label: `Standalone Root + richer example surface`
- Lane: `Notes / Knowledge`
- Entry: `Package.swift`
- Product target: `Notes / Knowledge Base`
- Richer example: `Examples/NotesKnowledgeExample`

## Best For / Not For

### Best for

- teams evaluating note and knowledge starter flows
- readers comparing productivity and PKM-oriented surfaces
- maintainers reviewing list and detail note patterns

### Not for

- teams expecting a full PKM platform today
- readers who expect deeper runtime scenario coverage than the current screenshot and demo proof
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape

- notes list shell
- note detail surface
- tag or workspace routing
- search starter flow
- knowledge starter model

## Current Proof

- No external dependency lockfile is required today
- `swift package dump-package` passes
- local `swift test` passes
- `xcodebuild -scheme NotesKnowledgeApp -destination 'generic/platform=iOS' build` passes
- `bash Scripts/validate-runtime-app-launches.sh NotesKnowledgeApp` passes locally
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
open ../../Examples/NotesKnowledgeExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

Standalone generic iOS proof:

```bash
xcodebuild -scheme NotesKnowledgeApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/NotesKnowledgeApp.md)
- [Media Surface](../../Documentation/App-Media/NotesKnowledgeApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
- [Richer Example](../../Examples/NotesKnowledgeExample/README.md)
