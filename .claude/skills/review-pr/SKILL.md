---
name: review-pr
description: Review a pull request for this Flutter project
disable-model-invocation: true
context: fork
agent: Explore
allowed-tools: Bash(git *), Read, Grep, Glob
---

## PR Review for duolingo_test_app

Current diff:
!`git diff main...HEAD`

Changed files:
!`git diff main...HEAD --name-only`

---

Perform a thorough code review of the changes above. Use the checklist below and report every issue found, grouped by severity: **Critical**, **Warning**, **Suggestion**.

---

## Review Checklist

### Architecture & Clean Architecture
- [ ] Do data layer classes (models, datasources, repository impls) import from domain or presentation? If yes → **Critical**
- [ ] Do domain entities import Flutter or external packages? If yes → **Critical**
- [ ] Does each UseCase do exactly one thing? Multi-responsibility UseCases → **Warning**
- [ ] Are repository interfaces (contracts) in the domain layer, not data layer?

### SOLID Principles
- [ ] **S**: Is any class doing more than one job?
- [ ] **O**: Is existing behavior changed by modifying a class instead of extending it?
- [ ] **D**: Do high-level layers (presentation, domain) depend on concrete implementations instead of abstractions?

### Riverpod
- [ ] Are providers placed in `presentation/providers/`?
- [ ] Is `ref.read()` used inside build methods? Should be `ref.watch()` → **Warning**
- [ ] Are UseCases injected via providers, not instantiated directly in widgets?
- [ ] Is state immutable with `copyWith`?

### Component Placement
- [ ] Is a new widget used across multiple features but placed inside a single feature? Move to `core/components/` → **Warning**
- [ ] Is a widget placed in `core/components/` but only used in one feature? Move to `feature/presentation/components/` → **Suggestion**

### GoRouter
- [ ] Are new routes defined in `lib/core/router/app_router.dart`?
- [ ] Is `Navigator.push` used instead of `context.go()`? → **Warning**

### Testing
- [ ] Does every new UseCase have a unit test? Missing → **Critical**
- [ ] Does every new Repository implementation have a unit test? Missing → **Warning**
- [ ] Does every new Notifier have a unit test? Missing → **Warning**
- [ ] Are all external dependencies mocked? Real API calls in tests → **Critical**
- [ ] Do test files mirror the source file path?

### Dart Code Quality
- [ ] Are `const` constructors missing where they could be used? → **Suggestion**
- [ ] Is `dynamic` used anywhere? → **Warning**
- [ ] Is `print()` used instead of `debugPrint()`? → **Warning**
- [ ] Are `StatefulWidget`s used where Riverpod could handle the state? → **Suggestion**
- [ ] Do entities/state classes implement `==` and `hashCode`?

### Security & Safety
- [ ] Are secrets, API keys, or tokens hardcoded? → **Critical**
- [ ] Is user input validated before being sent to services?

---

## Output Format

For each issue found:

```
[SEVERITY] File: path/to/file.dart (line X)
Problem: <what's wrong>
Fix: <what to do instead>
```

End with a **Summary** of: total critical, warnings, suggestions, and overall approval status (Approved / Approved with suggestions / Request Changes).
