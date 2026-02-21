import 'package:duolingo_test_app/features/image_description/domain/entities/evaluation_result.dart';

enum EvaluationStatus { idle, loading, success, error }

class EvaluationState {
  final EvaluationStatus status;
  final EvaluationResult? result;
  final String? errorMessage;

  const EvaluationState({
    this.status = EvaluationStatus.idle,
    this.result,
    this.errorMessage,
  });

  const EvaluationState.idle()
      : status = EvaluationStatus.idle,
        result = null,
        errorMessage = null;

  EvaluationState copyWith({
    EvaluationStatus? status,
    EvaluationResult? result,
    String? errorMessage,
  }) {
    return EvaluationState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
