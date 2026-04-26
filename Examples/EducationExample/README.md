# EducationExample

Generated from `Documentation/app-surface-catalog.json`.

`EducationExample` is the richer example surface for the `Education` lane.

## Product Shape

- course overview shell
- lesson routing
- assignment and quiz models
- study-session summary

## Best For / Not For

### Best for

- teams that want a second inspection route beyond `EducationApp`
- readers who want to inspect the `Education / Learning` flow in a more product-like format

### Not for

- teams expecting a separate runnable Xcode project
- readers who expect deeper multi-screen runtime scenario proof than the current published media set

## Current Truth

- this example is an inspection surface, not a separate shipped app project
- the canonical standalone package-entry path lives under `Templates/`
- canonical package validation remains the root-level `swift build` and `swift test` flow

## Start Here

```bash
open EducationCourseExample.swift
open ../../Templates/EducationApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Canonical References

- [EducationApp Proof](../../Documentation/App-Proofs/EducationApp.md)
- [EducationApp Media](../../Documentation/App-Media/EducationApp.md)
- [Wave 1 Plan](../../Documentation/Wave-1-Implementation-Plan.md)
