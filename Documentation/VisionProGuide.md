# Vision Pro Development Guide

This page summarizes the current scope of the visionOS surface in the repository.

## Current Truth

Canonical source for the visionOS lane:

- `Sources/VisionOSTemplates/SpatialSocialTemplate.swift`

This surface is currently useful as:
- a spatial UI reference
- an immersive-scene example
- visionOS-specific view composition
- a sample model and reducer surface

It does not automatically prove:
- a ship-ready Vision Pro app
- App Store proof
- a hardware-validated production release

## What Exists Today

Key types in the source file:

- `SpatialSocialTemplate`
- `SpatialSocialView`
- `SpatialSocialFeature`
- `SpatialSidebarView`
- `SpatialFeedView`
- `SpatialPostCard3D`
- `SocialImmersiveView`
- `SpatialPost`
- `SpatialUser`

So the repo does contain a real spatial reference surface, but it does not satisfy the `complete app` standard by itself.

## Recommended Use

Use this lane when you want to:

- inspect visionOS APIs
- prototype a spatial social or feed experience
- study SwiftUI + RealityKit + reducer-based UI orchestration
- collect reference material for a future complete-app lane

Do not treat this lane as sufficient on its own for:

- release proof
- App Store submission
- production hardening
- hardware certification

## Minimal Inspection Flow

1. Open `Sources/VisionOSTemplates/SpatialSocialTemplate.swift`
2. Inspect the `SpatialSocialFeature` state and action structure
3. Follow the UI surface through `SpatialPostCard3D` and `SocialImmersiveView`
4. Generate separate product proof when moving the visionOS-specific UI into your own app shell

## Prerequisites

- Xcode `16+`
- a visionOS simulator or equivalent Apple platform tooling
- basic SwiftUI + RealityKit familiarity

## App Store And Distribution Note

Simply building against visionOS does not guarantee:
- UX quality
- performance
- privacy text correctness
- entitlement correctness
- distribution readiness

This area should currently be treated as a `reference lane`.

## Related Reading

1. [Architecture API](./ArchitectureAPI.md)
2. [Template Guide](./TemplateGuide.md)
3. [Complete App Standard](./Complete-App-Standard.md)
