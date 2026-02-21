---
name: debug
description: Systematically debug a Flutter/Dart bug, error, or unexpected behavior. Use when the user pastes an error, stack trace, or describes something not working.
allowed-tools: Read, Grep, Glob, Bash(flutter *, dart *)
---

## Debug Session

Investigate the problem described by the user using the following systematic process. Do not guess — read the actual code before drawing conclusions.

---

## Step 1 — Understand the Error

Identify from the user's description or stack trace:
- **Error type**: Flutter framework error / Dart exception / Riverpod error / GoRouter error / logic bug / test failure
- **Error message**: Extract the exact message
- **Stack trace origin**: Identify the first file in the project (not Flutter framework files) in the stack trace

## Step 2 — Locate the Source

Based on the error origin, read the relevant files:
- If Riverpod error → check the Provider definition, `build()` method, and how state is mutated
- If widget error → check the Widget tree, `const` usage, and parent/child data passing
- If UseCase/Repository error → trace: Presentation → UseCase → Repository → Datasource
- If GoRouter error → check `lib/core/router/app_router.dart` and route parameters
- If test failure → read the test file and the class under test side-by-side

## Step 3 — Root Cause Analysis

Answer these questions before proposing a fix:
1. **What exactly is wrong?** (one sentence)
2. **Why did it happen?** (underlying cause, not symptom)
3. **Which layer is responsible?** (data / domain / presentation / core)
4. **Does this violate any architecture rule?** (e.g., domain importing Flutter, wrong DI)

## Step 4 — Propose the Fix

- Show the minimal code change that fixes the root cause
- Do NOT refactor surrounding code unless it directly caused the bug
- If the fix requires changes in multiple files, list them in order
- If the bug reveals a missing test, note what test should be added

## Step 5 — Verify

After applying the fix, suggest how to verify it:
- Which test to run: `flutter test test/path/to/file_test.dart`
- What to check manually in the UI (if applicable)
- Whether a new unit test should be written for this case

---

## Common Flutter / Architecture Pitfalls to Check

| Symptom | Likely Cause |
|---|---|
| `ProviderScope` not found | Missing `ProviderScope` wrapping `MaterialApp` |
| State not updating UI | Using `ref.read()` in build instead of `ref.watch()` |
| `LateInitializationError` | Async data accessed before it loaded |
| Circular dependency in providers | Provider A watches Provider B which watches Provider A |
| `Navigator` mismatch | Using `Navigator.push` instead of `context.go()` with GoRouter |
| Test mock not called | Wrong argument matcher or mock not set up before `act` |
| Widget test fails on `async` | Missing `tester.pumpAndSettle()` after async action |
| Entity comparison fails | Missing `==` / `hashCode` override on entity class |
