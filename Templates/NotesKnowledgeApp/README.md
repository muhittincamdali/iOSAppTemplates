# NotesKnowledgeApp

Last updated: 2026-04-20

`NotesKnowledgeApp`, `iOSAppTemplates` icindeki Notes / Knowledge lane standalone root surface'idir.

## Today

- Label: `Standalone Root`
- Lane: `Notes / Knowledge`
- Entry: `Package.swift`
- Extra route: `../../Examples/NotesKnowledgeExample`
- Product target: `Notes / Knowledge Base`

## Best For / Not For

### Best for

- note capture, knowledge routing ve shared-space workflow incelemek isteyen ekipler
- notes lane icin package-entry seviyesinde app surface gormek isteyenler
- Wave 2 expansion icin gercek root/package kaniti isteyenler

### Not for

- bugun tam PKM suite parity bekleyenler
- screenshot veya demo proof arayanlar
- hosted standalone iOS CI proof'un verildigini varsayanlar

## Product Shape

- note and knowledge dashboard
- collection and space routing
- offline-first knowledge shell
- review and capture quick actions

## Current Proof

- No external dependency lockfile is required today
- `swift package dump-package` gecerli
- `cd Templates/NotesKnowledgeApp && swift test` gecerli
- `xcodebuild -scheme NotesKnowledgeApp -destination 'generic/platform=iOS' build` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- canonical app proof page mevcut
- richer example route mevcut

## Missing Proof

- screenshot
- demo clip
- hosted standalone iOS CI proof

## Start Here

```bash
open Package.swift
xcodebuild -scheme NotesKnowledgeApp -destination 'generic/platform=iOS' build
open ../../Examples/NotesKnowledgeExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/NotesKnowledgeApp.md)
- [Media Surface](../../Documentation/App-Media/NotesKnowledgeApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
