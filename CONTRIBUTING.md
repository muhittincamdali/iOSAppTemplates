# Contributing

Thanks for helping improve iOSAppTemplates. Bug reports, fixes to existing templates and
improvements to `create-ios-app` are all welcome.

## Before you start

- For a larger change, such as a new template or a change to the scaffolding rules, open an
  issue first so we can agree on the scope.
- Keep a pull request to one change. A fix to one template and a CI change are two pull
  requests.

## Local setup

You need Xcode with a Swift 6 toolchain and, to run the apps, XcodeGen
(`brew install xcodegen`).

```bash
swift test                               # create-ios-app and TemplateScaffold
scripts/test-templates.sh                # every template in the iOS Simulator
scripts/test-templates.sh FinanceApp     # a single template
```

To run a template app:

```bash
cd Templates/FinanceApp/App
xcodegen generate
open FinanceApp.xcodeproj
```

## Changing a template

- Keep the template free of third-party dependencies and of the root package.
- Put state and actions in the store and keep views thin, then add or update tests in
  `Tests/<Name>Tests/` for the behaviour you changed.
- If the first screen changes, refresh the screenshots with
  `scripts/capture-screenshots.sh <Name>` and commit the updated files in `docs/images/`.
- If you rename tabs, update `TemplateCatalog` and the table in `README.md`; a test checks
  that the catalog matches the source.

## Adding a template

1. Create `Templates/<Name>App/` with the same layout as the existing templates:
   `Package.swift`, `Sources/<Name>App/`, `Tests/<Name>AppTests/`, `App/project.yml` and
   `App/<Name>AppHost.swift`.
2. Expose a public `<Name>AppShell: App`.
3. Add a `TemplateDescriptor` to `TemplateCatalog` and the template to the CI matrix.
4. Add screenshots and a row to the README tables.

## Commits and pull requests

- Use [Conventional Commits](https://www.conventionalcommits.org/): `feat:`, `fix:`,
  `docs:`, `test:`, `refactor:`, `ci:`, `chore:`.
- Describe what changed and how you tested it.
- Add an entry under `Unreleased` in `CHANGELOG.md` for user-visible changes.

## Code of conduct

This project follows the [Contributor Covenant](CODE_OF_CONDUCT.md).
