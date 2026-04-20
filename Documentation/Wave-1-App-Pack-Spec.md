# Wave 1 App Pack Spec

Last updated: 2026-04-19

## Purpose

This document defines the minimum repository payload for each Wave 1 app.

It is stricter than a lane-level template and looser than a shipped App Store product.

## Required Repository Surfaces

Every Wave 1 app must have:

1. `Sources/` template family coverage
2. `Templates/<AppName>/` standalone root
3. `Examples/<AppName>Example/` richer example
4. `Templates/<AppName>/README.md`
5. `Documentation/App-Proofs/<AppName>.md`
6. `Documentation/App-Media/<AppName>.md`

## Required Product Surfaces

Every Wave 1 app README or proof page must include:

- product summary
- target user
- `best for / not for`
- feature list
- screen list
- lane identity
- run path
- validation path

## Required Proof Surfaces

Every Wave 1 app must eventually prove:

- standalone root manifest validity
- deterministic dependency resolution
- explicit generic iOS-targeted standalone build proof
- root package compatibility
- screenshot proof
- gallery routing

## Strong Upgrade Surfaces

The following are not the minimum floor, but they are required before the repository can honestly market the app as top-tier:

- short demo video
- hosted standalone iOS CI proof
- smoke test
- generator output parity
- richer example parity with standalone root

## Naming Convention

Use these names consistently:

- `EcommerceApp`
- `SocialMediaApp`
- `ProductivityApp`
- `FinanceApp`
- `EducationApp`
- `FoodDeliveryApp`
- `TravelPlannerApp`
- `AIAssistantApp`

## Rule

If an app does not have the required repository surfaces, it is still a lane or template family, not a complete app candidate.
