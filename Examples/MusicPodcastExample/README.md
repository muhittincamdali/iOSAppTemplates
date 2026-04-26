# MusicPodcastExample

Generated from `Documentation/app-surface-catalog.json`.

`MusicPodcastExample` is the richer example surface for the `Music / Podcast` lane.

## Product Shape

- library shell
- player surface
- episode or track cards
- queue starter flow

## Best For / Not For

### Best for

- teams that want a second inspection route beyond `MusicPodcastApp`
- readers who want to inspect the `Music / Podcast` flow in a more product-like format

### Not for

- teams expecting a separate runnable Xcode project
- readers who expect deeper multi-screen runtime scenario proof than the current published media set

## Current Truth

- this example is an inspection surface, not a separate shipped app project
- the canonical standalone package-entry path lives under `Templates/`
- canonical package validation remains the root-level `swift build` and `swift test` flow

## Start Here

```bash
open ../../Templates/MusicPodcastApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Canonical References

- [MusicPodcastApp Proof](../../Documentation/App-Proofs/MusicPodcastApp.md)
- [MusicPodcastApp Media](../../Documentation/App-Media/MusicPodcastApp.md)
- [Wave 1 Plan](../../Documentation/Wave-1-Implementation-Plan.md)
