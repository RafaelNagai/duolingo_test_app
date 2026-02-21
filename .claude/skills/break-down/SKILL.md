---
name: break-down
description: Break down a new feature or task into implementation steps for this Flutter project. Use when planning a new feature, screen, or significant change.
allowed-tools: Read, Grep, Glob
---

## Feature Planning — duolingo_test_app

Analyze the feature described by the user and produce a complete, ordered implementation plan following the project's Clean Architecture and conventions.

---

## Step 1 — Understand the Feature

Before planning, clarify:
- What does the user see/do? (UI behavior)
- What data is needed and where does it come from? (API, local, static)
- What state needs to be managed? (loading, error, success)
- Are there any navigation flows? (GoRouter)

If any of these are unclear, ask before proceeding.

---

## Step 2 — Identify Reuse

Search the existing codebase for:
- Similar features already implemented (for patterns to follow)
- Existing `core/components` that can be reused
- Existing providers, UseCases, or entities that overlap

---

## Step 3 — Produce the Implementation Plan

Output a numbered task list ordered from innermost layer (data) to outermost (presentation). Each task must be independently completable and testable.

### Template Structure

```
Feature: <feature name>
Folder: lib/features/<feature-name>/

── Domain Layer ──────────────────────────────────
[ ] 1. Create entity: <name>Entity (lib/features/<feature>/domain/entities/)
        Fields: ...
        Note: Pure Dart, no Flutter imports, implement == and hashCode

[ ] 2. Create repository interface: I<Name>Repository (lib/features/<feature>/domain/repositories/)
        Methods: Future<Either<Failure, Entity>> <methodName>(params)

[ ] 3. Create use case: <Action><Feature>UseCase (lib/features/<feature>/domain/usecases/)
        Input: <params>
        Output: Future<Either<Failure, <Entity>>>

── Data Layer ────────────────────────────────────
[ ] 4. Create model: <Name>Model extends <Name>Entity (lib/features/<feature>/data/models/)
        Includes: fromJson / toJson

[ ] 5. Create datasource: <Name>RemoteDatasource (lib/features/<feature>/data/datasources/)
        Methods: mirrors repository interface

[ ] 6. Create repository impl: <Name>RepositoryImpl (lib/features/<feature>/data/repositories/)
        Implements: I<Name>Repository
        Depends on: <Name>RemoteDatasource (injected)

── Presentation Layer ────────────────────────────
[ ] 7. Create state: <Feature>State (lib/features/<feature>/presentation/state/)
        Fields: status, data, errorMessage
        Immutable with copyWith

[ ] 8. Create provider: <feature>Provider (lib/features/<feature>/presentation/providers/)
        Type: AsyncNotifierProvider<Notifier, State>
        Injects: <Action><Feature>UseCase via ref.watch

[ ] 9. Create page: <Feature>Page (lib/features/<feature>/presentation/pages/)
        Uses: ref.watch(<feature>Provider)
        Handles: loading / error / success states

[ ] 10. Create components (if needed):
        Shared across features → lib/core/components/<name>/
        Feature-only → lib/features/<feature>/presentation/components/

[ ] 11. Register route in lib/core/router/app_router.dart
        Path: /<feature-path>
        Widget: <Feature>Page

── Tests ─────────────────────────────────────────
[ ] 12. Unit test: <Action><Feature>UseCase (test/features/<feature>/domain/)
        Mock: I<Name>Repository
        Cases: success, failure

[ ] 13. Unit test: <Name>RepositoryImpl (test/features/<feature>/data/)
        Mock: <Name>RemoteDatasource
        Cases: success, network error, parse error

[ ] 14. Unit test: <Feature>Notifier (test/features/<feature>/presentation/)
        Mock: <Action><Feature>UseCase
        Cases: initial state, loading, success, error
```

---

## Step 4 — Surface Edge Cases & Risks

List any potential issues:
- Network failure handling (what does the UI show?)
- Empty states (no data returned)
- Authentication required?
- Component placement decisions (core vs feature)
- Any existing code that needs to change to accommodate this feature

---

## Step 5 — Estimate Complexity

| Area | Files to create | Complexity |
|---|---|---|
| Domain | entity + repo interface + usecase | Low |
| Data | model + datasource + repo impl | Medium |
| Presentation | state + provider + page + components | Medium/High |
| Tests | 3+ test files | Medium |

Flag if any part is unclear or needs a decision from the user before starting.
