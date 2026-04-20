# MessagingApp

Last updated: 2026-04-20

`MessagingApp`, `iOSAppTemplates` icindeki Messaging / Community lane standalone root surface'idir.

## Today

- Label: `Standalone Root`
- Lane: `Messaging / Community`
- Entry: `Package.swift`
- Extra route: `../../Examples/MessagingExample`
- Product target: `Messaging / Community`

## Best For / Not For

### Best for

- realtime chat shell, inbox routing ve community moderation flow incelemek isteyen ekipler
- messaging lane icin package-entry seviyesinde app surface gormek isteyenler
- Wave 2 expansion icin gercek root/package kaniti isteyenler

### Not for

- bugun tam release-grade messaging suite parity bekleyenler
- screenshot veya demo proof arayanlar
- hosted standalone iOS CI proof'un verildigini varsayanlar

## Product Shape

- conversation dashboard
- inbox and room routing
- safety and moderation shell
- community quick actions

## Current Proof

- No external dependency lockfile is required today
- `swift package dump-package` gecerli
- `cd Templates/MessagingApp && swift test` gecerli
- `xcodebuild -scheme MessagingApp -destination 'generic/platform=iOS' build` gecerli
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
xcodebuild -scheme MessagingApp -destination 'generic/platform=iOS' build
open ../../Examples/MessagingExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/MessagingApp.md)
- [Media Surface](../../Documentation/App-Media/MessagingApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
