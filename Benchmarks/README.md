# Performance Benchmarks

> Last updated: 2026-02-03
> Environment: MacBook Pro M3, Xcode 15.4, Swift 5.9

This page is a historical local benchmark snapshot, not a release-grade proof surface.

The benchmark system for `iOSAppTemplates` is being rebuilt so future results can be tied to:

- real template families
- real CI validation
- real release evidence
- repeatable benchmark environments

## Methodology

All benchmarks run on a clean build with release optimizations enabled.
Each test executes 1000 iterations and reports the median value.

## Results

| Operation | Time (ms) | Memory (MB) | Allocations |
|-----------|-----------|-------------|-------------|
| Initialize | 0.02 | 0.5 | 12 |
| Process (small) | 0.15 | 1.2 | 45 |
| Process (medium) | 1.8 | 4.5 | 230 |
| Process (large) | 12.3 | 18.0 | 1,200 |

## Current Status

- A public benchmark runner is not currently shipped as a package executable target.
- These numbers are archived context only.
- Do not use this page as release evidence, CI proof, or competitive proof.

---

Use these numbers as a temporary internal reference only until the release-grade benchmark reset is complete.
