# App Media Surfaces

Generated from `Documentation/app-surface-catalog.json`.

This directory is the canonical media router for the standalone app roots inside `iOSAppTemplates`.

Current truth:

- `20` standalone roots have published shareable gallery cards
- `20` standalone roots have published preview boards
- `20` standalone roots already have published runtime screenshots
- `20` standalone roots already have published demo clips
- `20` standalone roots already have published launch-to-ready scenario frame pairs
- this surface separates visual layers instead of hiding the runtime scenario gap

This surface exists to:

- show screenshot, demo, and scenario status truthfully
- provide a single canonical route for future capture batches
- keep proof pages and media pages separate

## Current Router

| App | Lane | Media Status | Surface |
| --- | --- | --- | --- |
| EcommerceApp | Commerce | `scenario-published` | [EcommerceApp.md](./EcommerceApp.md) |
| SocialMediaApp | Social | `scenario-published` | [SocialMediaApp.md](./SocialMediaApp.md) |
| FitnessApp | Health / Fitness | `scenario-published` | [FitnessApp.md](./FitnessApp.md) |
| ProductivityApp | Productivity | `scenario-published` | [ProductivityApp.md](./ProductivityApp.md) |
| FinanceApp | Finance | `scenario-published` | [FinanceApp.md](./FinanceApp.md) |
| EducationApp | Education | `scenario-published` | [EducationApp.md](./EducationApp.md) |
| FoodDeliveryApp | Food Delivery | `scenario-published` | [FoodDeliveryApp.md](./FoodDeliveryApp.md) |
| TravelPlannerApp | Travel | `scenario-published` | [TravelPlannerApp.md](./TravelPlannerApp.md) |
| AIAssistantApp | AI | `scenario-published` | [AIAssistantApp.md](./AIAssistantApp.md) |
| NewsBlogApp | News | `scenario-published` | [NewsBlogApp.md](./NewsBlogApp.md) |
| MusicPodcastApp | Music / Podcast | `scenario-published` | [MusicPodcastApp.md](./MusicPodcastApp.md) |
| MarketplaceApp | Marketplace | `scenario-published` | [MarketplaceApp.md](./MarketplaceApp.md) |
| MessagingApp | Messaging / Community | `scenario-published` | [MessagingApp.md](./MessagingApp.md) |
| BookingReservationsApp | Booking / Reservations | `scenario-published` | [BookingReservationsApp.md](./BookingReservationsApp.md) |
| NotesKnowledgeApp | Notes / Knowledge | `scenario-published` | [NotesKnowledgeApp.md](./NotesKnowledgeApp.md) |
| CreatorShortVideoApp | Creator / Short Video | `scenario-published` | [CreatorShortVideoApp.md](./CreatorShortVideoApp.md) |
| TeamCollaborationApp | Team Collaboration | `scenario-published` | [TeamCollaborationApp.md](./TeamCollaborationApp.md) |
| CRMAdminApp | CRM / Admin | `scenario-published` | [CRMAdminApp.md](./CRMAdminApp.md) |
| SubscriptionLifestyleApp | Subscription Lifestyle | `scenario-published` | [SubscriptionLifestyleApp.md](./SubscriptionLifestyleApp.md) |
| PrivacyVaultApp | Privacy / Secure Vault | `scenario-published` | [PrivacyVaultApp.md](./PrivacyVaultApp.md) |

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
- launch-to-ready scenario frames may still be missing

If an app is marked `scenario-published`, it means:

- a shareable gallery card exists
- a preview board exists
- at least one runtime screenshot is now published
- at least one short runtime demo clip is now published
- launch and ready runtime scenario frames are now published

## Related Surfaces

- [../App-Gallery.md](../App-Gallery.md)
- [../App-Proofs/README.md](../App-Proofs/README.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Complete-App-Standard.md](../Complete-App-Standard.md)
