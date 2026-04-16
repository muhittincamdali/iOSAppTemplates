# Contributing

Bu repo buyuk iddia tasiyan bir template koleksiyonu oldugu icin, katkilarin da truth-based olmasi gerekiyor.

## Before You Open A PR

1. Reponun mevcut truth surface'ini oku:
   - `README.md`
   - `Documentation/README.md`
   - `Documentation/Complete-App-Standard.md`
2. Degisikligin hangi alana ait oldugunu netlestir:
   - package target
   - template family
   - standalone template root
   - docs / workflow / validation
3. Public claim ekliyorsan onu kanitlayan path'i de ekle.

## Local Setup

```bash
git clone https://github.com/muhittincamdali/iOSAppTemplates.git
cd iOSAppTemplates
open Package.swift
swift build
swift test
```

## Contribution Rules

- Placeholder, fake metric, fake coverage, fake App Store, fake benchmark dili ekleme.
- Public docs ile package truth'u birbiriyle celismesin.
- Yeni template veya example ekliyorsan:
  - acik entry path
  - gercek README
  - build/test etkisi
  - gerekiyorsa media/proof planini da ekle
- Buyuk degisikliklerde once canonical doc/router yuzeylerini guncelle.

## Commit Style

- `feat:`
- `fix:`
- `docs:`
- `refactor:`
- `test:`
- `chore:`

## Pull Request Checklist

- [ ] `swift build` gecti
- [ ] `swift test` gecti
- [ ] yeni public claim truth-based
- [ ] ilgili docs guncellendi
- [ ] broken link veya placeholder birakilmadi

## Conduct

Kisa, net, teknik ve saygili iletisim beklenir.
