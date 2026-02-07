---
name: st
description: "Shorthand Tasks (st). Use short abbreviations to request common dev tasks. Example: 'cp deck' = create page named Deck + wire Vue Router route."
---

# st — Shorthand Tasks

## Purpose

This skill defines a small shorthand language for quickly describing recurring engineering tasks.

You (the assistant) must:
- Expand the shorthand into a concrete implementation plan.
- Implement it end-to-end (code + routing + basic navigation where applicable).
- Ask 1-2 clarifying questions only when necessary.

## Syntax

General form:

`<verb> <object> [args...]`

Where:
- `verb` is a short action abbreviation.
- `object` is the thing being created/modified.
- `args` are optional page names, paths, or flags.

## Core Abbreviations

### Verbs

- `cp` — create page (Vue SFC in `frontend/app/src/pages/`)
- `cr` — create route (add to `frontend/app/src/router.ts`)
- `ln` — add navigation link (usually `frontend/app/src/components/NavBar.vue`)
- `api` — add API client wrapper (usually `frontend/app/src/api/`)
- `db` — backend data change / script

### Objects

- `deck` — a page named `Deck` (or a provided name) following the app’s deck UI pattern
- `md` — markdown editor / creator markdown tab

## Canonical Shorthand Tasks

### 1) `cp deck`

**Meaning**

Create a new page named `Deck` and wire routing so it is reachable in the app.

**Default output**

- **Page file**
  - Create: `frontend/app/src/pages/Deck.vue`
  - Minimal layout consistent with existing pages:
    - `min-h-screen bg-background`
    - `container mx-auto px-4 py-8`
    - `header` + `main`

- **Route wiring**
  - Update: `frontend/app/src/router.ts`
  - Add a route:
    - `path: '/deck'`
    - `name: 'deck'`
    - `component: () => import('./pages/Deck.vue')`

- **Navigation (optional but recommended)**
  - If user says “needs navigation”, add a link entry in `NavBar.vue`.

**Acceptance checks**

- Visiting `http://localhost:5173/deck` renders the page.
- No router errors in console.

### 2) `cp <name>`

**Meaning**

Create a page with the provided PascalCase component name and wire the route.

**Defaults**

- Page: `frontend/app/src/pages/<Name>.vue`
- Route path: kebab-case of name
  - Example: `cp MyDeck` => route `/my-deck`

### 3) `copypage "<from>" to "<to>"`

**Meaning**

Copy an existing page’s full implementation (layout + styles + behavior) into another page.

Example:

`copypage "stack" to "deck"`

**Default behavior**

- **Source page resolution**
  - Prefer an existing route name/path match.
  - Otherwise locate the Vue SFC under `frontend/app/src/pages/` (or nested pages like `frontend/app/src/pages/stackUI/Stack.vue`).

- **Target page resolution**
  - Target is a Vue SFC under `frontend/app/src/pages/` by default.
  - If target does not exist, create it.
  - If target exists, overwrite its contents.

- **What to copy**
  - Copy the entire SFC content:
    - `<template>`
    - `<script setup lang="ts">` (including all imports)
    - `<style>` blocks
  - Preserve all classes and styling exactly.

- **Required adjustments (minimal, only for correctness)**
  - Update component/page title text only if user requests.
  - Ensure imports still resolve from the new file location.
    - If the source uses relative imports that break after moving folders, fix the paths.
  - If the page references hard-coded route names/paths that must point to the target page, update those only when clearly necessary.

**Acceptance checks**

- Visiting the target route renders without console errors.
- No missing import/module errors.
- Visual layout matches the source page (same spacing, same deck behavior, same hover effects).

## Clarifying Questions (only if needed)

Ask at most 2 questions when:
- The user wants a non-default route path.
- The page should be nested under an existing section.
- The user wants auth-guard / role guard.

## Implementation Rules

- Keep changes minimal and consistent with existing code style.
- Do not add/remove comments unless the user asks.
- Prefer updating existing navigation patterns instead of inventing new UI.
