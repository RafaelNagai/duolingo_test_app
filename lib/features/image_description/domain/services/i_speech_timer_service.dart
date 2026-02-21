import 'package:duolingo_test_app/features/image_description/domain/entities/speech_timer_entity.dart';

abstract class ISpeechTimerService {
  /// Emits remaining seconds from [timer.durationSeconds] down to 0, once per second.
  Stream<int> countdown(SpeechTimerEntity timer);
}
