# SocialMediaApp Proof Surface

Last updated: 2026-04-18

## Product Summary

- Lane: `Social`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/SocialMediaApp/Package.swift`
- Extra route: `Examples/SocialMediaExample`
- Product target: `Social Media`

## Best For / Not For

### Best for

- social feed/community shell incelemek isteyen ekipler
- standalone root ile richer example surface'i birlikte gormek isteyenler
- auth, feed, interaction akisini source seviyesinde incelemek isteyenler

### Not for

- bugun complete social app parity bekleyenler
- screenshot/demo proof'un zaten mevcut oldugunu varsayanlar
- hosted standalone iOS build proof'unun verildigini dusunenler

## Product Shape Today

- auth shell
- profile/user model surface
- feed/community shell
- notification/data manager surface
- richer social example route

## Current Proof

- standalone root package mevcut
- `swift package dump-package` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- `Examples/SocialMediaExample` inspection route mevcut

## Missing Proof

- app-specific README `Templates/SocialMediaApp` altinda yok
- canonical screenshot yok
- demo clip yok
- explicit standalone iOS-targeted CI proof yok

## Start Path

```bash
open Templates/SocialMediaApp/Package.swift
open Examples/SocialMediaExample/README.md
```

Root repo proof icin:

```bash
swift build
swift test
```

## Canonical References

- [../Template-Showcase.md](../Template-Showcase.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Portfolio-Matrix.md](../Portfolio-Matrix.md)
