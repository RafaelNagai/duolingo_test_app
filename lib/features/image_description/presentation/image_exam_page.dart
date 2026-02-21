import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:duolingo_test_app/features/image_description/presentation/components/mic_button.dart';
import 'package:duolingo_test_app/features/image_description/presentation/providers/evaluation_provider.dart';
import 'package:duolingo_test_app/features/image_description/presentation/state/evaluation_state.dart';

class ImageExamPage extends ConsumerWidget {
  const ImageExamPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final evalState = ref.watch(evaluationProvider);
    final imageAsync = ref.watch(examImageBytesProvider);

    ref.listen(evaluationProvider, (_, next) {
      if (next.status == EvaluationStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'Evaluation failed'),
            backgroundColor: const Color(0xFFFF4B4B),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFFAFAFAF)),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Describe the image',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF3C3C3C),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 300,
                      child: imageAsync.when(
                        data: (bytes) => Image.memory(
                          bytes,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 300,
                        ),
                        loading: () => const ColoredBox(
                          color: Color(0xFFF0F0F0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFCCCCCC),
                            ),
                          ),
                        ),
                        error: (_, _) => const ColoredBox(
                          color: Color(0xFFF0F0F0),
                          child: Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              size: 72,
                              color: Color(0xFFCCCCCC),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Tap the mic and describe what you see',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFFAFAFAF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  MicButton(
                    onResult: (audioBytes) async {
                      final imageBytes =
                          ref.read(examImageBytesProvider).asData?.value;
                      if (imageBytes == null) return;

                      ref.read(evaluationProvider.notifier).reset();
                      final result = await ref
                          .read(evaluationProvider.notifier)
                          .evaluate(
                            audioBytes: audioBytes,
                            imageBytes: imageBytes,
                          );

                      if (result != null && context.mounted) {
                        context.go('/results', extra: result);
                      }
                    },
                  ),
                  const SizedBox(height: 52),
                ],
              ),
            ),
          ),
          if (evalState.status == EvaluationStatus.loading)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF58CC02)),
                    SizedBox(height: 16),
                    Text(
                      'Evaluating your response…',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
