# Security Policy

## Scope

This repository contains app templates that run on in-memory sample data and a
command-line tool that copies files on your machine. Reports are most useful for:

- `create-ios-app` and the `TemplateScaffold` library, for example writing outside the
  chosen output directory
- template code that would be unsafe to keep when the template is turned into a real app,
  such as the `LocalAuthService` sample in `SocialMediaApp`
- the CI workflow

The templates are not meant to ship unchanged. `LocalAuthService` stores demo passwords in
memory in plain text and should be replaced before release.

## Reporting a vulnerability

Please do not open a public issue. Use
[GitHub private vulnerability reporting](https://github.com/muhittincamdali/iOSAppTemplates/security/advisories/new)
or email muhittincamdali@gmail.com with:

- the affected file or command
- what an attacker could do
- steps to reproduce

Fixes are released on `master`; there are no separately maintained release branches.
