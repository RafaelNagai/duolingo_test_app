---
name: stack-conventions
description: Tech stack, architecture, and coding conventions for this Flutter project. Use when writing, reviewing, or modifying any Dart/Flutter code.
user-invocable: false
---

## Project: duolingo_test_app

### Tech Stack

- **Language**: Dart (SDK ^3.11.0)
- **Framework**: Flutter with Material Design
- **State Management & DI**: Riverpod
- **Navigation**: GoRouter
- **Testing**: flutter_test + Mockito (mocks for all external dependencies)
- **Local Database**: None

---

## Architecture: Clean Architecture

Every feature follows 3 strict layers. Dependencies only point inward.

```
feature/
├── data/
│   ├── datasources/        # API calls, external services
│   ├── models/             # JSON serialization (DTOs)
│   └── repositories/       # Implements domain repository interfaces
├── domain/
│   ├── entities/           # Pure Dart classes, no Flutter, no JSON
│   ├── repositories/       # Abstract interfaces (contracts)
│   └── usecases/           # Single responsibility, one per action
└── presentation/
    ├── pages/              # One file per route/screen
    ├── components/         # Widgets used only within this feature
    ├── providers/          # Riverpod providers (StateNotifier, AsyncNotifier)
    └── state/              # State classes (immutable, copyWith)
```

### Core (shared across features)
```
lib/core/
├── components/             # Widgets reused across 2+ features
│   └── buttons/
│       └── base_button.dart
├── errors/                 # Failure classes, AppException
├── usecases/               # Base UseCase interface
└── utils/                  # Pure helper functions
```

### Component Placement Rule
> **Shared across features?** → `lib/core/components/`
> **Used only inside one feature?** → `lib/features/<feature>/presentation/components/`

---

## SOLID Principles

- **S** — Each class/file has one reason to change. UseCases do ONE thing.
- **O** — Extend behavior via new classes, not by modifying existing ones.
- **L** — Repository implementations are substitutable for their abstract interfaces.
- **I** — Keep interfaces (repository contracts) focused; don't bundle unrelated methods.
- **D** — High-level layers (domain, presentation) depend on abstractions, never on concrete data/datasource classes.

---

## Riverpod Conventions

- Providers live in `presentation/providers/`
- Use `AsyncNotifier` for async state, `Notifier` for sync state
- Inject UseCases via `ref.watch()` — never instantiate directly in widgets
- Provider naming: `<feature><Action>Provider` e.g. `imageDescriptionProvider`
- State classes are immutable with `copyWith`

```dart
// Provider example
final imageDescriptionProvider =
    AsyncNotifierProvider<ImageDescriptionNotifier, ImageDescriptionState>(
  ImageDescriptionNotifier.new,
);

class ImageDescriptionNotifier extends AsyncNotifier<ImageDescriptionState> {
  @override
  Future<ImageDescriptionState> build() async => ImageDescriptionState.initial();
}
```

---

## GoRouter Conventions

- All routes defined in a single `lib/core/router/app_router.dart`
- Route paths are constants in a `Routes` class
- Use `context.go()` for navigation, never `Navigator.push`

---

## Testing Conventions

- **Every UseCase** must have a unit test
- **Every Repository** must have a unit test with mocked datasource
- **Every Notifier** must have a unit test with mocked UseCases
- Use `Mockito` — generate mocks with `@GenerateMocks([MyClass])`
- Mock all external dependencies; never hit real APIs in tests
- Test file mirrors the source path: `lib/features/x/y.dart` → `test/features/x/y_test.dart`

```dart
// Test structure example
void main() {
  late MockImageDescriptionRepository mockRepo;
  late GetImageDescriptionUseCase useCase;

  setUp(() {
    mockRepo = MockImageDescriptionRepository();
    useCase = GetImageDescriptionUseCase(mockRepo);
  });

  test('should return description when repository succeeds', () async {
    // arrange
    when(mockRepo.getDescription(any)).thenAnswer((_) async => Right(tDescription));
    // act
    final result = await useCase(tParams);
    // assert
    expect(result, Right(tDescription));
    verify(mockRepo.getDescription(tParams));
  });
}
```

---

## General Dart Conventions

- Always use `const` constructors where possible
- Prefer `final` fields; avoid mutable state in widgets
- No `StatefulWidget` unless absolutely necessary — use Riverpod instead
- Use named parameters for constructors with more than 1 param
- Entities and state classes must have `==` and `hashCode` (use `Equatable` or manual)
- No `dynamic` types — always be explicit
- Avoid `print()` — use `debugPrint()` only during development
