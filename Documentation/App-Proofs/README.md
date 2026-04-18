# App Proof Surfaces

Last updated: 2026-04-18

Bu klasor `iOSAppTemplates` icindeki standalone app root'lar icin canonical proof router'dir.

Bugunku kapsam:

- `Templates/EcommerceApp`
- `Templates/SocialMediaApp`
- `Templates/FitnessApp`

Bu sayfalarin rolu:

- `best for / not for` karari vermek
- product shape'i netlestirmek
- bugun kanitlanan proof'u acik soylemek
- eksik proof katmanlarini acik tutmak

## Current App Proof Router

| App | Lane | Today | Proof Surface |
| --- | --- | --- | --- |
| EcommerceApp | Commerce | standalone root + source shell | [EcommerceApp.md](./EcommerceApp.md) |
| SocialMediaApp | Social | standalone root + source shell + richer example | [SocialMediaApp.md](./SocialMediaApp.md) |
| FitnessApp | Health / Fitness | standalone root + source shell | [FitnessApp.md](./FitnessApp.md) |

## Rule

Bu klasorde proof surface'i olan bir app otomatik olarak `Complete App` sayilmaz.

`Complete App` etiketi icin canonical standard:
- [../Complete-App-Standard.md](../Complete-App-Standard.md)

Bugun bu uc app icin dogru etiket:

- `Standalone Root`
- `App-shell proof surface`

## Related Surfaces

- [../App-Media/README.md](../App-Media/README.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Portfolio-Matrix.md](../Portfolio-Matrix.md)
