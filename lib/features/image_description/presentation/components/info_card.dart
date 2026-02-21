import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String body;

  const InfoCard({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF999999),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body.isEmpty ? '—' : body,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF3C3C3C),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
