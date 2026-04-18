# SocialMediaApp

Last updated: 2026-04-18

`SocialMediaApp`, `iOSAppTemplates` icindeki Social lane standalone root surface'idir.

## Today

- Label: `Standalone Root + richer example surface`
- Lane: `Social`
- Entry: `Package.swift`
- Extra route: `../../Examples/SocialMediaExample`
- Product target: `Social Media`

## Best For / Not For

### Best for

- social feed/community shell incelemek isteyen ekipler
- standalone root ile richer example surface'i birlikte gormek isteyenler
- auth, feed ve interaction source surface'ini ayni lane icinde okumak isteyenler

### Not for

- bugun full complete-app parity bekleyenler
- screenshot veya demo proof'un mevcut oldugunu varsayanlar
- explicit standalone iOS CI proof'u arayanlar

## Product Shape

- auth shell
- feed/community shell
- profile/user surface
- notification/data manager surface
- richer social example route

## Current Proof

- `swift package dump-package` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- canonical app proof page mevcut
- richer example route mevcut

## Missing Proof

- screenshot
- demo clip
- explicit standalone iOS-targeted CI proof

## Start Here

```bash
open Package.swift
open ../../Examples/SocialMediaExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/SocialMediaApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
