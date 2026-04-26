# AIAssistantExample

Generated from `Documentation/app-surface-catalog.json`.

`AIAssistantExample` is the richer example surface for the `AI` lane.

## Product Shape

- conversation shell
- prompt and response surface
- assistant suggestion cards
- starter tool action surface

## Best For / Not For

### Best for

- teams that want a second inspection route beyond `AIAssistantApp`
- readers who want to inspect the `AI Assistant` flow in a more product-like format

### Not for

- teams expecting a separate runnable Xcode project
- readers who expect deeper multi-screen runtime scenario proof than the current published media set

## Current Truth

- this example is an inspection surface, not a separate shipped app project
- the canonical standalone package-entry path lives under `Templates/`
- canonical package validation remains the root-level `swift build` and `swift test` flow

## Start Here

```bash
open AIAssistantWorkflowExample.swift
open ../../Templates/AIAssistantApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Canonical References

- [AIAssistantApp Proof](../../Documentation/App-Proofs/AIAssistantApp.md)
- [AIAssistantApp Media](../../Documentation/App-Media/AIAssistantApp.md)
- [Wave 1 Plan](../../Documentation/Wave-1-Implementation-Plan.md)
