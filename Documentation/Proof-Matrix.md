# Proof Matrix

Last updated: 2026-04-18

Bu sayfa current public claim ile current proof arasindaki farki lane bazinda gosterir.

Status anlamlari:

- `Strong`: route + build path + packaging + app-specific proof var
- `Medium`: route + packaging var, ama app-specific build veya media proof eksik
- `Low`: source-level gorunurluk var, product proof zayif

| Lane | Current Packaging | Current Proof | Strength | Next Missing Piece |
| --- | --- | --- | --- | --- |
| Commerce | standalone root + template family | root package green, standalone manifest smoke green, `Templates/EcommerceApp/Package.resolved` mevcut, source shell mevcut, per-app proof surface mevcut, template-root README mevcut | Medium | iOS-targeted standalone build + media |
| Social | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/SocialMediaApp/Package.resolved` mevcut, richer source/example surface mevcut, per-app proof surface mevcut, template-root README mevcut | Medium | iOS-targeted standalone build + media |
| Health / Fitness | standalone root + template family | root package green, standalone manifest smoke green, `Templates/FitnessApp/Package.resolved` mevcut, source shell mevcut, per-app proof surface mevcut, template-root README mevcut | Medium | iOS-targeted standalone build + media |
| Finance | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/FinanceApp/Package.resolved` mevcut, local standalone `swift test` gecerli, richer source/example surface mevcut, per-app proof surface mevcut, template-root README mevcut | Medium | iOS-targeted standalone build + media |
| Education | template family + generator lane | root package green, generator lane listede | Low | standalone root veya per-app proof |
| Food Delivery | template family + generator lane | root package green, generator lane listede | Low | standalone root veya per-app proof |
| Travel | template family + generator lane | root package green, generator lane listede | Low | standalone root veya per-app proof |
| Productivity | standalone root + template family + example | root package green, standalone manifest smoke green, `Templates/ProductivityApp/Package.resolved` mevcut, local standalone `swift test` gecerli, richer source/example surface mevcut, per-app proof surface mevcut, template-root README mevcut | Medium | iOS-targeted standalone build + media |
| News | template family + generator lane | root package green, generator lane listede | Low | standalone root veya per-app proof |
| Music / Podcast | template family + generator lane | root package green, generator lane listede | Low | standalone root veya per-app proof |

## Current Global Proof

- root `swift build -c release` gecerli
- root `swift test` gecerli
- generator `--list` gecerli
- generator sample app `build + test` gecerli
- standalone roots icin manifest smoke gecerli
- 5 standalone root icin deterministic `Package.resolved` mevcut
- standalone roots icin canonical per-app proof sayfalari mevcut
- 5 standalone root icin canonical media router mevcut, ama status bugun `not-published`
- `ProductivityApp` ve `FinanceApp` icin local standalone `swift test` gecerli
- GitHub workflows su an truth-based ve yesil

## App Proof Router

- [App-Proofs/README.md](./App-Proofs/README.md)
- [App-Proofs/EcommerceApp.md](./App-Proofs/EcommerceApp.md)
- [App-Proofs/SocialMediaApp.md](./App-Proofs/SocialMediaApp.md)
- [App-Proofs/FitnessApp.md](./App-Proofs/FitnessApp.md)
- [App-Proofs/ProductivityApp.md](./App-Proofs/ProductivityApp.md)
- [App-Proofs/FinanceApp.md](./App-Proofs/FinanceApp.md)

## What Is Still Missing

`20 complete apps` claim'i icin eksik ana katmanlar:

1. lane-specific per-app README
2. real screenshot gallery
3. explicit iOS-targeted per-app smoke/build proof
4. current 5 root disindaki lane'ler icin standalone packaging

Wave 1 icin zorunlu app-pack kontrati:

- [Wave-1-Implementation-Plan.md](./Wave-1-Implementation-Plan.md)
- [Wave-1-App-Pack-Spec.md](./Wave-1-App-Pack-Spec.md)

## Rule

Bir lane source olarak var diye `complete app` sayilmaz.

`Complete app` saymak icin canonical standard:
- [Complete-App-Standard.md](./Complete-App-Standard.md)
