# App Media Surfaces

Generated from `Documentation/app-surface-catalog.json`.

This directory is the canonical media router for the standalone app roots inside `iOSAppTemplates`.

Current truth:

- `20` standalone roots have published shareable gallery cards
- `20` standalone roots have published preview boards
- `20` standalone roots already have published runtime screenshots
- `20` standalone roots already have published demo clips
- this surface separates visual layers instead of hiding the screenshot and demo gap

This surface exists to:

- show screenshot and demo status truthfully
- provide a single canonical route for future capture batches
- keep proof pages and media pages separate

## Current Router

| App | Lane | Media Status | Surface |
| --- | --- | --- | --- |
| EcommerceApp | Commerce | `demo-published` | [EcommerceApp.md](./EcommerceApp.md) |
| SocialMediaApp | Social | `demo-published` | [SocialMediaApp.md](./SocialMediaApp.md) |
| FitnessApp | Health / Fitness | `demo-published` | [FitnessApp.md](./FitnessApp.md) |
| ProductivityApp | Productivity | `demo-published` | [ProductivityApp.md](./ProductivityApp.md) |
| FinanceApp | Finance | `demo-published` | [FinanceApp.md](./FinanceApp.md) |
| EducationApp | Education | `demo-published` | [EducationApp.md](./EducationApp.md) |
| FoodDeliveryApp | Food Delivery | `demo-published` | [FoodDeliveryApp.md](./FoodDeliveryApp.md) |
| TravelPlannerApp | Travel | `demo-published` | [TravelPlannerApp.md](./TravelPlannerApp.md) |
| AIAssistantApp | AI | `demo-published` | [AIAssistantApp.md](./AIAssistantApp.md) |
| NewsBlogApp | News | `demo-published` | [NewsBlogApp.md](./NewsBlogApp.md) |
| MusicPodcastApp | Music / Podcast | `demo-published` | [MusicPodcastApp.md](./MusicPodcastApp.md) |
| MarketplaceApp | Marketplace | `demo-published` | [MarketplaceApp.md](./MarketplaceApp.md) |
| MessagingApp | Messaging / Community | `demo-published` | [MessagingApp.md](./MessagingApp.md) |
| BookingReservationsApp | Booking / Reservations | `demo-published` | [BookingReservationsApp.md](./BookingReservationsApp.md) |
| NotesKnowledgeApp | Notes / Knowledge | `demo-published` | [NotesKnowledgeApp.md](./NotesKnowledgeApp.md) |
| CreatorShortVideoApp | Creator / Short Video | `demo-published` | [CreatorShortVideoApp.md](./CreatorShortVideoApp.md) |
| TeamCollaborationApp | Team Collaboration | `demo-published` | [TeamCollaborationApp.md](./TeamCollaborationApp.md) |
| CRMAdminApp | CRM / Admin | `demo-published` | [CRMAdminApp.md](./CRMAdminApp.md) |
| SubscriptionLifestyleApp | Subscription Lifestyle | `demo-published` | [SubscriptionLifestyleApp.md](./SubscriptionLifestyleApp.md) |
| PrivacyVaultApp | Privacy / Secure Vault | `demo-published` | [PrivacyVaultApp.md](./PrivacyVaultApp.md) |

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

If an app is marked `demo-published`, it means:

- a shareable gallery card exists
- a preview board exists
- at least one runtime screenshot is now published
- at least one short runtime demo clip is now published

## Related Surfaces

- [../App-Gallery.md](../App-Gallery.md)
- [../App-Proofs/README.md](../App-Proofs/README.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Complete-App-Standard.md](../Complete-App-Standard.md)
