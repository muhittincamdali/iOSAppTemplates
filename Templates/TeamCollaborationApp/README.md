# TeamCollaborationApp

Last updated: 2026-04-20

`TeamCollaborationApp`, `iOSAppTemplates` icindeki Team Collaboration lane standalone root surface'idir.

## Today

- Label: `Standalone Root`
- Lane: `Team Collaboration`
- Entry: `Package.swift`
- Extra route: `../../Examples/TeamCollaborationExample`
- Product target: `Team Collaboration`

## Best For / Not For

### Best for

- team workspace, project routing ve async collaboration workflow incelemek isteyen ekipler
- collaboration lane icin package-entry seviyesinde app surface gormek isteyenler
- Wave 3 differentiation icin gercek root/package kaniti isteyenler

### Not for

- bugun tam enterprise collaboration suite parity bekleyenler
- screenshot veya demo proof arayanlar
- hosted standalone iOS CI proof'un verildigini varsayanlar

## Product Shape

- collaboration dashboard
- project and workspace routing
- decision and handoff shell
- async standup quick actions

## Current Proof

- No external dependency lockfile is required today
- `swift package dump-package` gecerli
- `cd Templates/TeamCollaborationApp && swift test` gecerli
- `xcodebuild -scheme TeamCollaborationApp -destination 'generic/platform=iOS' build` gecerli
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
xcodebuild -scheme TeamCollaborationApp -destination 'generic/platform=iOS' build
open ../../Examples/TeamCollaborationExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/TeamCollaborationApp.md)
- [Media Surface](../../Documentation/App-Media/TeamCollaborationApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
