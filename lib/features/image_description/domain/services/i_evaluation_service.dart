import 'dart:typed_data';

import 'package:duolingo_test_app/features/image_description/domain/entities/evaluation_result.dart';

abstract class IEvaluationService {
  Future<EvaluationResult> evaluate({
    required Uint8List audioBytes,
    required Uint8List imageBytes,
  });
}
