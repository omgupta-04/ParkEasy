import 'package:flutter/material.dart';

class RecognizedTextDisplay extends StatelessWidget {
  final String text;
  const RecognizedTextDisplay({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Recognized: $text",
      style: const TextStyle(fontSize: 16, color: Colors.blue),
    );
  }
}
