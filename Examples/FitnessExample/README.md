# FitnessExample

Generated from `Documentation/app-surface-catalog.json`.

`FitnessExample` is the richer example surface for the `Health / Fitness` lane.

## Product Shape

- dashboard shell
- goal and workout surface
- health metric cards
- progress summary shell

## Best For / Not For

### Best for

- teams that want a second inspection route beyond `FitnessApp`
- readers who want to inspect the `Health / Fitness` flow in a more product-like format

### Not for

- teams expecting a separate runnable Xcode project
- readers who expect deeper interactive runtime flows than the current launch-to-ready scenario set

## Current Truth

- this example is an inspection surface, not a separate shipped app project
- the canonical standalone package-entry path lives under `Templates/`
- canonical package validation remains the root-level `swift build` and `swift test` flow

## Start Here

```bash
open FitnessProgressExample.swift
open ../../Templates/FitnessApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Canonical References

- [FitnessApp Proof](../../Documentation/App-Proofs/FitnessApp.md)
- [FitnessApp Media](../../Documentation/App-Media/FitnessApp.md)
- [Wave 1 Plan](../../Documentation/Wave-1-Implementation-Plan.md)
