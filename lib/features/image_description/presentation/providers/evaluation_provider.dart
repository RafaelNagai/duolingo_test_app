import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:duolingo_test_app/core/config/app_config.dart';
import 'package:duolingo_test_app/features/image_description/data/services/gemini_evaluation_service.dart';
import 'package:duolingo_test_app/features/image_description/domain/entities/evaluation_result.dart';
import 'package:duolingo_test_app/features/image_description/domain/services/i_evaluation_service.dart';
import 'package:duolingo_test_app/features/image_description/presentation/state/evaluation_state.dart';

final geminiEvaluationServiceProvider = Provider<IEvaluationService>(
  (_) => GeminiEvaluationService(apiKey: AppConfig.geminiApiKey),
);

final examImageBytesProvider = FutureProvider<Uint8List>((ref) async {
  final data = await rootBundle.load('assets/images/image-1.jpg');
  return data.buffer.asUint8List();
});

class EvaluationNotifier extends Notifier<EvaluationState> {
  @override
  EvaluationState build() => const EvaluationState.idle();

  Future<EvaluationResult?> evaluate({
    required Uint8List audioBytes,
    required Uint8List imageBytes,
  }) async {
    state = state.copyWith(status: EvaluationStatus.loading);
    try {
      final result = await ref
          .read(geminiEvaluationServiceProvider)
          .evaluate(audioBytes: audioBytes, imageBytes: imageBytes);
      state = state.copyWith(status: EvaluationStatus.success, result: result);
      return result;
    } catch (e) {
      state = state.copyWith(
        status: EvaluationStatus.error,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  void reset() {
    state = const EvaluationState.idle();
  }
}

final evaluationProvider =
    NotifierProvider<EvaluationNotifier, EvaluationState>(
  EvaluationNotifier.new,
);
