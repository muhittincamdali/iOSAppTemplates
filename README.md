# iOSAppTemplates

[![CI](https://github.com/muhittincamdali/iOSAppTemplates/actions/workflows/ci.yml/badge.svg)](https://github.com/muhittincamdali/iOSAppTemplates/actions/workflows/ci.yml)
[![License](https://img.shields.io/github/license/muhittincamdali/iOSAppTemplates)](LICENSE)

Twenty SwiftUI app templates for iOS 18, each a standalone Swift package with its own
tests, plus `create-ios-app`, a command-line tool that copies a template into a new
project under your own name.

The templates are starting points, not finished products: every screen runs on in-memory
sample data, and there is no networking layer or database. What they give you is a
working tab structure, navigation, and a tested store per app that you can wire to your
own services.

| AI Assistant                                                                             | Booking & Reservations                                                                                       | Creator Short Video                                                                                   | CRM Admin                                                                          | E-commerce                                                                           |
| ---------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| <img src="docs/images/AIAssistantApp-light.jpg" width="160" alt="AI Assistant template"> | <img src="docs/images/BookingReservationsApp-light.jpg" width="160" alt="Booking and Reservations template"> | <img src="docs/images/CreatorShortVideoApp-light.jpg" width="160" alt="Creator Short Video template"> | <img src="docs/images/CRMAdminApp-light.jpg" width="160" alt="CRM Admin template"> | <img src="docs/images/EcommerceApp-light.jpg" width="160" alt="E-commerce template"> |

| Education                                                                           | Personal Finance                                                                         | Fitness                                                                         | Food Delivery                                                                              | Marketplace                                                                             |
| ----------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------- |
| <img src="docs/images/EducationApp-light.jpg" width="160" alt="Education template"> | <img src="docs/images/FinanceApp-light.jpg" width="160" alt="Personal Finance template"> | <img src="docs/images/FitnessApp-light.jpg" width="160" alt="Fitness template"> | <img src="docs/images/FoodDeliveryApp-light.jpg" width="160" alt="Food Delivery template"> | <img src="docs/images/MarketplaceApp-light.jpg" width="160" alt="Marketplace template"> |

| Messaging                                                                                           | Music & Podcasts                                                                                                | News & Blog                                                                                            | Notes & Knowledge                                                                                                  | Privacy Vault                                                                                              |
| --------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------- |
| <img src="docs/images/MessagingApp-dark.jpg" width="160" alt="Messaging template, dark appearance"> | <img src="docs/images/MusicPodcastApp-dark.jpg" width="160" alt="Music and Podcasts template, dark appearance"> | <img src="docs/images/NewsBlogApp-dark.jpg" width="160" alt="News and Blog template, dark appearance"> | <img src="docs/images/NotesKnowledgeApp-dark.jpg" width="160" alt="Notes and Knowledge template, dark appearance"> | <img src="docs/images/PrivacyVaultApp-dark.jpg" width="160" alt="Privacy Vault template, dark appearance"> |

| Productivity                                                                                              | Social Media                                                                                             | Subscription Lifestyle                                                                                                       | Team Collaboration                                                                                                   | Travel Planner                                                                                               |
| --------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| <img src="docs/images/ProductivityApp-dark.jpg" width="160" alt="Productivity template, dark appearance"> | <img src="docs/images/SocialMediaApp-dark.jpg" width="160" alt="Social Media template, dark appearance"> | <img src="docs/images/SubscriptionLifestyleApp-dark.jpg" width="160" alt="Subscription Lifestyle template, dark appearance"> | <img src="docs/images/TeamCollaborationApp-dark.jpg" width="160" alt="Team Collaboration template, dark appearance"> | <img src="docs/images/TravelPlannerApp-dark.jpg" width="160" alt="Travel Planner template, dark appearance"> |

Screenshots are taken in the iOS Simulator by
[`scripts/capture-screenshots.sh`](scripts/capture-screenshots.sh). Light and dark
versions of every template are in [`docs/images`](docs/images).

## Templates

| `--template`             | Template                                                     | Tabs                                             |
| ------------------------ | ------------------------------------------------------------ | ------------------------------------------------ |
| `ai-assistant`           | [AI Assistant](Templates/AIAssistantApp)                     | Workspace, Presets, Memory, Tools, Trust         |
| `booking`                | [Booking & Reservations](Templates/BookingReservationsApp)   | Home, Calendar, Guests, Requests, Profile        |
| `creator-video`          | [Creator Short Video](Templates/CreatorShortVideoApp)        | Studio, Pipeline, Analytics, Moderation, Profile |
| `crm`                    | [CRM Admin](Templates/CRMAdminApp)                           | Pipeline, Accounts, Renewals, Tasks, Profile     |
| `ecommerce`              | [E-commerce](Templates/EcommerceApp)                         | Shop, Browse, Cart, Orders, Profile              |
| `education`              | [Education](Templates/EducationApp)                          | Home, Courses, Lessons, Assessments, Progress    |
| `finance`                | [Personal Finance](Templates/FinanceApp)                     | Overview, Accounts, Budgets, Activity, Insights  |
| `fitness`                | [Fitness](Templates/FitnessApp)                              | Plan, Session, Progress, Recovery, Profile       |
| `food-delivery`          | [Food Delivery](Templates/FoodDeliveryApp)                   | Home, Browse, Cart, Orders, Profile              |
| `marketplace`            | [Marketplace](Templates/MarketplaceApp)                      | Home, Browse, Seller, Orders, Trust              |
| `messaging`              | [Messaging](Templates/MessagingApp)                          | Inbox, Rooms, Safety, Profile                    |
| `music-podcast`          | [Music & Podcasts](Templates/MusicPodcastApp)                | Library, Queue, Downloads, Discover, Profile     |
| `news-blog`              | [News & Blog](Templates/NewsBlogApp)                         | Today, Sections, Saved, Digest, Profile          |
| `notes`                  | [Notes & Knowledge](Templates/NotesKnowledgeApp)             | Capture, Library, Links, Spaces, Profile         |
| `privacy-vault`          | [Privacy Vault](Templates/PrivacyVaultApp)                   | Vault, Alerts, Recovery, Audit, Profile          |
| `productivity`           | [Productivity](Templates/ProductivityApp)                    | Dashboard, Inbox, Projects, Focus, Review        |
| `social`                 | [Social Media](Templates/SocialMediaApp)                     | Feed, Explore, Create, Notifications, Profile    |
| `subscription-lifestyle` | [Subscription Lifestyle](Templates/SubscriptionLifestyleApp) | Dashboard, Programs, Streaks, Plans, Profile     |
| `team-collaboration`     | [Team Collaboration](Templates/TeamCollaborationApp)         | Workspace, Tasks, Decisions, Handoffs, Profile   |
| `travel`                 | [Travel Planner](Templates/TravelPlannerApp)                 | Trips, Timeline, Bookings, Essentials, Profile   |

Each template contains:

- `Sources/<Name>/<Name>.swift`: the public `<Name>Shell` app scene, the screens, and a
  `@MainActor` `ObservableObject` store that owns the sample data and every action the
  screens trigger (cart totals, order and booking state transitions, approval queues and
  so on).
- `Tests/<Name>Tests/`: a Swift Testing suite for that store, covering derived values,
  state transitions, guard clauses for invalid input and unknown identifiers, and limits
  that must not be exceeded.
- `App/`: an [XcodeGen](https://github.com/yonaskolb/XcodeGen) spec and a host file that
  calls `<Name>Shell.main()`, so the template runs on a simulator or device.

`SocialMediaApp` also shows how to put a boundary in front of an identity provider: sign-in
goes through an `AuthService` protocol, and the bundled `LocalAuthService` keeps accounts in
memory with a demo account (`demo@example.com` / `password123`).

## Requirements

- Xcode with a Swift 6 toolchain. The packages declare `swift-tools-version: 6.0`;
  the code in this repository was built and tested with Xcode 27 (Swift 6.4).
- iOS 18 or later for the templates.
- macOS 14 or later to run `create-ios-app`.
- XcodeGen (`brew install xcodegen`) to generate the host app projects.

## Create a project

```bash
git clone https://github.com/muhittincamdali/iOSAppTemplates.git
cd iOSAppTemplates

swift run create-ios-app list
swift run create-ios-app new MyShop --template ecommerce --output ~/Developer
```

The tool copies `Templates/EcommerceApp` to `~/Developer/MyShop` and renames the package,
module, test target, `EcommerceAppShell`, host project and bundle identifier to use
`MyShop`. Names must be Swift identifiers that start with an ASCII letter; the tool refuses
to overwrite an existing directory.

```bash
cd ~/Developer/MyShop
xcodebuild test -scheme MyShop -destination 'platform=iOS Simulator,name=iPhone 17'

cd App
xcodegen generate
open MyShop.xcodeproj
```

You can also work on a template in place: open `Templates/<Name>/Package.swift` in Xcode
to edit and test it, or generate its host project from `Templates/<Name>/App`.

## Use the scaffolding library

The logic behind `create-ios-app` is the `TemplateScaffold` library. It runs on macOS and
needs a checkout of this repository, because the templates are read from `Templates/`.

```swift
// Package.swift
.package(url: "https://github.com/muhittincamdali/iOSAppTemplates.git", branch: "master")
```

```swift
import Foundation
import TemplateScaffold

func makeShop(templates: URL, output: URL) throws -> ScaffoldResult {
    guard let template = TemplateCatalog.template(named: "ecommerce") else {
        throw CocoaError(.fileNoSuchFile)
    }
    let name = try ProjectName("MyShop")
    return try Scaffolder(templatesDirectory: templates).scaffold(template, as: name, in: output)
}
```

This snippet is compiled and run by the test suite. API documentation is in the DocC
catalog under `Sources/TemplateScaffold/TemplateScaffold.docc`:

```bash
swift package generate-documentation --target TemplateScaffold
```

## Architecture

```text
Package.swift                 create-ios-app + TemplateScaffold (macOS)
Sources/CLI/                  argument parsing (swift-argument-parser)
Sources/TemplateScaffold/     catalog, name validation, renaming, copying
Tests/TemplateScaffoldTests/  Swift Testing, including a scaffold of every template
Templates/<Name>/             20 independent iOS 18 packages with tests and an App/ host
scripts/                      test-templates.sh, capture-screenshots.sh
```

The templates do not depend on the root package or on each other, and none of them has a
third-party dependency. Each app keeps its state in a store class (`SocialMediaApp` splits
it across three managers) so the screens stay thin and the behaviour can be tested
without UI.

## Development

```bash
swift test                                   # scaffolding library and CLI
scripts/test-templates.sh                    # all templates in the iOS Simulator
scripts/test-templates.sh EcommerceApp       # one template
scripts/capture-screenshots.sh               # refresh docs/images
```

CI runs the same commands on macOS for pushes to `master` and for pull requests: the root package
tests, a scaffold-and-test of a generated project, and a test job per template.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Changes are recorded in
[CHANGELOG.md](CHANGELOG.md).

## License

MIT. See [LICENSE](LICENSE).
