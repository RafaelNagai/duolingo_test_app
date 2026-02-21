class EvaluationResult {
  final int score;
  final String transcript;
  final String suggestion;

  const EvaluationResult({
    required this.score,
    required this.transcript,
    required this.suggestion,
  });

  EvaluationResult copyWith({
    int? score,
    String? transcript,
    String? suggestion,
  }) {
    return EvaluationResult(
      score: score ?? this.score,
      transcript: transcript ?? this.transcript,
      suggestion: suggestion ?? this.suggestion,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EvaluationResult &&
          runtimeType == other.runtimeType &&
          score == other.score &&
          transcript == other.transcript &&
          suggestion == other.suggestion;

  @override
  int get hashCode => score.hashCode ^ transcript.hashCode ^ suggestion.hashCode;
}
