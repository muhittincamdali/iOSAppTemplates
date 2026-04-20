# MessagingApp Proof Surface

Last updated: 2026-04-20

## Product Summary

- Lane: `Messaging / Community`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/MessagingApp/Package.swift`
- Extra route: `Examples/MessagingExample`
- Product target: `Messaging / Community`

## Best For / Not For

### Best for

- inbox, room routing ve moderation shell incelemek isteyen ekipler
- standalone root ile richer example surface'i birlikte gormek isteyenler
- Wave 2 icin gercek messaging/community packaging kaniti isteyenler

### Not for

- bugun complete messaging parity bekleyenler
- screenshot/demo proof'un zaten mevcut oldugunu varsayanlar
- teams that assume hosted standalone iOS proof is already green for this app pack

## Product Shape Today

- conversation dashboard shell
- inbox and room routing
- safety and moderation quick actions
- richer messaging/community example route

## Current Proof

- standalone root package mevcut
- template-root README mevcut
- `Templates/MessagingApp/Package.swift` dependency-free app shell graph'i veriyor; no external dependency lockfile is required
- `swift package dump-package` gecerli
- `cd Templates/MessagingApp && swift test` gecerli
- `xcodebuild -scheme MessagingApp -destination 'generic/platform=iOS' build` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- `Examples/MessagingExample` inspection route mevcut

## Missing Proof

- canonical screenshot yok
- demo clip yok
- hosted standalone iOS proof workflow is active; check live GitHub status on master

## Start Path

```bash
open Templates/MessagingApp/Package.swift
open Examples/MessagingExample/README.md
```

Root repo proof icin:

```bash
swift build
swift test
```

Standalone generic iOS proof icin:

```bash
cd Templates/MessagingApp
xcodebuild -scheme MessagingApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Template Root README](../../Templates/MessagingApp/README.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Portfolio-Matrix.md](../Portfolio-Matrix.md)
