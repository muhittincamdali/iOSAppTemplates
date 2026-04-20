# Social Media Example

This folder is not a standalone shipped Xcode app project. It is a source-level example area that shows what the `SocialMediaApp.swift` surface can look like inside the repo.

## Current Truth

- No separate `.xcodeproj` or `.xcworkspace` is shipped here.
- Screenshot, UI-test, and performance proof are not attached to this folder.
- The canonical standalone package-entry roots live under `Templates/`.
- Canonical package validation remains the root-level `swift build` and `swift test` flow.

## What This Example Is Good For

- quickly inspect `SocialTemplates` and related SwiftUI surfaces
- see naming, state shape, and sample feature flow for the social lane
- document target UX direction for the future complete-app gallery

## What This Example Is Not

- release-grade social app proof
- release or distribution proof
- a real media, backend, or realtime infrastructure package

## Start Here

To validate the root package surface:

```bash
swift build
swift test
```

To open the standalone social template root:

```bash
open Templates/SocialMediaApp/Package.swift
```

## Related Docs

- [QuickStart](../../Documentation/Guides/QuickStart.md)
- [Installation](../../Documentation/Guides/Installation.md)
- [Template Guide](../../Documentation/TemplateGuide.md)
- [Complete App Standard](../../Documentation/Complete-App-Standard.md)
