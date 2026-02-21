import 'dart:async';
import 'dart:typed_data';

import 'package:duolingo_test_app/features/image_description/domain/services/i_audio_recorder_service.dart';
import 'package:record/record.dart';

class AudioRecorderService implements IAudioRecorderService {
  final _recorder = AudioRecorder();
  StreamSubscription<Uint8List>? _chunkSub;
  final _bytesBuilder = BytesBuilder(copy: false);

  @override
  Future<bool> hasPermission() => _recorder.hasPermission();

  @override
  Future<void> start() async {
    _bytesBuilder.clear();
    final stream = await _recorder.startStream(
      const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 64000),
    );
    _chunkSub = stream.listen(_bytesBuilder.add);
  }

  @override
  Future<Uint8List> stop() async {
    await _recorder.stop();
    await _chunkSub?.cancel();
    _chunkSub = null;
    return _bytesBuilder.takeBytes();
  }

  @override
  Future<void> dispose() async {
    await _chunkSub?.cancel();
    _chunkSub = null;
    await _recorder.dispose();
  }
}
