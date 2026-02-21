import 'dart:typed_data';

class SpeechRecordingState {
  final bool isListening;
  final int remainingSeconds;
  final int totalSeconds;

  /// Raw PCM bytes captured during the recording session.
  /// Null until the session completes or is stopped manually.
  final Uint8List? audioBytes;

  const SpeechRecordingState({
    this.isListening = false,
    this.remainingSeconds = 0,
    this.totalSeconds = 0,
    this.audioBytes,
  });

  /// 1.0 at the start, 0.0 when the timer expires.
  double get progress =>
      totalSeconds > 0 ? remainingSeconds / totalSeconds : 0.0;

  SpeechRecordingState copyWith({
    bool? isListening,
    int? remainingSeconds,
    int? totalSeconds,
    Uint8List? audioBytes,
  }) =>
      SpeechRecordingState(
        isListening: isListening ?? this.isListening,
        remainingSeconds: remainingSeconds ?? this.remainingSeconds,
        totalSeconds: totalSeconds ?? this.totalSeconds,
        audioBytes: audioBytes ?? this.audioBytes,
      );
}
