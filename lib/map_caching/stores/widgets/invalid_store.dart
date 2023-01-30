import 'package:flutter/material.dart';

class InvalidStore extends StatelessWidget {
  InvalidStore({super.key, required this.widget});
  Widget widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.broken_image, size: 34),
            Icon(Icons.error, size: 34),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Invalid Store',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const Text(
          """
  This store's directory structure appears to have been corrupted. You must delete the store to resolve the issue.""",
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),
        widget
      ],
    );
  }
}
