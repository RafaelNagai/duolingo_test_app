import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  const BaseButton({super.key, this.callback, required this.label});

  final VoidCallback? callback;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callback,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      child: Text(label),
    );
  }
}
