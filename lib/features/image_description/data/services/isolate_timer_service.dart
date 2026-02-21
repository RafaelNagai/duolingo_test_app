import 'dart:isolate';

import 'package:duolingo_test_app/features/image_description/domain/entities/speech_timer_entity.dart';
import 'package:duolingo_test_app/features/image_description/domain/services/i_speech_timer_service.dart';

class IsolateTimerService implements ISpeechTimerService {
  @override
  Stream<int> countdown(SpeechTimerEntity timer) async* {
    final receivePort = ReceivePort();
    await Isolate.spawn(
      _timerEntryPoint,
      [receivePort.sendPort, timer.durationSeconds],
    );

    try {
      await for (final tick in receivePort.cast<int>()) {
        yield tick;
        if (tick == 0) break;
      }
    } finally {
      receivePort.close();
    }
  }

  /// Top-level function required by [Isolate.spawn].
  /// Sends remaining seconds from [args[1]] down to 0 via [args[0]].
  static Future<void> _timerEntryPoint(List<dynamic> args) async {
    final sendPort = args[0] as SendPort;
    final seconds = args[1] as int;

    for (int i = seconds; i >= 0; i--) {
      sendPort.send(i);
      if (i > 0) await Future.delayed(const Duration(seconds: 1));
    }
  }
}
