# App Media Surfaces

Last updated: 2026-04-20

Bu klasor `iOSAppTemplates` icindeki standalone app root'lar icin canonical media router'dir.

Bugunku truth:

- `20` standalone root icin shareable gallery card image var
- `20` standalone root icin preview board image var
- canonical screenshots hala yok
- demo clips hala yok
- bu yuzey screenshot/demo eksigini gizlemeden visual proof katmanlarini ayri ayri gosterir

Bu yuzeyin rolu:

- screenshot/demo durumunu yalansiz gostermek
- gelecekteki capture batch'i icin tek canonical route vermek
- proof pages ile media pages'i ayri tutmak

## Current Router

| App | Lane | Media Status | Surface |
| --- | --- | --- | --- |
| EcommerceApp | Commerce | `preview-published` | [EcommerceApp.md](./EcommerceApp.md) |
| SocialMediaApp | Social | `preview-published` | [SocialMediaApp.md](./SocialMediaApp.md) |
| FitnessApp | Health / Fitness | `preview-published` | [FitnessApp.md](./FitnessApp.md) |
| ProductivityApp | Productivity | `preview-published` | [ProductivityApp.md](./ProductivityApp.md) |
| FinanceApp | Finance | `preview-published` | [FinanceApp.md](./FinanceApp.md) |
| EducationApp | Education | `preview-published` | [EducationApp.md](./EducationApp.md) |
| FoodDeliveryApp | Food Delivery | `preview-published` | [FoodDeliveryApp.md](./FoodDeliveryApp.md) |
| TravelPlannerApp | Travel | `preview-published` | [TravelPlannerApp.md](./TravelPlannerApp.md) |
| AIAssistantApp | AI | `preview-published` | [AIAssistantApp.md](./AIAssistantApp.md) |
| NewsBlogApp | News | `preview-published` | [NewsBlogApp.md](./NewsBlogApp.md) |
| MusicPodcastApp | Music / Podcast | `preview-published` | [MusicPodcastApp.md](./MusicPodcastApp.md) |
| MarketplaceApp | Marketplace | `preview-published` | [MarketplaceApp.md](./MarketplaceApp.md) |
| MessagingApp | Messaging / Community | `preview-published` | [MessagingApp.md](./MessagingApp.md) |
| BookingReservationsApp | Booking / Reservations | `preview-published` | [BookingReservationsApp.md](./BookingReservationsApp.md) |
| NotesKnowledgeApp | Notes / Knowledge | `preview-published` | [NotesKnowledgeApp.md](./NotesKnowledgeApp.md) |
| CreatorShortVideoApp | Creator / Short Video | `preview-published` | [CreatorShortVideoApp.md](./CreatorShortVideoApp.md) |
| TeamCollaborationApp | Team Collaboration | `preview-published` | [TeamCollaborationApp.md](./TeamCollaborationApp.md) |
| CRMAdminApp | CRM / Admin | `preview-published` | [CRMAdminApp.md](./CRMAdminApp.md) |
| SubscriptionLifestyleApp | Subscription Lifestyle | `preview-published` | [SubscriptionLifestyleApp.md](./SubscriptionLifestyleApp.md) |
| PrivacyVaultApp | Privacy / Secure Vault | `preview-published` | [PrivacyVaultApp.md](./PrivacyVaultApp.md) |

## Rule

Bir app icin media surface var diye o app `complete` sayilmaz.

Bir app icin media surface `preview-published` ise:

- shareable gallery card image var
- preview board image var
- screenshot hala yok olabilir
- demo clip hala yok olabilir

## Related Surfaces

- [../App-Gallery.md](../App-Gallery.md)
- [../App-Proofs/README.md](../App-Proofs/README.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Complete-App-Standard.md](../Complete-App-Standard.md)
