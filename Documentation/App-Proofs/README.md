# App Proof Surfaces

Last updated: 2026-04-20

Bu klasor `iOSAppTemplates` icindeki standalone app root'lar icin canonical proof router'dir.

Bugunku kapsam:

- `Templates/EcommerceApp`
- `Templates/SocialMediaApp`
- `Templates/FitnessApp`
- `Templates/ProductivityApp`
- `Templates/FinanceApp`
- `Templates/EducationApp`
- `Templates/FoodDeliveryApp`
- `Templates/TravelPlannerApp`
- `Templates/AIAssistantApp`
- `Templates/NewsBlogApp`
- `Templates/MusicPodcastApp`
- `Templates/MarketplaceApp`
- `Templates/MessagingApp`
- `Templates/BookingReservationsApp`
- `Templates/NotesKnowledgeApp`
- `Templates/CreatorShortVideoApp`
- `Templates/TeamCollaborationApp`
- `Templates/CRMAdminApp`
- `Templates/SubscriptionLifestyleApp`
- `Templates/PrivacyVaultApp`

Bugun ek proof gercegi:

- `20` standalone root icin local generic iOS build proof var

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
| ProductivityApp | Productivity | standalone root + source shell + richer example | [ProductivityApp.md](./ProductivityApp.md) |
| FinanceApp | Finance | standalone root + source shell + richer example | [FinanceApp.md](./FinanceApp.md) |
| EducationApp | Education | standalone root + source shell + richer example | [EducationApp.md](./EducationApp.md) |
| FoodDeliveryApp | Food Delivery | standalone root + source shell + richer example | [FoodDeliveryApp.md](./FoodDeliveryApp.md) |
| TravelPlannerApp | Travel | standalone root + source shell + richer example | [TravelPlannerApp.md](./TravelPlannerApp.md) |
| AIAssistantApp | AI | standalone root + source shell + richer example | [AIAssistantApp.md](./AIAssistantApp.md) |
| NewsBlogApp | News | standalone root + source shell + richer example | [NewsBlogApp.md](./NewsBlogApp.md) |
| MusicPodcastApp | Music / Podcast | standalone root + source shell + richer example | [MusicPodcastApp.md](./MusicPodcastApp.md) |
| MarketplaceApp | Marketplace | standalone root + source shell + richer example | [MarketplaceApp.md](./MarketplaceApp.md) |
| MessagingApp | Messaging / Community | standalone root + source shell + richer example | [MessagingApp.md](./MessagingApp.md) |
| BookingReservationsApp | Booking / Reservations | standalone root + source shell + richer example | [BookingReservationsApp.md](./BookingReservationsApp.md) |
| NotesKnowledgeApp | Notes / Knowledge | standalone root + source shell + richer example | [NotesKnowledgeApp.md](./NotesKnowledgeApp.md) |
| CreatorShortVideoApp | Creator / Short Video | standalone root + source shell + richer example | [CreatorShortVideoApp.md](./CreatorShortVideoApp.md) |
| TeamCollaborationApp | Team Collaboration | standalone root + source shell + richer example | [TeamCollaborationApp.md](./TeamCollaborationApp.md) |
| CRMAdminApp | CRM / Admin | standalone root + source shell + richer example | [CRMAdminApp.md](./CRMAdminApp.md) |
| SubscriptionLifestyleApp | Subscription Lifestyle | standalone root + source shell + richer example | [SubscriptionLifestyleApp.md](./SubscriptionLifestyleApp.md) |
| PrivacyVaultApp | Privacy / Secure Vault | standalone root + source shell + richer example | [PrivacyVaultApp.md](./PrivacyVaultApp.md) |

## Rule

Bu klasorde proof surface'i olan bir app otomatik olarak `Complete App` sayilmaz.

`Complete App` etiketi icin canonical standard:
- [../Complete-App-Standard.md](../Complete-App-Standard.md)

Bugun bu app'ler icin dogru etiket:

- `Standalone Root`
- `App-shell proof surface`

## Related Surfaces

- [../App-Media/README.md](../App-Media/README.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Portfolio-Matrix.md](../Portfolio-Matrix.md)
