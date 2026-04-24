# App Media Surfaces

Generated from `Documentation/app-surface-catalog.json`.

This directory is the canonical media router for the standalone app roots inside `iOSAppTemplates`.

Current truth:

- `20` standalone roots have published shareable gallery cards
- `20` standalone roots have published preview boards
- `20` standalone roots already have published runtime screenshots
- demo clips are still missing
- this surface separates visual layers instead of hiding the screenshot and demo gap

This surface exists to:

- show screenshot and demo status truthfully
- provide a single canonical route for future capture batches
- keep proof pages and media pages separate

## Current Router

| App | Lane | Media Status | Surface |
| --- | --- | --- | --- |
| EcommerceApp | Commerce | `screenshot-published` | [EcommerceApp.md](./EcommerceApp.md) |
| SocialMediaApp | Social | `screenshot-published` | [SocialMediaApp.md](./SocialMediaApp.md) |
| FitnessApp | Health / Fitness | `screenshot-published` | [FitnessApp.md](./FitnessApp.md) |
| ProductivityApp | Productivity | `screenshot-published` | [ProductivityApp.md](./ProductivityApp.md) |
| FinanceApp | Finance | `screenshot-published` | [FinanceApp.md](./FinanceApp.md) |
| EducationApp | Education | `screenshot-published` | [EducationApp.md](./EducationApp.md) |
| FoodDeliveryApp | Food Delivery | `screenshot-published` | [FoodDeliveryApp.md](./FoodDeliveryApp.md) |
| TravelPlannerApp | Travel | `screenshot-published` | [TravelPlannerApp.md](./TravelPlannerApp.md) |
| AIAssistantApp | AI | `screenshot-published` | [AIAssistantApp.md](./AIAssistantApp.md) |
| NewsBlogApp | News | `screenshot-published` | [NewsBlogApp.md](./NewsBlogApp.md) |
| MusicPodcastApp | Music / Podcast | `screenshot-published` | [MusicPodcastApp.md](./MusicPodcastApp.md) |
| MarketplaceApp | Marketplace | `screenshot-published` | [MarketplaceApp.md](./MarketplaceApp.md) |
| MessagingApp | Messaging / Community | `screenshot-published` | [MessagingApp.md](./MessagingApp.md) |
| BookingReservationsApp | Booking / Reservations | `screenshot-published` | [BookingReservationsApp.md](./BookingReservationsApp.md) |
| NotesKnowledgeApp | Notes / Knowledge | `screenshot-published` | [NotesKnowledgeApp.md](./NotesKnowledgeApp.md) |
| CreatorShortVideoApp | Creator / Short Video | `screenshot-published` | [CreatorShortVideoApp.md](./CreatorShortVideoApp.md) |
| TeamCollaborationApp | Team Collaboration | `screenshot-published` | [TeamCollaborationApp.md](./TeamCollaborationApp.md) |
| CRMAdminApp | CRM / Admin | `screenshot-published` | [CRMAdminApp.md](./CRMAdminApp.md) |
| SubscriptionLifestyleApp | Subscription Lifestyle | `screenshot-published` | [SubscriptionLifestyleApp.md](./SubscriptionLifestyleApp.md) |
| PrivacyVaultApp | Privacy / Secure Vault | `screenshot-published` | [PrivacyVaultApp.md](./PrivacyVaultApp.md) |

## Rule

A media surface alone does not make an app `complete`.

If an app is marked `preview-published`, it means:

- a shareable gallery card exists
- a preview board exists
- a real screenshot may still be missing
- a demo clip may still be missing

If an app is marked `screenshot-published`, it means:

- a shareable gallery card exists
- a preview board exists
- at least one runtime screenshot is now published
- a demo clip may still be missing

## Related Surfaces

- [../App-Gallery.md](../App-Gallery.md)
- [../App-Proofs/README.md](../App-Proofs/README.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Complete-App-Standard.md](../Complete-App-Standard.md)
