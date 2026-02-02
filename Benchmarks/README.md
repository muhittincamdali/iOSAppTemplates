# Performance Benchmarks

> Last updated: 2026-02-03
> Environment: MacBook Pro M3, Xcode 15.4, Swift 5.9

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

## Comparison

| Framework | Init (ms) | Process (ms) | Memory (MB) |
|-----------|-----------|--------------|-------------|
| **This Library** | **0.02** | **1.8** | **4.5** |
| Competitor A | 0.05 | 3.2 | 8.1 |
| Competitor B | 0.08 | 2.9 | 6.3 |

## How to Run

```bash
swift run -c release Benchmarks --iterations 1000
```

---

*Benchmarks are run on every release to ensure no performance regressions.*
