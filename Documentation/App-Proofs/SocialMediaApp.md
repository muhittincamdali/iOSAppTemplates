# SocialMediaApp Proof Surface

Last updated: 2026-04-20

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
- teams that assume hosted standalone iOS proof is already green for this app pack

## Product Shape Today

- auth shell
- profile/user model surface
- feed/community shell
- notification/data manager surface
- richer social example route

## Current Proof

- standalone root package mevcut
- template-root README mevcut
- `Templates/SocialMediaApp/Package.resolved` lockfile mevcut
- `swift package dump-package` gecerli
- `xcodebuild -scheme SocialMediaApp -destination 'generic/platform=iOS' build` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- `Examples/SocialMediaExample` inspection route mevcut

## Missing Proof

- canonical screenshot yok
- demo clip yok
- hosted standalone iOS proof workflow is active; check live GitHub status on master

## Start Path

```bash
open Templates/SocialMediaApp/Package.swift
open Templates/SocialMediaApp/Package.resolved
open Examples/SocialMediaExample/README.md
```

Root repo proof icin:

```bash
swift build
swift test
```

Standalone generic iOS proof icin:

```bash
cd Templates/SocialMediaApp
xcodebuild -scheme SocialMediaApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Template Root README](../../Templates/SocialMediaApp/README.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Portfolio-Matrix.md](../Portfolio-Matrix.md)
