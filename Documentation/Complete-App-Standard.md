# Complete App Standard

Last updated: 2026-04-19

## Purpose

This document defines when a template in `iOSAppTemplates` is allowed to be called a `complete app`.

It exists to stop three failures:

- marketing drift
- proof drift
- category confusion

## Canonical Product Goal

`iOSAppTemplates` should become the canonical SwiftUI app starter system with `20 provable complete product apps`.

That means:

- breadth matters
- proof matters more

## Product Model

The target portfolio uses `5` lanes and `20` complete apps.

### Lane 1: Commerce

1. E-Commerce Store
2. Marketplace
3. Food Delivery
4. Booking & Reservations

### Lane 2: Social & Media

5. Social Media
6. Messaging / Community
7. Creator / Short Video
8. News / Editorial

### Lane 3: Productivity & Work

9. Productivity / Tasks
10. Notes / Knowledge Base
11. Team Collaboration
12. CRM / Admin Companion

### Lane 4: Personal Utility

13. Finance / Budgeting
14. Health / Fitness
15. Education / Learning
16. Travel Planner

### Lane 5: Premium 2026 Growth Themes

17. AI Assistant
18. Creator Studio / Photo-Video Editor
19. Subscription Lifestyle / Habit Tracker
20. Privacy / Secure Vault

The market rationale for this list lives in [World-Class-20-App-Strategy-2026-04-19.md](./World-Class-20-App-Strategy-2026-04-19.md).

## Complete App Definition

A template may only be labeled `complete` if every required condition below is true.

### Required Product Conditions

- it has a clear product name
- it has a defined lane and category
- it has a documented target user
- it has a documented `best for / not for` decision surface

### Required Repository Conditions

- it has a real standalone root or an explicit generator output path
- it has a per-app README
- it has a richer example surface
- it has a documented feature list
- it has a documented screen list
- it has a documented platform baseline

### Required Proof Conditions

- it has a documented start/run path
- it has a per-app proof page
- it has a per-app media page
- it has explicit generic iOS-targeted standalone build proof
- it has at least one real screenshot
- it is included in the gallery surface
- it builds successfully in CI or release validation

### Strongly Recommended Conditions

- short demo clip
- smoke test
- generator coverage
- visual asset in README/showcase/gallery
- hosted standalone iOS CI proof

## Labeling Rules

Use these labels consistently.

### `Complete App`

Use only when every required condition is satisfied.

### `Standalone Root`

Use when `Templates/` contains a manifest-valid app package entry and source shell, but complete-app proof is still incomplete.

### `Template Family`

Use when the category and architecture exist, but standalone packaging or product proof is incomplete.

### `Example Surface`

Use when `Examples/` contains a meaningful inspection or learning path, but not a complete app package.

### `Preview`

Use when the concept is visible but not fully navigable or fully packaged.

### `Module`

Use when a reusable source package exists without full app packaging.

## Current Reality Gap

The repository contains meaningful template-family material and nine standalone roots, but it does not yet have `20 complete apps` or equal standalone iOS proof depth across that surface.

That gap must be closed before public claims expand.

## Expansion Rules

Do not expand to `20` by cloning the same shell with new labels.

Expand with:

- one shared architecture spine
- one shared design language
- one shared generator contract
- one shared proof model
- one gallery and documentation system
- distinct domain and interaction models per app

## Execution Sequence

### Sprint 1: Canonical English Surface

- root README stays English and product-grade
- docs hub and portfolio router stay English and canonical
- examples hub remains a router, not a claim dump

### Sprint 2: First 8 Complete Apps

1. E-Commerce Store
2. Social Media
3. Productivity / Tasks
4. Finance / Budgeting
5. Education / Learning
6. Food Delivery
7. Travel Planner
8. AI Assistant

Each of these must satisfy the complete-app definition before the next wave expands.

### Sprint 3: Showcase And Media System

- real gallery cards
- per-app gallery entries
- per-app media truth
- README and docs surfaces that route to those assets

### Sprint 4: Expansion To 20

Only after the first wave is provable and stable.

## Exit Criteria For Public Claim

The repository may publicly say `20 complete apps` only when:

- `20` standalone roots exist
- `20` richer examples exist
- `20` gallery cards exist
- `20` per-app proof surfaces exist
- `20` per-app media surfaces exist
- the generator and docs system can route users to all `20`
- CI/release truth remains green

## Final Rule

Count only what can be routed, built, shown, and defended.
