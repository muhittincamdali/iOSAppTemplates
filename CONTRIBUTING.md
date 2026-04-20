# Contributing to iOSAppTemplates

`iOSAppTemplates` is trying to become a truthful SwiftUI starter portfolio, not a template dump. Contributions are welcome, but they need to preserve proof discipline first.

## Before You Start

- Read [README.md](README.md), [Documentation/README.md](Documentation/README.md), and [Examples/README.md](Examples/README.md).
- Read [Documentation/Complete-App-Standard.md](Documentation/Complete-App-Standard.md).
- Read [Documentation/Portfolio-Matrix.md](Documentation/Portfolio-Matrix.md) and [Documentation/Proof-Matrix.md](Documentation/Proof-Matrix.md).
- Decide whether your change affects:
  - the root package graph
  - a template family under `Sources/`
  - a standalone app root under `Templates/`
  - an example router under `Examples/`
  - documentation, proof, media, or workflow surfaces

If you add a public claim, add the proof path too.

## What We Accept

- bug fixes in active package targets or standalone roots
- new app-pack surfaces that follow the complete-app contract
- documentation and proof corrections
- validator improvements that reduce drift
- visual-system improvements backed by tracked assets

## What We Usually Reject

- fake metrics, fake coverage, fake App Store posture, or fake release claims
- new abstraction layers without a concrete need
- broad rewrites that mix product, docs, and workflow changes without a staged rollout
- new public promises without build, proof, or media routing

## Local Workflow

```bash
swift build -c release
swift test
```

If your change touches public repo surfaces, also run:

```bash
bash Scripts/validate-portfolio-surface.sh
bash Scripts/validate-app-proof-surfaces.sh
bash Scripts/validate-app-media-surfaces.sh
```

If your change touches visual surfaces, also run:

```bash
bash Scripts/validate-readme-visual-assets.sh
bash Scripts/validate-app-gallery-cards.sh
bash Scripts/validate-app-preview-boards.sh
```

If your change touches standalone roots, also run:

```bash
bash Scripts/validate-standalone-template-roots.sh
bash Scripts/validate-standalone-root-lockfiles.sh
bash Scripts/validate-template-root-readmes.sh
bash Scripts/validate-standalone-ios-builds.sh
```

## Pull Request Rules

- One pull request should solve one problem.
- Describe the lane, app pack, or public surface you changed.
- State whether any public claim changed.
- State whether proof, media, gallery, distribution, or release wording changed.
- List the validation commands you ran.
- Update docs when the public surface changes.
- Do not leave placeholders, dead links, or fabricated roadmap language behind.

## Commit Style

Use conventional commits:

- `feat:`
- `fix:`
- `docs:`
- `refactor:`
- `test:`
- `chore:`

## Checklist

- [ ] `swift build -c release` passed
- [ ] `swift test` passed
- [ ] relevant validators passed
- [ ] public claims still match current proof
- [ ] related docs were updated
- [ ] no placeholder or broken-link drift was introduced

## Security

Do not open public issues for vulnerabilities. Use [SECURITY.md](SECURITY.md).

## License

By contributing, you agree that your contributions are licensed under the [MIT License](LICENSE).
