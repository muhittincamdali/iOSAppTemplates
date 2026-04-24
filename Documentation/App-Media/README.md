# App Media Surfaces

Generated from `Documentation/app-surface-catalog.json`.

This directory is the canonical media router for the standalone app roots inside `iOSAppTemplates`.

Current truth:

- `20` standalone roots have published shareable gallery cards
- `20` standalone roots have published preview boards
- `3` standalone roots already have published runtime screenshots
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
| FitnessApp | Health / Fitness | `preview-published` | [FitnessApp.md](./FitnessApp.md) |
| ProductivityApp | Productivity | `screenshot-published` | [ProductivityApp.md](./ProductivityApp.md) |
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
