# Testing Guide

This page describes the active test surface based on the real `iOSAppTemplates` repo state. It does not assume fake coverage percentages, mandatory UI suites, or infrastructure that is not shipped.

## Current Test Surface

Commands that are directly validated today:

```bash
swift build
swift test
```

Additional active suites:

- package smoke and unit tests
- `PerformanceBenchmarkTests`
- `SecuritySurfaceTests`

These suites are wired to the active package graph in the repo.

## What The Current Tests Prove

- active Swift package targets compile
- core model and manager contracts stay stable
- search and template discovery do not regress
- the security template surface has working smoke coverage
- the benchmark suite runs at the package level

## What They Do Not Prove Yet

- complete-app parity across all template families
- UI automation parity
- distribution readiness
- release-grade performance certification
- real device-matrix coverage

## Recommended Local Flow

```bash
open Package.swift
swift build
swift test
```

To run a specific suite:

```bash
swift test --filter PerformanceBenchmarkTests
swift test --filter SecuritySurfaceTests
```

## When To Add Tests

Tests are expected when:

- package-level behavior changes
- search, selection, or template discovery changes
- the security template surface changes
- benchmark or validation workflows change

Tests are optional when:

- the change is only a docs or router update
- the change is only copy cleanup
- the change is only inactive example narrative cleanup

## Test Quality Bar

- add a regression test when a critical contract changes
- do not write fake coverage claims
- do not imply UI tests exist if they do not
- keep README and workflow language aligned with the real suite names

## CI Alignment

Canonical CI commands are also package-surface based:

```bash
swift build
swift test
```

Security and performance workflows also run on this real package graph.

## Related Docs

- [QuickStart](QuickStart.md)
- [Installation](Installation.md)
- [Complete App Standard](../Complete-App-Standard.md)
