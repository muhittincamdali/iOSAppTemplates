# App Media Surfaces

Last updated: 2026-04-19

Bu klasor `iOSAppTemplates` icindeki standalone app root'lar icin canonical media router'dir.

Bugunku truth:

- `EcommerceApp` media `not-published`
- `SocialMediaApp` media `not-published`
- `FitnessApp` media `not-published`

Bu yuzeyin rolu:

- screenshot/demo durumunu yalansiz gostermek
- gelecekteki capture batch'i icin tek canonical route vermek
- proof pages ile media pages'i ayri tutmak

## Current Router

| App | Lane | Media Status | Surface |
| --- | --- | --- | --- |
| EcommerceApp | Commerce | `not-published` | [EcommerceApp.md](./EcommerceApp.md) |
| SocialMediaApp | Social | `not-published` | [SocialMediaApp.md](./SocialMediaApp.md) |
| FitnessApp | Health / Fitness | `not-published` | [FitnessApp.md](./FitnessApp.md) |

## Rule

Bir app icin media surface var diye o app `complete` sayilmaz.

Bir app icin media surface `not-published` ise:

- screenshot yok
- demo clip yok
- gallery card icin son visual proof yok

## Related Surfaces

- [../App-Proofs/README.md](../App-Proofs/README.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Complete-App-Standard.md](../Complete-App-Standard.md)
