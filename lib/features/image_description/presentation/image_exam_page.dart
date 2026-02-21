import 'package:duolingo_test_app/features/image_description/presentation/components/mic_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageExamPage extends ConsumerWidget {
  const ImageExamPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFFAFAFAF)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
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
                child: Container(
                  width: double.infinity,
                  height: 300,
                  color: const Color(0xFFF0F0F0),
                  child: const Icon(
                    Icons.image_outlined,
                    size: 72,
                    color: Color(0xFFCCCCCC),
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
                onResult: (bytes) {
                  debugPrint('Recorded ${bytes.length} bytes');
                },
              ),
              const SizedBox(height: 52),
            ],
          ),
        ),
      ),
    );
  }
}
