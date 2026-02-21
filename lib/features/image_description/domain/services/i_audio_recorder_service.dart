import 'dart:typed_data';

abstract class IAudioRecorderService {
  Future<bool> hasPermission();
  Future<void> start();

  /// Stops recording and returns the captured audio as raw PCM bytes.
  Future<Uint8List> stop();

  Future<void> dispose();
}
