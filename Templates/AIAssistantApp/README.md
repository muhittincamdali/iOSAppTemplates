# AIAssistantApp

Last updated: 2026-04-20

`AIAssistantApp`, `iOSAppTemplates` icindeki AI lane standalone root surface'idir.

## Today

- Label: `Standalone Root + richer example surface`
- Lane: `AI`
- Entry: `Package.swift`
- Product target: `AI Assistant`

## Best For / Not For

### Best for

- on-device assistant workspace shell incelemek isteyen ekipler
- AI lane icin package-entry seviyesinde app surface gormek isteyenler
- Wave 1 icin gercek AI packaging kaniti isteyenler

### Not for

- bugun tam release-grade AI suite parity bekleyenler
- screenshot veya demo proof arayanlar
- explicit standalone iOS CI proof'un verildigini varsayanlar

## Product Shape

- assistant workspace dashboard
- suggestion queue
- trust and guardrail signal surface
- note-to-action workflow shell

## Current Proof

- `Package.resolved` lockfile mevcut
- `swift package dump-package` gecerli
- local `swift test` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- canonical app proof page mevcut

## Missing Proof

- screenshot
- demo clip
- explicit standalone iOS-targeted CI proof

## Start Here

```bash
open Package.swift
open Package.resolved
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/AIAssistantApp.md)
- [Media Surface](../../Documentation/App-Media/AIAssistantApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
