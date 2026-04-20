# Release Process

This repository should not treat a version tag as enough evidence for a trustworthy release.

## Release Gate

Before pushing a release tag, run:

```bash
swift build -c release
swift test
bash Scripts/validate-portfolio-surface.sh
bash Scripts/validate-app-proof-surfaces.sh
bash Scripts/validate-app-media-surfaces.sh
bash Scripts/validate-app-gallery-cards.sh
bash Scripts/validate-app-preview-boards.sh
bash Scripts/validate-readme-visual-assets.sh
```

If the release changes standalone app-root truth, also run:

```bash
bash Scripts/validate-standalone-template-roots.sh
bash Scripts/validate-standalone-root-lockfiles.sh
bash Scripts/validate-template-root-readmes.sh
bash Scripts/validate-standalone-ios-builds.sh
```

Also verify the hosted standalone iOS route exists and stays versioned:

```bash
bash Scripts/validate-standalone-ios-proof-surface.sh
bash Scripts/validate-github-distribution-surface.sh
```

## What A Release Must Not Claim

Do not publish a release title or release body that claims:

- full parity across all `20` app packs
- runtime screenshots are published when they are not
- demo clips are published when they are not
- hosted standalone iOS CI proof exists when it does not
- compliance or enterprise posture that is not explicitly proven

## Current Release Truth

As of 2026-04-21, the latest published release title is stale and overclaims the repository story.

Use these documents as the canonical truth surface until the next numbered release resets the release body:

- [README.md](../README.md)
- [PROJECT_STATUS.md](../PROJECT_STATUS.md)
- [GitHub-Distribution.md](GitHub-Distribution.md)
- [Portfolio-Matrix.md](Portfolio-Matrix.md)
- [Proof-Matrix.md](Proof-Matrix.md)
- [App-Gallery.md](App-Gallery.md)
- [../.github/workflows/standalone-ios-proof.yml](../.github/workflows/standalone-ios-proof.yml)

## Tagging

Release tags are expected in the format:

```text
v1.2.3
```

Pre-release identifiers such as `alpha`, `beta`, or `rc` remain valid and are treated as prereleases by automation.

## Changelog Discipline

- summarize only real user-visible or maintainer-visible changes
- do not claim complete-app parity before the proof surface says so
- keep `Unreleased` current before tagging
- update release wording if public trust, distribution, or media posture changed

## Workflow Note

The tagged release workflow builds the package and creates a GitHub release body from the current changelog plus repo links.

That workflow is a publication mechanism, not the proof itself.

The proof lives in the maintained documentation, validators, and current repo status pages.
