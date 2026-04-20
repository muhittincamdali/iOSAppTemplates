# TeamCollaborationApp Proof Surface

Last updated: 2026-04-20

## Product Summary

- Lane: `Team Collaboration`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/TeamCollaborationApp/Package.swift`
- Extra route: `Examples/TeamCollaborationExample`
- Product target: `Team Collaboration`

## Best For / Not For

### Best for

- workspace, project routing ve async collaboration workflow incelemek isteyen ekipler
- standalone root ile richer example surface'i birlikte gormek isteyenler
- Wave 3 icin gercek collaboration packaging kaniti isteyenler

### Not for

- bugun complete enterprise collaboration parity bekleyenler
- screenshot/demo proof'un zaten mevcut oldugunu varsayanlar
- teams that assume hosted standalone iOS proof is already green for this app pack

## Product Shape Today

- collaboration dashboard shell
- project and workspace routing
- decision and handoff workflow
- richer team collaboration example route

## Current Proof

- standalone root package mevcut
- template-root README mevcut
- `Templates/TeamCollaborationApp/Package.swift` dependency-free app shell graph'i veriyor; no external dependency lockfile is required
- `swift package dump-package` gecerli
- `cd Templates/TeamCollaborationApp && swift test` gecerli
- `xcodebuild -scheme TeamCollaborationApp -destination 'generic/platform=iOS' build` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- `Examples/TeamCollaborationExample` inspection route mevcut

## Missing Proof

- canonical screenshot yok
- demo clip yok
- hosted standalone iOS proof workflow is active; check live GitHub status on master

## Start Path

```bash
open Templates/TeamCollaborationApp/Package.swift
open Examples/TeamCollaborationExample/README.md
```

Root repo proof icin:

```bash
swift build
swift test
```

Standalone generic iOS proof icin:

```bash
cd Templates/TeamCollaborationApp
xcodebuild -scheme TeamCollaborationApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Template Root README](../../Templates/TeamCollaborationApp/README.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Portfolio-Matrix.md](../Portfolio-Matrix.md)
