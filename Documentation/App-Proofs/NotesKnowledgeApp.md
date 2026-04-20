# NotesKnowledgeApp Proof Surface

Last updated: 2026-04-20

## Product Summary

- Lane: `Notes / Knowledge`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/NotesKnowledgeApp/Package.swift`
- Extra route: `Examples/NotesKnowledgeExample`
- Product target: `Notes / Knowledge Base`

## Best For / Not For

### Best for

- note capture, collection routing ve knowledge workflow incelemek isteyen ekipler
- standalone root ile richer example surface'i birlikte gormek isteyenler
- Wave 2 icin gercek notes/knowledge packaging kaniti isteyenler

### Not for

- bugun complete PKM parity bekleyenler
- screenshot/demo proof'un zaten mevcut oldugunu varsayanlar
- teams that assume hosted standalone iOS proof is already green for this app pack

## Product Shape Today

- note and knowledge dashboard shell
- collections and shared-space routing
- offline-first knowledge quick actions
- richer knowledge example route

## Current Proof

- standalone root package mevcut
- template-root README mevcut
- `Templates/NotesKnowledgeApp/Package.swift` dependency-free app shell graph'i veriyor; no external dependency lockfile is required
- `swift package dump-package` gecerli
- `cd Templates/NotesKnowledgeApp && swift test` gecerli
- `xcodebuild -scheme NotesKnowledgeApp -destination 'generic/platform=iOS' build` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- `Examples/NotesKnowledgeExample` inspection route mevcut

## Missing Proof

- canonical screenshot yok
- demo clip yok
- hosted standalone iOS proof workflow is active; check live GitHub status on master

## Start Path

```bash
open Templates/NotesKnowledgeApp/Package.swift
open Examples/NotesKnowledgeExample/README.md
```

Root repo proof icin:

```bash
swift build
swift test
```

Standalone generic iOS proof icin:

```bash
cd Templates/NotesKnowledgeApp
xcodebuild -scheme NotesKnowledgeApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Template Root README](../../Templates/NotesKnowledgeApp/README.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Portfolio-Matrix.md](../Portfolio-Matrix.md)
