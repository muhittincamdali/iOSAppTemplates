# Proof Matrix

Last updated: 2026-04-18

Bu sayfa current public claim ile current proof arasindaki farki lane bazinda gosterir.

Status anlamlari:

- `Strong`: route + build path + packaging sinyali var
- `Medium`: route var, ama packaging veya proof eksik
- `Low`: source-level gorunurluk var, product proof zayif

| Lane | Current Packaging | Current Proof | Strength | Next Missing Piece |
| --- | --- | --- | --- | --- |
| Commerce | standalone root + template family | root package green, standalone shell mevcut | Strong | per-app README + media |
| Social | standalone root + template family + example | root package green, richer source/example surface mevcut | Strong | per-app README + media |
| Health / Fitness | standalone root + template family | root package green, standalone shell mevcut | Strong | per-app README + media |
| Finance | template family + generator lane | root package green, generator smoke green | Medium | standalone root veya per-app proof |
| Education | template family + generator lane | root package green, generator lane listede | Medium | standalone root veya per-app proof |
| Food Delivery | template family + generator lane | root package green, generator lane listede | Medium | standalone root veya per-app proof |
| Travel | template family + generator lane | root package green, generator lane listede | Medium | standalone root veya per-app proof |
| Productivity | template family + generator lane | root package green, generator lane listede | Medium | standalone root veya per-app proof |
| News | template family + generator lane | root package green, generator lane listede | Medium | standalone root veya per-app proof |
| Music / Podcast | template family + generator lane | root package green, generator lane listede | Medium | standalone root veya per-app proof |

## Current Global Proof

- root `swift build -c release` gecerli
- root `swift test` gecerli
- generator `--list` gecerli
- generator sample app `build + test` gecerli
- GitHub workflows su an truth-based ve yesil

## What Is Still Missing

`20 complete apps` claim'i icin eksik ana katmanlar:

1. lane-specific per-app README
2. real screenshot gallery
3. explicit per-app smoke/build proof
4. current 3 root disindaki lane'ler icin standalone packaging

## Rule

Bir lane source olarak var diye `complete app` sayilmaz.

`Complete app` saymak icin canonical standard:
- [Complete-App-Standard.md](./Complete-App-Standard.md)
