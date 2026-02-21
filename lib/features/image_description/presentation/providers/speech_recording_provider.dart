import 'dart:async';

import 'package:duolingo_test_app/features/image_description/data/services/audio_recorder_service.dart';
import 'package:duolingo_test_app/features/image_description/domain/entities/speech_timer_entity.dart';
import 'package:duolingo_test_app/features/image_description/domain/services/i_audio_recorder_service.dart';
import 'package:duolingo_test_app/features/image_description/domain/services/i_speech_timer_service.dart';
import 'package:duolingo_test_app/features/image_description/data/services/isolate_timer_service.dart';
import 'package:duolingo_test_app/features/image_description/presentation/state/speech_recording_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioRecorderServiceProvider = Provider<IAudioRecorderService>(
  (_) => AudioRecorderService(),
);

final speechTimerServiceProvider = Provider<ISpeechTimerService>(
  (_) => IsolateTimerService(),
);

class SpeechRecordingNotifier extends Notifier<SpeechRecordingState> {
  StreamSubscription<int>? _timerSub;

  @override
  SpeechRecordingState build() {
    ref.onDispose(() async {
      _timerSub?.cancel();
      await ref.read(audioRecorderServiceProvider).dispose();
    });
    return const SpeechRecordingState();
  }

  Future<void> toggle({
    required void Function(Uint8List) onResult,
    int durationSeconds = 30,
  }) async {
    if (state.isListening) {
      await _stop(onResult: onResult);
      return;
    }
    await _start(onResult: onResult, durationSeconds: durationSeconds);
  }

  Future<void> _start({
    required void Function(Uint8List) onResult,
    required int durationSeconds,
  }) async {
    final recorder = ref.read(audioRecorderServiceProvider);

    final permitted = await recorder.hasPermission();
    if (!permitted) {
      debugPrint('[SpeechRecording] microphone permission denied');
      return;
    }

    await recorder.start();

    state = SpeechRecordingState(
      isListening: true,
      remainingSeconds: durationSeconds,
      totalSeconds: durationSeconds,
    );

    final timerService = ref.read(speechTimerServiceProvider);
    _timerSub = timerService
        .countdown(SpeechTimerEntity(durationSeconds: durationSeconds))
        .listen((remaining) async {
      state = state.copyWith(remainingSeconds: remaining);
      if (remaining == 0) {
        final bytes = await recorder.stop();
        onResult(bytes);
        _cleanup();
      }
    });
  }

  Future<void> _stop({required void Function(Uint8List) onResult}) async {
    _timerSub?.cancel();
    _timerSub = null;
    final bytes = await ref.read(audioRecorderServiceProvider).stop();
    onResult(bytes);
    _cleanup();
  }

  void _cleanup() {
    _timerSub?.cancel();
    _timerSub = null;
    state = const SpeechRecordingState();
  }
}

final speechRecordingProvider =
    NotifierProvider<SpeechRecordingNotifier, SpeechRecordingState>(
  SpeechRecordingNotifier.new,
);
