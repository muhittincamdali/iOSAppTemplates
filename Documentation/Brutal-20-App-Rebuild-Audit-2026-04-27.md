# Brutal 20 App Rebuild Audit

Date: `2026-04-27`
Repo: `muhittincamdali/iOSAppTemplates`

## Executive Verdict

`iOSAppTemplates` is not yet a world-class `20`-app portfolio.

The hard truth:

- the repo now has `20` standalone roots, runtime screenshots, demo clips, and launch proof
- but too many apps still feel like structured demos instead of category-leading products
- several apps still lack deep second-step and third-step interactions
- many app surfaces still over-rely on seeded dashboard cards instead of true user actions
- the current bar is `portfolio-ready starter system`, not `world-#1 app collection`

That is not enough for the user goal.

## What Changes Now

The quality target must change from:

- `manifest-valid`
- `launches in simulator`
- `has screenshots and clips`

to:

- `real primary flow`
- `real secondary flow`
- `real state transitions`
- `real user actions`
- `real domain depth`
- `real retention / trust / settings / recovery / admin surfaces`

## Market Signal

The portfolio should prioritize the categories with the strongest combination of retention, monetization, breadth, and demo power.

Evidence:

- `Health & Fitness` and `Productivity` lead yearly retention in RevenueCat's 2026 subscription report.
- `AI` monetizes strongly but retention is structurally weaker, so AI apps need stronger memory / trust / habit loops.
- Apple continues to reject apps that look like template spam or category clones without distinct functionality.

Inference:

- the repo cannot win by shipping `20` visual variants
- it can only win by making each app visibly distinct in the first minute of usage

## Non-Negotiable Rebuild Standard

Every app must reach all of these:

1. `5+` real screens
2. at least `3` live user actions that mutate state
3. one complete primary flow from start to outcome
4. one complete secondary flow
5. meaningful empty / loading / error / success states
6. persistent seeded data that feels product-real, not placeholder
7. settings / trust / recovery / profile surface where relevant
8. screenshot, demo clip, scenario frames, and hosted proof aligned with real behavior

## App-by-App Brutal Matrix

### 1. EcommerceApp

- Product target: `E-Commerce Store`
- External benchmark:
  - `Imen-ks/eCommerce` — https://github.com/Imen-ks/eCommerce
  - `BerkaySancar/ShoppingApp-SwiftUI-MVVM` — https://github.com/BerkaySancar/ShoppingApp-SwiftUI-MVVM
- Must-win flows:
  - category browse
  - product detail
  - cart mutation
  - checkout summary
  - order history
- Current gap:
  - richer than before, but still too dashboard-heavy
  - checkout trust and post-purchase lifecycle need more depth
- World-class rebuild target:
  - PDP with variants, reviews, shipping ETA, stock rules
  - cart edit + coupon + address + payment method + order confirmation
  - reorder and saved items flow

### 2. SocialMediaApp

- Product target: `Social Media`
- External benchmark:
  - `Dimillian/IceCubesApp` — https://github.com/Dimillian/IceCubesApp
  - `dkhamsing/open-source-ios-apps` social references — https://github.com/dkhamsing/open-source-ios-apps
- Must-win flows:
  - feed
  - compose
  - comments
  - profile
  - notifications
- Current gap:
  - better than shell stage, but creator graph and engagement loops are still shallow
- World-class rebuild target:
  - follow / unfollow state
  - save / repost / like state
  - media post composer
  - creator analytics slice inside profile

### 3. FitnessApp

- Product target: `Health / Fitness`
- External benchmark:
  - `Imen-ks/Fitness` — https://github.com/Imen-ks/Fitness
- Must-win flows:
  - workout session
  - progress trend
  - goals
  - recovery summary
  - metrics history
- Current gap:
  - still reads more like summary surfaces than a workout product
- World-class rebuild target:
  - start / pause / finish workout
  - workout detail history
  - progressive goal logic
  - HealthKit-facing trust and permission UX

### 4. ProductivityApp

- Product target: `Productivity / Tasks`
- External benchmark:
  - `Tsymlov/Pomodoro-Timer` — https://github.com/Tsymlov/Pomodoro-Timer
  - `Brisqi` topic reference — https://github.com/topics/productivity-app
- Must-win flows:
  - inbox
  - project board
  - focus session
  - review
  - quick capture
- Current gap:
  - task system is stronger now, but still not deep enough in prioritization and review loops
- World-class rebuild target:
  - task lifecycle transitions
  - calendar/deadline planning
  - focus timer that mutates review state
  - weekly review surface

### 5. FinanceApp

- Product target: `Finance / Budgeting`
- External benchmark:
  - `rarfell/dimeApp` — https://github.com/rarfell/dimeApp
  - `BearTS/actual-budget-app` topic result — https://github.com/topics/budgeting-app
  - `canopas/splito` — https://github.com/canopas/splito
- Must-win flows:
  - account overview
  - transactions
  - budget categories
  - recurring items
  - insight/reporting
- Current gap:
  - accounts and budgets exist, but transaction logic and recurrence depth are still weak
- World-class rebuild target:
  - add/edit transaction flow
  - recurring expense surface
  - budget variance drilldown
  - biometric lock and export/import boundary

### 6. EducationApp

- Product target: `Education / Learning`
- External benchmark:
  - category reference via open iOS learning apps in `dkhamsing/open-source-ios-apps`
  - architecture baseline: `nalexn/clean-architecture-swiftui` — https://github.com/nalexn/clean-architecture-swiftui
- Must-win flows:
  - course browse
  - lesson detail
  - quiz
  - progress
  - study review
- Current gap:
  - course and lesson flow exists, but the learning loop is still too static
- World-class rebuild target:
  - lesson completion state
  - quiz grading and retry flow
  - progress unlock rules
  - notes and revision queue

### 7. FoodDeliveryApp

- Product target: `Food Delivery`
- External benchmark:
  - `apple/sample-food-truck` — https://github.com/apple/sample-food-truck
  - `AmeddahAchraf/Food-Delivery-SwiftUI` topic result — https://github.com/topics/food-delivery-application
- Must-win flows:
  - discovery
  - menu detail
  - cart
  - checkout
  - order tracking
- Current gap:
  - good directional rebuild, but menu and checkout are still not deep enough
- World-class rebuild target:
  - item customization
  - address selection
  - checkout timeline
  - courier detail and reorder

### 8. TravelPlannerApp

- Product target: `Travel Planner`
- External benchmark:
  - `sebastian-nunez/airbnb-ios` — https://github.com/sebastian-nunez/airbnb-ios
  - `samialhamad/Gatherly-SwiftUI` — https://github.com/samialhamad/Gatherly-SwiftUI
- Must-win flows:
  - trip overview
  - itinerary timeline
  - booking detail
  - essentials checklist
  - traveler profile
- Current gap:
  - itinerary is present, but collaboration, edits, and map/deeplink utility are too thin
- World-class rebuild target:
  - editable day plan
  - booking change states
  - map/deeplink utilities
  - checklist completion and doc readiness

### 9. AIAssistantApp

- Product target: `AI Assistant`
- External benchmark:
  - `noobnooc/AssisChat` — https://github.com/noobnooc/AssisChat
  - `WhatsMusic/Pocket-Assistant` — https://github.com/WhatsMusic/Pocket-Assistant
  - `Panl/AICat` — https://github.com/Panl/AICat
- Must-win flows:
  - conversation
  - presets
  - memory
  - tools
  - trust
- Current gap:
  - trust layer improved, but tool execution and memory lifecycle are still too soft
- World-class rebuild target:
  - conversation threads
  - prompt preset execution
  - memory pin / unpin / retention policy
  - tool call result surfaces
  - safety escalation states

### 10. NewsBlogApp

- Product target: `News / Editorial`
- External benchmark:
  - `alfianlosari/NewsAppSwiftUI` — https://github.com/alfianlosari/NewsAppSwiftUI
  - `FireLord/SlideNews` topic result — https://github.com/topics/news-app
- Must-win flows:
  - top stories
  - sections
  - saved reads
  - digest
  - profile/preferences
- Current gap:
  - editorial desk is better, but reader-mode and preference depth are still light
- World-class rebuild target:
  - article reading state
  - save / unsave / share
  - section preference follow state
  - digest preference management

### 11. MusicPodcastApp

- Product target: `Music / Podcast`
- External benchmark:
  - AudioKit org reference — https://github.com/audiokit
  - `AudioKit/Keyboard` and related SwiftUI audio components — https://github.com/audiokit
- Must-win flows:
  - now playing
  - queue
  - downloads
  - discover
  - profile
- Current gap:
  - more product-like now, but playback interaction depth is still limited
- World-class rebuild target:
  - real queue reorder state
  - playback speed / resume state
  - download management
  - show follow/subscription logic

### 12. MarketplaceApp

- Product target: `Marketplace`
- External benchmark:
  - `fleetbase/storefront-app` topic reference — https://github.com/topics/ecommerce-app
  - `sebastian-nunez/airbnb-ios` for booking/trust depth — https://github.com/sebastian-nunez/airbnb-ios
- Must-win flows:
  - listing browse
  - listing detail
  - seller desk
  - orders
  - trust/dispute
- Current gap:
  - buyer/seller split exists, but listing lifecycle and dispute logic need more depth
- World-class rebuild target:
  - seller inventory edits
  - listing moderation state
  - dispute creation and resolution view
  - payout timeline

### 13. MessagingApp

- Product target: `Messaging / Community`
- External benchmark:
  - `exyte/Chat` — https://github.com/exyte/Chat
  - `GetStream/stream-chat-swiftui` — https://github.com/GetStream/stream-chat-swiftui
  - `GetStream/swiftui-chat-tutorial` — https://github.com/GetStream/swiftui-chat-tutorial
- Must-win flows:
  - inbox
  - thread
  - room
  - safety
  - profile
- Current gap:
  - much stronger now, but message composer, media, reactions, and moderation actions still need depth
- World-class rebuild target:
  - read/unread state
  - attachments
  - thread moderation action
  - room member roles

### 14. BookingReservationsApp

- Product target: `Booking & Reservations`
- External benchmark:
  - `sebastian-nunez/airbnb-ios` — https://github.com/sebastian-nunez/airbnb-ios
  - reservation topic signal — https://github.com/topics/reservation-system
- Must-win flows:
  - property/slot view
  - booking calendar
  - guest detail
  - request queue
  - host/operator profile
- Current gap:
  - guest management exists, but modification and support lifecycle are not deep enough
- World-class rebuild target:
  - reschedule / cancel flow
  - request accept / reject
  - payment/deposit status
  - guest note and support log

### 15. NotesKnowledgeApp

- Product target: `Notes / Knowledge Base`
- External benchmark:
  - `glushchenko/fsnotes` — https://github.com/topics/notes-app
  - `tehtbl/awesome-note-taking` — https://github.com/tehtbl/awesome-note-taking
  - `canopas/rich-editor-swiftui` — https://github.com/canopas/rich-editor-swiftui
- Must-win flows:
  - capture
  - library
  - backlinks/links
  - spaces
  - profile/review
- Current gap:
  - capture and links exist, but editing and graph-like navigation are still too shallow
- World-class rebuild target:
  - note editor actions
  - tag/backlink drilldown
  - space sharing rules
  - review queue and note resurfacing

### 16. CreatorShortVideoApp

- Product target: `Creator / Short Video`
- External benchmark:
  - `Mijick/Camera` — https://github.com/topics/ios-camera
  - `GetStream/stream-video-swift` — https://github.com/GetStream/stream-video-swift
  - `StreamUI/StreamUI.swift` — https://github.com/StreamUI/StreamUI.swift
- Must-win flows:
  - studio
  - drafts
  - analytics
  - publish queue
  - community
- Current gap:
  - studio is better, but creation toolchain still lacks real editing actions
- World-class rebuild target:
  - draft state mutation
  - trim/caption/edit markers
  - publish scheduling
  - analytics drilldown by clip

### 17. TeamCollaborationApp

- Product target: `Team Collaboration`
- External benchmark:
  - `twilio/twilio-video-app-ios` — https://github.com/twilio/twilio-video-app-ios
  - `GetStream/stream-video-swift` — https://github.com/GetStream/stream-video-swift
- Must-win flows:
  - workspace
  - tasks
  - decisions
  - handoffs
  - profile
- Current gap:
  - collaboration structure exists, but live coordination actions are still too static
- World-class rebuild target:
  - assign / resolve task
  - decision approval
  - handoff accept state
  - meeting/call hook surface

### 18. CRMAdminApp

- Product target: `CRM / Admin Companion`
- External benchmark:
  - no perfect open SwiftUI CRM benchmark found
  - architecture and collaboration references:
    - `twilio/twilio-video-app-ios` — https://github.com/twilio/twilio-video-app-ios
    - `nalexn/clean-architecture-swiftui` — https://github.com/nalexn/clean-architecture-swiftui
- Must-win flows:
  - pipeline
  - accounts
  - renewals
  - tasks
  - profile
- Current gap:
  - now meaningfully better, but mutation depth is still thin
- World-class rebuild target:
  - renewal stage transitions
  - account owner reassignment
  - risk note creation
  - SLA escalation logic

### 19. SubscriptionLifestyleApp

- Product target: `Subscription Lifestyle / Habit Tracker`
- External benchmark:
  - `okmoz/Habit` — https://github.com/okmoz/Habit
  - `TeymiaHabit` topic signal — https://github.com/topics/habit-tracker?l=swift
- Must-win flows:
  - dashboard
  - programs
  - streaks
  - plans/paywall
  - profile
- Current gap:
  - stronger retention framing now, but user progression is still too content-heavy and action-light
- World-class rebuild target:
  - join/leave program
  - streak completion mutation
  - plan switch and offer logic
  - pause/cancel/save-offer lifecycle

### 20. PrivacyVaultApp

- Product target: `Privacy / Secure Vault`
- External benchmark:
  - `EmilioPelaez/PrivateVault` — https://github.com/EmilioPelaez/PrivateVault
  - `adorsys/SecureKeyStorage` — https://github.com/adorsys/SecureKeyStorage
- Must-win flows:
  - vault
  - alerts
  - recovery
  - audit
  - profile
- Current gap:
  - trust surfaces improved, but secure item actions and recovery verification still need more behavior
- World-class rebuild target:
  - reveal / hide / lock state
  - grant revoke flow
  - recovery rehearsal state
  - audit remediation actions

## Brutal Priority Order

Priority wave for real world-class lift:

1. `EcommerceApp`
2. `SocialMediaApp`
3. `FitnessApp`
4. `ProductivityApp`
5. `FinanceApp`
6. `FoodDeliveryApp`
7. `TravelPlannerApp`
8. `AIAssistantApp`
9. `MessagingApp`
10. `PrivacyVaultApp`

Reason:

- these lanes have the strongest combination of demand, visibility, monetization, and App Store distinctiveness

## Rebuild Rule Per App

Each app must be rebuilt against this checklist:

1. primary flow
2. secondary flow
3. detail screen depth
4. mutation state
5. trust/settings/admin/recovery
6. empty/loading/error/success
7. runtime proof
8. screenshot/clip/scenario proof

## Hard Conclusion

The repo does not need more fake breadth.

It needs:

- deeper interaction logic
- more real actions
- stronger state mutation
- clearer category differentiation
- less dashboard filler
- less repeated card anatomy

If the next phase does not rebuild app behavior itself, the repo will stay below the target no matter how green the workflows are.

## Source List

- RevenueCat State of Subscription Apps 2026 Productivity:
  - https://www.revenuecat.com/state-of-subscription-apps-2026-productivity/
- AppMagic Mobile Market Landscape 2026:
  - https://appmagic.rocks/files/view/upload/Reports/EN_MobileMarkeLandscape2026.pdf
- Apple App Review Guidelines:
  - https://developer.apple.com/appstore/resources/approval/guidelines.html
- Apple App Store Transparency Report 2023:
  - https://www.apple.com/legal/more-resources/docs/2023-App-Store-Transparency-Report.pdf
- Open-source iOS benchmark list:
  - https://github.com/dkhamsing/open-source-ios-apps
- Benchmarks used above:
  - https://github.com/Imen-ks/eCommerce
  - https://github.com/BerkaySancar/ShoppingApp-SwiftUI-MVVM
  - https://github.com/Imen-ks/Fitness
  - https://github.com/rarfell/dimeApp
  - https://github.com/canopas/splito
  - https://github.com/apple/sample-food-truck
  - https://github.com/sebastian-nunez/airbnb-ios
  - https://github.com/noobnooc/AssisChat
  - https://github.com/WhatsMusic/Pocket-Assistant
  - https://github.com/Panl/AICat
  - https://github.com/alfianlosari/NewsAppSwiftUI
  - https://github.com/exyte/Chat
  - https://github.com/GetStream/stream-chat-swiftui
  - https://github.com/GetStream/swiftui-chat-tutorial
  - https://github.com/twilio/twilio-video-app-ios
  - https://github.com/GetStream/stream-video-swift
  - https://github.com/EmilioPelaez/PrivateVault
  - https://github.com/okmoz/Habit
  - https://github.com/tehtbl/awesome-note-taking
  - https://github.com/canopas/rich-editor-swiftui
