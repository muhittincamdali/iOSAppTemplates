# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this
project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- `CleanArchitectureApp` template (`--template clean-architecture`), merged from
  `ios-clean-architecture-template`: a team directory split into Domain, Data and Presentation
  targets plus a composition root, with an HTTP layer, an in-process sample server, an offline
  file cache, role-based permissions enforced in use cases and 98 tests in four test targets.
- UI tests for the `CleanArchitectureApp` host app (search, offline fallback and an
  accessibility audit), run by a new job in `templates.yml`.
- DocC article "Working with the Clean Architecture Template".

### Changed

- `scripts/test-templates.sh` reports the total number of tests across all test bundles of a
  template instead of the count of the last bundle.

### Fixed

- EducationApp: course percentages no longer trap on NaN or infinite progress values, clamp
  progress to the 0...1 range and are rounded instead of truncated, so the dashboard shows a
  completion rate of 65% instead of 64% for the sample data.

## [3.0.0] - 2026-10-14

This release narrows the repository to what builds and is tested: the twenty app templates
under `Templates/` and a rewritten `create-ios-app`. The root package no longer exposes the
template libraries it shipped before, so this is a major release.

### Added

- `TemplateScaffold` library with `TemplateCatalog`, `ProjectName`, `IdentifierRenamer`,
  `Scaffolder` and `TemplateLocator`, plus a DocC catalog.
- Swift Testing suites for the scaffolding library and for the store of every template;
  the documented library example is compiled and run by the tests.
- `App/project.yml` (XcodeGen) and a host file for every template, so each one runs in the
  simulator.
- `scripts/test-templates.sh` and `scripts/capture-screenshots.sh`, and light and dark
  screenshots of every template in `docs/images/`.
- Buttons in PrivacyVaultApp for hardening, alert resolution, contact verification,
  recovery kit rotation and audit review; previously the store had no reachable actions.
- `AuthService` protocol and in-memory `LocalAuthService` with a demo account in
  SocialMediaApp.
- `Examples/QuickStart`, an iOS app project that adds a template as a local package and
  starts its scene; CI builds it.
- DocC article "Adding a Template to an App".
- README translations in Turkish, Simplified Chinese, Japanese, Korean, Spanish, German,
  French, Brazilian Portuguese and Russian, and a generated banner, badges, buttons and
  social preview (`.github/brand/`, `docs/social-preview.png`).

### Changed

- `create-ios-app` now copies a template and renames its package, module, types, host
  project and bundle identifier. Commands: `create-ios-app list` and
  `create-ios-app new <Name> --template <id>`.
- The root package targets macOS 14 and contains only `create-ios-app` and
  `TemplateScaffold`.
- Every template exposes a public `<Name>Shell` scene instead of declaring `@main` in a
  library target.
- Each template is a single app module; the `<Name>Core` and `<Name>UI` modules, which the
  apps did not use, are gone.
- CI replaces nine workflows: `ci.yml`, `docs.yml` and `quality.yml` call the shared
  workflows of `muhittincamdali/.github` (SwiftPM build and test, DocC on GitHub Pages,
  link check, wording check, README translation check), and `templates.yml` runs SwiftLint
  in strict mode, a scaffold-and-test of a generated project, the example build and a test
  job per template. Actions are pinned to commit SHAs; jobs use the default Xcode of the
  `macos-26` image.
- EcommerceApp, FitnessApp and SocialMediaApp are split into store, model and screen
  files.
- PrivacyVaultApp (vault items, alerts, contacts, audit checks), FoodDeliveryApp (order
  status) and TravelPlannerApp (flight and document status) use enums instead of strings
  for those states. Other states in several templates are still compared as strings.
- BookingReservationsApp links each guest request to its stay by id instead of matching
  sample guest names.
- The README follows the shared layout with a three-step quick start; the code of conduct
  is inherited from `muhittincamdali/.github`.
- README, CONTRIBUTING, SECURITY and the template READMEs describe the current layout.

### Removed

- Root library products `iOSAppTemplates`, `SocialTemplates`, `CommerceTemplates`,
  `HealthTemplates`, `ProductivityTemplates`, `EntertainmentTemplates`,
  `EducationTemplates`, `FinanceTemplates`, `TravelTemplates`, `TCATemplates`,
  `VisionOSTemplates`, `AITemplates`, `PerformanceTemplates` and `SecurityTemplates`. Three
  of them depended on The Composable Architecture, which does not compile with Swift 6.4,
  so the root package did not build. They remain available in the git history.
- Firebase, Kingfisher, Alamofire and Charts dependencies from the templates.
- Environment-variable interaction-proof hooks in the template apps.
- Generated documentation, proof pages, example stubs, audit reports and orphan sample
  packages (`GalacticVault`, `MyNewApp`, `VisionEmpire`).

### Fixed

- The root package builds again with Swift 6.4.
- The PrivacyVaultApp test expected three quick actions while the code defines four.
- The old `create-ios-app` generated projects that depended on packages that do not exist.
- `create-ios-app` rejects every Swift keyword that cannot follow `import`, such as `guard`
  or `public`, as a project name; such names produced packages that did not compile.
- `create-ios-app` refuses names that would collide with names in the template
  (`ScaffoldError.nameConflict`). `new CommerceStore --template ecommerce` used to overwrite
  `CommerceStore.swift` and report success for a project that did not compile.
- SocialMediaApp's sample data loaded random photos from picsum.photos; sample media is now
  drawn locally and the template makes no network requests.
- `scripts/capture-screenshots.sh` creates an iPhone 17 Pro simulator instead of whichever
  device type `simctl` listed last.
- The LICENSE copyright year is 2025, when the repository started.

## [2.1.0] - 2026-04-26

Tagged release. See the tag `v2.1.0` for the state of the repository at that time.

## [2.0.0] - 2025-08-12

Tagged release. See the tag `v2.0.0` for the state of the repository at that time.

[Unreleased]: https://github.com/muhittincamdali/iOSAppTemplates/compare/v3.0.0...HEAD
[3.0.0]: https://github.com/muhittincamdali/iOSAppTemplates/compare/v2.1.0...v3.0.0
[2.1.0]: https://github.com/muhittincamdali/iOSAppTemplates/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/muhittincamdali/iOSAppTemplates/releases/tag/v2.0.0
