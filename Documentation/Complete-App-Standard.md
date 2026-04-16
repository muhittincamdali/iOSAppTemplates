# Complete App Standard

Last updated: 2026-04-15

## Purpose

This document defines when a template in `iOSAppTemplates` is allowed to be called a `complete app`.

This standard exists to prevent marketing drift, proof drift, and category confusion.

## Canonical Product Goal

`iOSAppTemplates` should become the canonical SwiftUI app starter system with 20 provable complete product templates.

That means:

- breadth matters
- but proof matters more

## Product Lane Model

The repository should expand to 20 complete apps using 5 product lanes.

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

## Complete App Definition

A template may only be labeled `complete` if all required conditions below are true.

### Required Product Conditions

- it has a clear product name
- it has a defined category and lane
- it has a documented target user
- it has a `best for / not for` decision surface

### Required Repository Conditions

- it has a real template root or explicit generator output path
- it has a per-app README
- it has a documented feature list
- it has a documented screen list
- it has a documented platform baseline

### Required Proof Conditions

- it builds successfully in CI or local release validation
- it has at least one real screenshot
- it is included in the gallery surface
- it has a documented start/run path

### Strongly Recommended Conditions

- short demo clip
- smoke test
- generator coverage
- visual asset in README/showcase/gallery

## Labeling Rules

Use these labels consistently:

### `Complete App`

Use only when every required condition is satisfied.

### `Template Family`

Use when the category and architecture exist, but proof or per-app product packaging is incomplete.

### `Preview`

Use when the concept is visible but not yet fully navigable or fully packaged.

### `Module`

Use when a reusable source package exists without full app packaging.

## Current Reality Gap

The repository currently contains strong template-family material, but not all public `complete app` claims are fully backed by complete-app proof.

That gap must be closed before expanding public claims.

## 2026 Expansion Strategy

Do not expand to 20 apps with disconnected demos.

Expand with:

- one shared architecture spine
- one shared design language
- one shared generator contract
- one shared proof model
- one gallery and documentation system

## Sprint Sequence

### Sprint 0: Truth Reset

- remove placeholder and fake ownership values
- fix broken example links
- unify version and platform baselines
- align README claims to current proof

### Sprint 1: Canonical Onboarding

- one root README path
- one `GettingStarted` path
- one gallery-first chooser
- one examples router

### Sprint 2: Proof Reset

- remove fake benchmark comparisons
- make CI and release fail-fast
- either fix or remove broken scheduled workflows
- establish real proof surfaces

### Sprint 3: First 8 Complete Apps

- E-Commerce
- Social Media
- Productivity
- Finance
- Education
- Food Delivery
- Travel
- AI Assistant

Each of these must satisfy the complete-app definition before the next wave expands.

### Sprint 4: Visual Showcase System

- real screenshot cards
- per-app gallery entries
- product-lane chooser
- social preview system

### Sprint 5: Expand to 20

Only after the first wave is provable and stable.

## Exit Criteria For Public Claim

The repository may publicly say `20 complete apps` only when:

- 20 gallery cards exist
- 20 real app entries exist
- 20 per-app proof surfaces exist
- the generator and docs system can route users to those 20 apps
- CI/release truth remains green

## Final Rule

Count only what can be proven.

If an app cannot be routed, built, shown, and understood, it does not count.
