import 'package:flutter/material.dart';

class ScoreRing extends StatelessWidget {
  final int score;

  const ScoreRing({super.key, required this.score});

  Color _colorForScore(int score) {
    if (score >= 70) return const Color(0xFF58CC02);
    if (score >= 40) return const Color(0xFFFF9600);
    return const Color(0xFFFF4B4B);
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorForScore(score);
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 12,
            color: color,
            backgroundColor: const Color(0xFFE5E5E5),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$score',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  color: color,
                  height: 1,
                ),
              ),
              const Text(
                '/ 100',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
