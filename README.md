# duolingo_test_app

An Android-only Flutter app that simulates a Duolingo-style speaking exercise. A random image is shown, the user has 30 seconds to describe it aloud, and Gemini AI evaluates the response — returning a score (0–100), a transcript, and an improvement suggestion.

## User Flow

```
App opens → Random image shown → User taps mic → 30s recording
→ Audio + image sent to Gemini AI
→ Results screen: score + transcript + improvement tip
```

## Prerequisites

Before you begin, make sure you have the following installed:

| Tool | Version | Notes |
|------|---------|-------|
| [Flutter SDK](https://docs.flutter.dev/get-started/install) | ≥ 3.11.0 | Run `flutter doctor` to verify |
| [Android Studio](https://developer.android.com/studio) | Any recent | Includes Android SDK |
| Android device or emulator | Android 6.0+ | iOS/web not supported |
| [Google AI Studio](https://aistudio.google.com) account | — | To generate a free Gemini API key |

## Setup

### 1. Clone the repository

```bash
git clone <repo-url>
cd duolingo_test_app
```

### 2. Create the environment file

The app reads the Gemini API key from a `.env` file at the project root.

```bash
cp .env.example .env   # if an example exists, otherwise create it manually
```

Open `.env` and set your key:

```env
GEMINI_API_KEY=your_gemini_api_key_here
```

To get a key: go to [Google AI Studio](https://aistudio.google.com), sign in, and click **Get API key**.

> The `.env` file is bundled as a Flutter asset — do **not** add it to `.gitignore` removal unless you rotate the key first.

### 3. Install Flutter dependencies

```bash
flutter pub get
```

### 4. Run code generation

The project uses `riverpod_generator` to generate Riverpod provider boilerplate. Run this once after cloning (and again any time you add or change a provider):

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 5. Connect an Android device or start an emulator

**Physical device:** Enable Developer Options and USB Debugging on your Android phone, then connect via USB.

**Emulator:** Open Android Studio → Device Manager → start an AVD.

Verify your device is detected:

```bash
flutter devices
```

### 6. Run the app

```bash
flutter run
```

To target a specific device when multiple are connected:

```bash
flutter run -d <device_id>
```

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `GEMINI_API_KEY` | Yes | Gemini API key used to evaluate audio + image responses |

## Project Structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── components/         # Shared UI components (used across 2+ features)
│   ├── config/             # App-wide configuration (reads .env)
│   └── router/             # GoRouter navigation setup
└── features/
    └── image_description/
        ├── domain/
        │   ├── entities/   # Pure Dart data classes
        │   └── services/   # Abstract service interfaces
        ├── data/
        │   └── services/   # Concrete implementations (audio, Gemini, timer)
        └── presentation/
            ├── pages/      # Screens (exam page, results page)
            ├── components/ # Feature-specific widgets
            ├── providers/  # Riverpod NotifierProviders
            └── state/      # Immutable state classes
```

Architecture follows **Clean Architecture** — domain layer has no Flutter dependencies; data and presentation layers implement and consume it respectively.

## Key Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management and dependency injection |
| `go_router` | Declarative navigation |
| `record` | Audio capture (AAC-LC, 64 kbps) |
| `google_generative_ai` | Gemini AI evaluation |
| `flutter_dotenv` | Load API keys from `.env` at runtime |
| `riverpod_generator` + `build_runner` | Code generation for Riverpod providers |
