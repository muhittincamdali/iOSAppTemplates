# Security Policy

`iOSAppTemplates` is an active starter-portfolio repository. Security reporting should focus on the maintained root package graph, standalone app roots, scripts, and public distribution surfaces that currently ship from this repository.

## Supported Scope

We prioritize security fixes for:

- the root Swift package graph from `Package.swift`
- template families under `Sources/`
- standalone app roots under `Templates/`
- example surfaces under `Examples/`
- generator and validation scripts under `Scripts/`
- public proof, media, release, and GitHub distribution surfaces

## Report A Vulnerability

- Do not open a public GitHub issue.
- Prefer GitHub Security Advisories:
  [Report a vulnerability](https://github.com/muhittincamdali/iOSAppTemplates/security/advisories)
- If private advisory reporting is unavailable, email:
  `muhittincamdali@gmail.com`

## What To Include

- affected path, app root, or package target
- impact
- reproduction steps
- proof of concept or code sample
- Swift, Xcode, and OS version if relevant
- whether the issue affects:
  - the root package graph
  - a standalone app root
  - an example surface
  - a release, proof, or distribution surface

## Current Security Posture

Treat the following as current guidance:

- examples and templates must never ship secrets, tokens, or production credentials
- public docs must not overclaim privacy or security guarantees that are not validated today
- standalone app roots are starter surfaces, not production-audited finished apps
- GitHub-hosted workflow status should stay truthful and green on the maintained branch
- release titles, release notes, and About-box metadata are part of the public trust surface

## Security Operations Matrix

| Surface | Current policy |
| --- | --- |
| Vulnerability intake | Prefer GitHub Security Advisories |
| Public issues | Do not use for vulnerabilities |
| Examples and templates | Never commit secrets or production credentials |
| Release surface | Keep titles and notes truth-first; no compliance hype without proof |
| GitHub-hosted workflows | Keep them active and truthful on `master` |
| Maintainer validation floor | `swift build -c release`, `swift test`, and relevant validators |

## Response Expectations

Security reports are reviewed as quickly as possible, but this file does not promise a hard SLA.

## Disclosure

Please allow time for triage, remediation, validation, and release preparation before public disclosure.

## Security-Related Docs

- [SUPPORT.md](SUPPORT.md)
- [CONTRIBUTING.md](CONTRIBUTING.md)
- [Documentation/GitHub-Distribution.md](Documentation/GitHub-Distribution.md)
- [Documentation/Release-Process.md](Documentation/Release-Process.md)
