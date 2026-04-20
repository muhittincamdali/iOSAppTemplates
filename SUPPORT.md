# Support

## Start Here

- Read [README.md](README.md)
- Read [Documentation/README.md](Documentation/README.md)
- Read [Documentation/Portfolio-Matrix.md](Documentation/Portfolio-Matrix.md)
- Read [Documentation/Proof-Matrix.md](Documentation/Proof-Matrix.md)
- Read [Documentation/App-Gallery.md](Documentation/App-Gallery.md)

## Best Channel By Need

| Need | Best path |
| --- | --- |
| bug in the root package | open a GitHub bug report and include `swift build -c release` and `swift test` output |
| bug in a standalone app root | open a GitHub bug report and include the exact `Templates/<App>/Package.swift` path plus `xcodebuild` output |
| documentation or proof drift | open a GitHub bug report and mention the exact markdown path |
| feature request | open a GitHub feature request and state the affected lane or app pack |
| security issue | use [SECURITY.md](SECURITY.md), not public issues |
| contribution expectations | read [CONTRIBUTING.md](CONTRIBUTING.md) first |
| current repo truth | read [PROJECT_STATUS.md](PROJECT_STATUS.md) |
| GitHub metadata and public distribution | read [Documentation/GitHub-Distribution.md](Documentation/GitHub-Distribution.md) |
| release expectations | read [Documentation/Release-Process.md](Documentation/Release-Process.md) |
| sponsorship or maintainer support | use [GitHub Sponsors](https://github.com/sponsors/muhittincamdali) |

## What Makes Support Faster

- exact app root, template family, script, or documentation path
- exact Swift, Xcode, and macOS version
- minimal reproduction
- whether `swift build -c release` passes
- whether `swift test` passes
- whether relevant docs validators still pass
- whether the issue is local-only or visible on GitHub

## Maintainer Validation Floor

If your change touches the public repo surface, this is the minimum local gate:

```bash
swift build -c release
swift test
bash Scripts/validate-portfolio-surface.sh
bash Scripts/validate-app-proof-surfaces.sh
bash Scripts/validate-app-media-surfaces.sh
```

Add these when relevant:

```bash
bash Scripts/validate-readme-visual-assets.sh
bash Scripts/validate-app-gallery-cards.sh
bash Scripts/validate-app-preview-boards.sh
bash Scripts/validate-standalone-ios-builds.sh
```

## Scope Note

Support is focused on:

- the active root package graph
- the current `20` standalone app roots under `Templates/`
- the tracked example router under `Examples/`
- the public proof, media, gallery, and documentation surfaces

This page routes help requests. It is not a promise that every app pack is already at equal production maturity.

## Conduct

All project interactions are governed by [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).
