# GitHub Distribution

Last updated: 2026-04-21

This page defines the public GitHub-facing metadata and presentation rules for `iOSAppTemplates`.

## Current About Box

Source of truth checked against the GitHub repository API on 2026-04-21.

- description: `SwiftUI starter portfolio with 20 tracked app templates, standalone roots, proof surfaces, and gallery assets.`
- homepage: `https://github.com/muhittincamdali/iOSAppTemplates#readme`
- default branch: `master`
- primary repo URL: `https://github.com/muhittincamdali/iOSAppTemplates`

## Current Topics

- `app-templates`
- `clean-architecture`
- `ios`
- `ios-app-templates`
- `ios-development`
- `mvvm`
- `starter-kit`
- `swift`
- `swift-package-manager`
- `swiftui`

## Current Release Surface

Latest published release checked on 2026-04-21:

- tag: `v2.0.0`
- title: `v2.0.0 - truth-first starter portfolio baseline`
- published at: `2025-08-17T14:30:22Z`
- release body now points readers back to the maintained README, docs hub, portfolio matrix, proof matrix, and app gallery

## Versioned Policy

The canonical metadata policy lives in:

- [github-distribution-policy.json](./github-distribution-policy.json)

Validate it locally with:

```bash
python3 Scripts/validate-github-distribution-policy.py Documentation/github-distribution-policy.json
bash Scripts/validate-github-distribution-surface.sh
```

Sync the live About box and topics with:

```bash
bash Scripts/sync-github-distribution.sh
```

## Distribution Rules

- GitHub description must describe the repo as a starter-portfolio system, not generic hype
- topics must reflect the maintained SwiftUI starter portfolio and package surfaces
- homepage can keep pointing to the README until a real external docs site exists
- README, About box, docs hub, and proof surfaces must tell the same story
- release titles and release bodies must stay truth-first
- issue templates and PR template must ask for public-claim or proof impact when relevant
- GitHub-hosted workflows should stay enabled and truthful on `master`
- standalone iOS proof should be represented by a real hosted workflow, not only by local maintainer claims
- live About box and topics should be derivable from the versioned policy file
- historical release surfaces should be corrected when they materially misrepresent the current repo story

## First Links For New Visitors

- [README](../README.md)
- [Documentation Hub](README.md)
- [Quick Start](Guides/QuickStart.md)
- [Portfolio Matrix](Portfolio-Matrix.md)
- [Proof Matrix](Proof-Matrix.md)
- [App Gallery](App-Gallery.md)
- [PROJECT_STATUS](../PROJECT_STATUS.md)
- [SUPPORT](../SUPPORT.md)
- [SECURITY](../SECURITY.md)
- [CONTRIBUTING](../CONTRIBUTING.md)
- [GitHub Sponsors](https://github.com/sponsors/muhittincamdali)

## Drift Checklist

Check these when positioning, maturity, or media posture changes:

- GitHub description
- GitHub topics
- README opening story
- [Documentation/README.md](README.md)
- [PROJECT_STATUS.md](../PROJECT_STATUS.md)
- [SUPPORT.md](../SUPPORT.md)
- [SECURITY.md](../SECURITY.md)
- [CONTRIBUTING.md](../CONTRIBUTING.md)
- [.github/pull_request_template.md](../.github/pull_request_template.md)
- [.github/ISSUE_TEMPLATE/bug_report.yml](../.github/ISSUE_TEMPLATE/bug_report.yml)
- [.github/ISSUE_TEMPLATE/feature_request.yml](../.github/ISSUE_TEMPLATE/feature_request.yml)
- [.github/workflows/release.yml](../.github/workflows/release.yml)

## Presentation Rule

The GitHub surface should be treated as a maintained product surface, not decorative repository packaging.

That means:

- hero, docs routing, examples routing, proof routing, and About box must stay aligned
- release titles and notes must not say more than the repo can currently prove
- community and security routes must be easy to find from the first screen
