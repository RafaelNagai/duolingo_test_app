class SpeechTimerEntity {
  final int durationSeconds;

  const SpeechTimerEntity({required this.durationSeconds});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpeechTimerEntity &&
          runtimeType == other.runtimeType &&
          durationSeconds == other.durationSeconds;

  @override
  int get hashCode => durationSeconds.hashCode;
}
