# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this
project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

This release narrows the repository to what builds and is tested: the twenty app templates
under `Templates/` and a rewritten `create-ios-app`. The root package no longer exposes the
template libraries it shipped before, so the next version is a major release.

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

### Changed

- `create-ios-app` now copies a template and renames its package, module, types, host
  project and bundle identifier. Commands: `create-ios-app list` and
  `create-ios-app new <Name> --template <id>`.
- The root package targets macOS 14 and contains only `create-ios-app` and
  `TemplateScaffold`.
- Every template exposes a public `<Name>AppShell` scene instead of declaring `@main` in a
  library target.
- Each template is a single app module; the `<Name>Core` and `<Name>UI` modules, which the
  apps did not use, are gone.
- One CI workflow on macOS with SHA-pinned actions replaces nine workflows.
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

## [2.1.0] - 2026-04-26

Tagged release. See the tag `v2.1.0` for the state of the repository at that time.

## [2.0.0] - 2025-08-12

Tagged release. See the tag `v2.0.0` for the state of the repository at that time.

[Unreleased]: https://github.com/muhittincamdali/iOSAppTemplates/compare/v2.1.0...HEAD
[2.1.0]: https://github.com/muhittincamdali/iOSAppTemplates/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/muhittincamdali/iOSAppTemplates/releases/tag/v2.0.0
