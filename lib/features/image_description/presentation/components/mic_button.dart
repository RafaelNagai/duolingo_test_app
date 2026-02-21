import 'dart:typed_data';

import 'package:duolingo_test_app/features/image_description/presentation/providers/speech_recording_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MicButton extends ConsumerWidget {
  const MicButton({
    super.key,
    required this.onResult,
    this.durationSeconds = 30,
  });

  final void Function(Uint8List bytes) onResult;
  final int durationSeconds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(speechRecordingProvider);
    final color = state.isListening
        ? const Color(0xFFFF4B4B)
        : const Color(0xFF58CC02);

    return GestureDetector(
      onTap: () => ref
          .read(speechRecordingProvider.notifier)
          .toggle(onResult: onResult, durationSeconds: durationSeconds),
      child: SizedBox(
        width: 96,
        height: 96,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (state.isListening)
              _CountdownRing(progress: state.progress, color: color),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                state.isListening ? Icons.stop_rounded : Icons.mic_rounded,
                color: Colors.white,
                size: 38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountdownRing extends StatelessWidget {
  const _CountdownRing({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      // `begin` is only used for the very first frame; subsequent rebuilds
      // animate from the current animated value to the new `end` automatically.
      tween: Tween<double>(begin: 1.0, end: progress),
      duration: const Duration(seconds: 1),
      builder: (_, value, _) => SizedBox(
        width: 96,
        height: 96,
        child: CircularProgressIndicator(
          value: value,
          strokeWidth: 4,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          backgroundColor: color.withValues(alpha: 0.2),
        ),
      ),
    );
  }
}
