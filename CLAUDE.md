# CLAUDE.md — duolingo_test_app

## Overview

Android-only Flutter app (part of a Duolingo-style speaking test). The exercise is **image description**: a random image is shown and the user has 30 seconds to describe it in audio. After recording, the audio and image are sent to Gemini AI, which evaluates the response and returns a Duolingo-style score, a transcript of what was said, and a short improvement suggestion.

**Platform**: Android only (for now)

## User Flow

```
App opens → Random image shown → User taps mic → 30s recording
→ Audio + image sent to Gemini AI
→ Results screen: score (0–100) + transcript + improvement tip
```

## Tech Stack

| Tool | Purpose |
|------|---------|
| Flutter / Dart SDK ^3.11.0 | UI framework |
| `flutter_riverpod` ^3.2.1 | State management & DI |
| `go_router` ^17.1.0 | Navigation (declared, not yet wired) |
| `google_generative_ai` ^0.4.6 | Gemini AI evaluation |
| `record` ^6.2.0 | Audio capture (AAC-LC, 64kbps) |

No local database.

## Architecture

Clean Architecture per feature under `lib/features/<feature>/`:

```
features/<feature>/
├── domain/
│   ├── entities/        # Pure Dart data classes
│   └── services/        # Abstract service interfaces (I prefix)
├── data/
│   └── services/        # Concrete implementations
└── presentation/
    ├── pages/
    ├── components/
    ├── providers/        # Riverpod NotifierProviders
    └── state/            # Immutable state classes with copyWith()
```

Shared components (used across 2+ features) → `lib/core/components/`

## Key Patterns

- **State**: `NotifierProvider` + immutable state class with `copyWith()`
- **Services**: interface in `domain/services/`, implementation in `data/services/`
- **MicButton**: callback-based — `onResult(Uint8List bytes)` fires when recording ends
- **Timer**: Isolate-based countdown (`IsolateTimerService`) to avoid blocking UI

## Current Implementation (`image_description` feature)

- `ImageExamPage` — scaffold with image placeholder, instruction text, mic button
- `MicButton` — animated 30s countdown ring; red when recording, green when idle
- `SpeechRecordingNotifier` — manages start/stop/timer via Riverpod
- `AudioRecorderService` — streams PCM chunks, accumulates into `Uint8List`
- `IsolateTimerService` — background countdown via Dart Isolate
- Android `RECORD_AUDIO` permission declared in `AndroidManifest.xml`

## Planned Next Steps

1. **Random image** — load from bundled local assets (`assets/images/`)
2. **AI evaluation** — send `audioBytes` (AAC) + image bytes to Gemini; parse score (0–100), transcript, suggestion
3. **Results screen** — display Duolingo-style score ring, transcript card, improvement tip
4. **GoRouter** — wire navigation between exam page and results page once multi-screen flow exists

## Android Notes

- Target: Android only
- Required permission: `android.permission.RECORD_AUDIO`
- Runtime permission must be requested before recording starts (already handled by `AudioRecorderService.hasPermission()`)
