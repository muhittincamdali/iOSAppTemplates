# AIAssistantApp Proof Surface

Last updated: 2026-04-20

## Product Summary

- Lane: `AI`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/AIAssistantApp/Package.swift`
- Extra route: `Examples/AIAssistantExample`
- Product target: `AI Assistant`

## Best For / Not For

### Best for

- on-device assistant workspace shell incelemek isteyen ekipler
- standalone root ile richer example surface'i birlikte gormek isteyenler
- Wave 1 icin gercek AI packaging kaniti isteyenler

### Not for

- bugun complete AI parity bekleyenler
- screenshot/demo proof'un zaten mevcut oldugunu varsayanlar
- teams that assume hosted standalone iOS proof is already green for this app pack

## Product Shape Today

- assistant workspace dashboard
- suggestion queue
- trust and guardrail signals
- note-to-action workflow shell
- richer AI example route

## Current Proof

- standalone root package mevcut
- template-root README mevcut
- `Templates/AIAssistantApp/Package.resolved` lockfile mevcut
- `swift package dump-package` gecerli
- `cd Templates/AIAssistantApp && swift test` gecerli
- `xcodebuild -scheme AIAssistantApp -destination 'generic/platform=iOS' build` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- `Examples/AIAssistantExample` inspection route mevcut

## Missing Proof

- canonical screenshot yok
- demo clip yok
- hosted standalone iOS proof workflow is active; check live GitHub status on master

## Start Path

```bash
open Templates/AIAssistantApp/Package.swift
open Templates/AIAssistantApp/Package.resolved
open Examples/AIAssistantExample/README.md
```

Root repo proof icin:

```bash
swift build
swift test
```

Standalone generic iOS proof icin:

```bash
cd Templates/AIAssistantApp
xcodebuild -scheme AIAssistantApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Template Root README](../../Templates/AIAssistantApp/README.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Portfolio-Matrix.md](../Portfolio-Matrix.md)
