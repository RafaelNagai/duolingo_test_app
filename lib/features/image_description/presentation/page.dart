import 'package:duolingo_test_app/core/components/buttons/base_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void pressedButton() {
    debugPrint('Button pressed');
  }

  void pressedBackButton() {
    debugPrint('Back button pressed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page')),
      body: Column(
        children: [
          BaseButton(label: 'Click me', callback: pressedButton),
          BaseButton(label: 'Click me', callback: pressedBackButton),
        ],
      ),
    );
  }
}
