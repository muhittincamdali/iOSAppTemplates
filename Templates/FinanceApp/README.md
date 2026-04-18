# FinanceApp

Last updated: 2026-04-19

`FinanceApp`, `iOSAppTemplates` icindeki Finance lane standalone root surface'idir.

## Today

- Label: `Standalone Root`
- Lane: `Finance`
- Entry: `Package.swift`
- Product target: `Finance / Budgeting`

## Best For / Not For

### Best for

- dashboard, account, budget shell incelemek isteyen ekipler
- finance lane icin package-entry seviyesinde app surface gormek isteyenler
- Wave 1 backlog icin gercek root/package kaniti isteyenler

### Not for

- bugun tam release-grade finance suite parity bekleyenler
- screenshot veya demo proof arayanlar
- explicit standalone iOS CI proof'un verildigini varsayanlar

## Product Shape

- finance dashboard shell
- account snapshot surface
- budget review entry
- cash-flow quick actions

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

- [Proof Surface](../../Documentation/App-Proofs/FinanceApp.md)
- [Media Surface](../../Documentation/App-Media/FinanceApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
