# NewsBlogApp Proof Surface

Last updated: 2026-04-20

## Product Summary

- Lane: `News`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/NewsBlogApp/Package.swift`
- Extra route: `Examples/NewsBlogExample`
- Product target: `News / Editorial`

## Best For / Not For

### Best for

- editorial dashboard, section routing ve quick action shell incelemek isteyen ekipler
- standalone root ile richer example surface'i birlikte gormek isteyenler
- Wave 2 icin gercek news/editorial packaging kaniti isteyenler

### Not for

- bugun complete newsroom parity bekleyenler
- screenshot/demo proof'un zaten mevcut oldugunu varsayanlar
- teams that assume hosted standalone iOS proof is already green for this app pack

## Product Shape Today

- editorial briefing shell
- section/category routing
- reader mode entry
- newsletter and moderation quick actions
- richer news/editorial example route

## Current Proof

- standalone root package mevcut
- template-root README mevcut
- `Templates/NewsBlogApp/Package.swift` dependency-free app shell graph'i veriyor; no external dependency lockfile is required
- `swift package dump-package` gecerli
- `cd Templates/NewsBlogApp && swift test` gecerli
- `xcodebuild -scheme NewsBlogApp -destination 'generic/platform=iOS' build` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- `Examples/NewsBlogExample` inspection route mevcut

## Missing Proof

- canonical screenshot yok
- demo clip yok
- hosted standalone iOS proof workflow is active; check live GitHub status on master

## Start Path

```bash
open Templates/NewsBlogApp/Package.swift
open Examples/NewsBlogExample/README.md
```

Root repo proof icin:

```bash
swift build
swift test
```

Standalone generic iOS proof icin:

```bash
cd Templates/NewsBlogApp
xcodebuild -scheme NewsBlogApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Template Root README](../../Templates/NewsBlogApp/README.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Portfolio-Matrix.md](../Portfolio-Matrix.md)
