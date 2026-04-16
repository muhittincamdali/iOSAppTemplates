# Testing Guide

Bu sayfa `iOSAppTemplates` repo gercegine gore aktif test yuzeyini anlatir. Uydurma coverage yuzdeleri, zorunlu UI suite'leri veya ship edilmeyen test infrastructure'larini varsaymaz.

## Current Test Surface

Bugun dogrudan dogrulanan komutlar:

```bash
swift build
swift test
```

Ek aktif suite'ler:

- package smoke/unit testleri
- `PerformanceBenchmarkTests`
- `SecuritySurfaceTests`

Bu suite'ler repo icindeki aktif package graph'a baglidir.

## What The Current Tests Prove

- aktif Swift package target'lari compile oluyor
- temel model/manager contract'lari stabil
- arama ve template discovery yuzeyi regress olmuyor
- security template yuzeyinde temel smoke davranislari calisiyor
- benchmark suite en azindan package seviyesinde kosabiliyor

## What They Do Not Prove Yet

- tum template aileleri icin complete-app parity
- UI automation parity
- distribution readiness
- release-grade performance certification
- gercek device matrix coverage

## Recommended Local Flow

```bash
open Package.swift
swift build
swift test
```

Belirli suite calistirmak icin:

```bash
swift test --filter PerformanceBenchmarkTests
swift test --filter SecuritySurfaceTests
```

## When To Add Tests

Su degisikliklerde test beklenir:

- package-level behavior degisiyorsa
- arama, selection veya template discovery degisiyorsa
- security template surface degisiyorsa
- benchmark veya validation workflow degisiyorsa

Su degisikliklerde test opsiyoneldir:

- sadece docs/router guncellemesi
- sadece copy cleanup
- inactive example narrative duzeltmeleri

## Test Quality Bar

- kritik contract degisiyorsa regression test ekle
- fake coverage cümlesi ekleme
- UI testi yoksa varmis gibi yazma
- test README ve workflow dili gercek suite adlariyla uyumlu olsun

## CI Alignment

Canonical CI komutlari da package surface'e dayanir:

```bash
swift build
swift test
```

Security ve performance workflow'lari da bu gercek package graph ustunde calisir.

## Related Docs

- [QuickStart](QuickStart.md)
- [Installation](Installation.md)
- [Complete App Standard](../Complete-App-Standard.md)
