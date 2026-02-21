import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:duolingo_test_app/core/components/buttons/base_button.dart';
import 'package:duolingo_test_app/features/image_description/domain/entities/evaluation_result.dart';
import 'package:duolingo_test_app/features/image_description/presentation/components/info_card.dart';
import 'package:duolingo_test_app/features/image_description/presentation/components/score_ring.dart';

class ResultsPage extends StatelessWidget {
  final EvaluationResult result;

  const ResultsPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Results',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF3C3C3C),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Your Score',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF999999),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              ScoreRing(score: result.score),
              const SizedBox(height: 32),
              InfoCard(title: 'What you said', body: result.transcript),
              const SizedBox(height: 16),
              InfoCard(title: 'Tip', body: result.suggestion),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: BaseButton(
                  label: 'Try Again',
                  callback: () => context.go('/exam'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
