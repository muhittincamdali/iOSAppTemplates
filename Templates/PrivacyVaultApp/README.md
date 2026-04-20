# PrivacyVaultApp

Last updated: 2026-04-20

`PrivacyVaultApp`, `iOSAppTemplates` icindeki Privacy / Secure Vault lane standalone root surface'idir.

## Today

- Label: `Standalone Root`
- Lane: `Privacy / Secure Vault`
- Entry: `Package.swift`
- Extra route: `../../Examples/PrivacyVaultExample`
- Product target: `Privacy / Secure Vault`

## Best For / Not For

### Best for

- privacy-first vault shell'i incelemek isteyen ekipler
- secure collections, access review ve recovery workflow icin package-entry seviyesinde app surface gormek isteyenler
- Wave 3 premium differentiation lane'i icin gercek root/package kaniti isteyenler

### Not for

- bugun full encryption/storage backend parity bekleyenler
- screenshot veya demo proof arayanlar
- hosted standalone iOS CI proof'un verildigini varsayanlar

## Product Shape

- vault dashboard shell
- secure collection routing
- access alert and recovery workflow
- privacy quick actions

## Current Proof

- No external dependency lockfile is required today
- `swift package dump-package` gecerli
- `cd Templates/PrivacyVaultApp && swift test` gecerli
- `xcodebuild -scheme PrivacyVaultApp -destination 'generic/platform=iOS' build` gecerli
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
xcodebuild -scheme PrivacyVaultApp -destination 'generic/platform=iOS' build
open ../../Examples/PrivacyVaultExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/PrivacyVaultApp.md)
- [Media Surface](../../Documentation/App-Media/PrivacyVaultApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
