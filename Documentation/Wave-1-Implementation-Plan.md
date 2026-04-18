# Wave 1 Implementation Plan

Last updated: 2026-04-19

## Purpose

This document turns the first `8` target apps into a concrete implementation contract.

Use it to answer:

- which apps get built first
- what each app must ship inside the repository
- what already exists
- what still blocks a `complete app` label

## Wave 1 Apps

1. E-Commerce Store
2. Social Media
3. Productivity / Tasks
4. Finance / Budgeting
5. Education / Learning
6. Food Delivery
7. Travel Planner
8. AI Assistant

## Required App Pack

Every Wave 1 app must ship with the same minimum pack:

- template family
- standalone root
- richer example
- per-app README
- per-app proof page
- per-app media page
- gallery entry
- feature list
- screen list
- target user
- `best for / not for` decision surface
- documented run path
- documented validation path

See the exact contract in [Wave-1-App-Pack-Spec.md](./Wave-1-App-Pack-Spec.md).

## Current State

### 1. E-Commerce Store

- Current lane: Commerce
- Current assets:
  - standalone root
  - template family
  - app proof surface
  - app media surface
  - template-root README
- Current maturity: strongest Wave 1 candidate
- Main blockers:
  - richer example
  - screenshot/video proof
  - explicit iOS-targeted standalone build proof

### 2. Social Media

- Current lane: Social
- Current assets:
  - standalone root
  - template family
  - richer example
  - app proof surface
  - app media surface
  - template-root README
- Current maturity: strongest overall Wave 1 candidate
- Main blockers:
  - screenshot/video proof
  - explicit iOS-targeted standalone build proof
  - stronger product README depth

### 3. Productivity / Tasks

- Current lane: Productivity
- Current assets:
  - standalone root
  - template family
  - richer example
  - app proof surface
  - app media surface
- Current maturity: active Wave 1 build candidate
- Main blockers:
  - screenshot/video proof
  - explicit iOS-targeted standalone build proof

### 4. Finance / Budgeting

- Current lane: Finance
- Current assets:
  - standalone root
  - template family
  - richer example
  - app proof surface
  - app media surface
- Current maturity: active Wave 1 build candidate
- Main blockers:
  - screenshot/video proof
  - explicit iOS-targeted standalone build proof

### 5. Education / Learning

- Current lane: Education
- Current assets:
  - template family
  - generator lane
- Current maturity: not yet productized
- Main blockers:
  - standalone root
  - richer example
  - README
  - proof page
  - media page

### 6. Food Delivery

- Current lane: Food Delivery
- Current assets:
  - template family
  - generator lane
- Current maturity: not yet productized
- Main blockers:
  - standalone root
  - richer example
  - README
  - proof page
  - media page

### 7. Travel Planner

- Current lane: Travel
- Current assets:
  - template family
  - generator lane
- Current maturity: not yet productized
- Main blockers:
  - standalone root
  - richer example
  - README
  - proof page
  - media page

### 8. AI Assistant

- Current lane: AI
- Current assets:
  - AI template family
- Current maturity: concept visible, product package missing
- Main blockers:
  - canonical AI lane identity
  - standalone root
  - richer example
  - README
  - proof page
  - media page

## Build Order

The repository should not implement the Wave 1 apps alphabetically.

Use this order:

1. Social Media
2. E-Commerce Store
3. Productivity / Tasks
4. Finance / Budgeting
5. Education / Learning
6. Food Delivery
7. Travel Planner
8. AI Assistant

Reason:

- Social and Commerce already have the strongest packaging base
- Productivity and Finance have the strongest practical demand
- AI is strategically important, but the lane needs a clearer product identity before it should count as complete

## Delivery Rule

Do not mark a Wave 1 app as complete because the lane exists in `Sources/`.

Mark it complete only when the full app pack exists.
