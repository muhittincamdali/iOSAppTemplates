# App Proof Surfaces

Generated from `Documentation/app-surface-catalog.json`.

This directory is the canonical proof router for the standalone app roots inside `iOSAppTemplates`.

Current proof envelope:

- `20` standalone app roots have canonical proof pages
- local generic iOS build proof exists for `20` standalone roots
- the hosted standalone iOS proof workflow is active for the same `20` roots
- `20` app packs currently also have a richer example route

These pages exist to:

- help users make a `best for / not for` decision
- clarify current product shape
- state today’s proof plainly
- keep missing proof layers visible

## Current App Proof Router

| App | Lane | Today | Proof Surface |
| --- | --- | --- | --- |
| EcommerceApp | Commerce | Standalone Root + richer example surface | [EcommerceApp.md](./EcommerceApp.md) |
| SocialMediaApp | Social | Standalone Root + richer example surface | [SocialMediaApp.md](./SocialMediaApp.md) |
| FitnessApp | Health / Fitness | Standalone Root + richer example surface | [FitnessApp.md](./FitnessApp.md) |
| ProductivityApp | Productivity | Standalone Root + richer example surface | [ProductivityApp.md](./ProductivityApp.md) |
| FinanceApp | Finance | Standalone Root + richer example surface | [FinanceApp.md](./FinanceApp.md) |
| EducationApp | Education | Standalone Root + richer example surface | [EducationApp.md](./EducationApp.md) |
| FoodDeliveryApp | Food Delivery | Standalone Root + richer example surface | [FoodDeliveryApp.md](./FoodDeliveryApp.md) |
| TravelPlannerApp | Travel | Standalone Root + richer example surface | [TravelPlannerApp.md](./TravelPlannerApp.md) |
| AIAssistantApp | AI | Standalone Root + richer example surface | [AIAssistantApp.md](./AIAssistantApp.md) |
| NewsBlogApp | News | Standalone Root + richer example surface | [NewsBlogApp.md](./NewsBlogApp.md) |
| MusicPodcastApp | Music / Podcast | Standalone Root + richer example surface | [MusicPodcastApp.md](./MusicPodcastApp.md) |
| MarketplaceApp | Marketplace | Standalone Root + richer example surface | [MarketplaceApp.md](./MarketplaceApp.md) |
| MessagingApp | Messaging / Community | Standalone Root + richer example surface | [MessagingApp.md](./MessagingApp.md) |
| BookingReservationsApp | Booking / Reservations | Standalone Root + richer example surface | [BookingReservationsApp.md](./BookingReservationsApp.md) |
| NotesKnowledgeApp | Notes / Knowledge | Standalone Root + richer example surface | [NotesKnowledgeApp.md](./NotesKnowledgeApp.md) |
| CreatorShortVideoApp | Creator / Short Video | Standalone Root + richer example surface | [CreatorShortVideoApp.md](./CreatorShortVideoApp.md) |
| TeamCollaborationApp | Team Collaboration | Standalone Root + richer example surface | [TeamCollaborationApp.md](./TeamCollaborationApp.md) |
| CRMAdminApp | CRM / Admin | Standalone Root + richer example surface | [CRMAdminApp.md](./CRMAdminApp.md) |
| SubscriptionLifestyleApp | Subscription Lifestyle | Standalone Root + richer example surface | [SubscriptionLifestyleApp.md](./SubscriptionLifestyleApp.md) |
| PrivacyVaultApp | Privacy / Secure Vault | Standalone Root + richer example surface | [PrivacyVaultApp.md](./PrivacyVaultApp.md) |

## Rule

A proof surface alone does not make an app a `Complete App`.

Correct labels for these apps today:

- `Standalone Root`
- `App-shell proof surface`

Canonical complete-app standard:
- [../Complete-App-Standard.md](../Complete-App-Standard.md)

## Related Surfaces

- [../App-Media/README.md](../App-Media/README.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Portfolio-Matrix.md](../Portfolio-Matrix.md)
- [../../.github/workflows/standalone-ios-proof.yml](../../.github/workflows/standalone-ios-proof.yml)
