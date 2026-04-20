# App Media Surfaces

Last updated: 2026-04-20

Bu klasor `iOSAppTemplates` icindeki standalone app root'lar icin canonical media router'dir.

Bugunku truth:

- `20` standalone root icin shareable gallery card image var
- canonical screenshots hala yok
- demo clips hala yok
- bu yuzey screenshot/demo eksigini gizlemeden card layer'i acikca gosterir

Bu yuzeyin rolu:

- screenshot/demo durumunu yalansiz gostermek
- gelecekteki capture batch'i icin tek canonical route vermek
- proof pages ile media pages'i ayri tutmak

## Current Router

| App | Lane | Media Status | Surface |
| --- | --- | --- | --- |
| EcommerceApp | Commerce | `card-published` | [EcommerceApp.md](./EcommerceApp.md) |
| SocialMediaApp | Social | `card-published` | [SocialMediaApp.md](./SocialMediaApp.md) |
| FitnessApp | Health / Fitness | `card-published` | [FitnessApp.md](./FitnessApp.md) |
| ProductivityApp | Productivity | `card-published` | [ProductivityApp.md](./ProductivityApp.md) |
| FinanceApp | Finance | `card-published` | [FinanceApp.md](./FinanceApp.md) |
| EducationApp | Education | `card-published` | [EducationApp.md](./EducationApp.md) |
| FoodDeliveryApp | Food Delivery | `card-published` | [FoodDeliveryApp.md](./FoodDeliveryApp.md) |
| TravelPlannerApp | Travel | `card-published` | [TravelPlannerApp.md](./TravelPlannerApp.md) |
| AIAssistantApp | AI | `card-published` | [AIAssistantApp.md](./AIAssistantApp.md) |
| NewsBlogApp | News | `card-published` | [NewsBlogApp.md](./NewsBlogApp.md) |
| MusicPodcastApp | Music / Podcast | `card-published` | [MusicPodcastApp.md](./MusicPodcastApp.md) |
| MarketplaceApp | Marketplace | `card-published` | [MarketplaceApp.md](./MarketplaceApp.md) |
| MessagingApp | Messaging / Community | `card-published` | [MessagingApp.md](./MessagingApp.md) |
| BookingReservationsApp | Booking / Reservations | `card-published` | [BookingReservationsApp.md](./BookingReservationsApp.md) |
| NotesKnowledgeApp | Notes / Knowledge | `card-published` | [NotesKnowledgeApp.md](./NotesKnowledgeApp.md) |
| CreatorShortVideoApp | Creator / Short Video | `card-published` | [CreatorShortVideoApp.md](./CreatorShortVideoApp.md) |
| TeamCollaborationApp | Team Collaboration | `card-published` | [TeamCollaborationApp.md](./TeamCollaborationApp.md) |
| CRMAdminApp | CRM / Admin | `card-published` | [CRMAdminApp.md](./CRMAdminApp.md) |
| SubscriptionLifestyleApp | Subscription Lifestyle | `card-published` | [SubscriptionLifestyleApp.md](./SubscriptionLifestyleApp.md) |
| PrivacyVaultApp | Privacy / Secure Vault | `card-published` | [PrivacyVaultApp.md](./PrivacyVaultApp.md) |

## Rule

Bir app icin media surface var diye o app `complete` sayilmaz.

Bir app icin media surface `card-published` ise:

- shareable gallery card image var
- screenshot hala yok olabilir
- demo clip hala yok olabilir

## Related Surfaces

- [../App-Gallery.md](../App-Gallery.md)
- [../App-Proofs/README.md](../App-Proofs/README.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Complete-App-Standard.md](../Complete-App-Standard.md)
