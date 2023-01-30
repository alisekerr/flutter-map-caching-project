import 'package:flutter/material.dart';

class OptionalHelperWidget extends StatelessWidget {
  const OptionalHelperWidget({
    super.key,
    required this.widget,
    required this.snackBarText,
    required this.titleText,
  });
  final Widget widget;
  final String snackBarText;
  final String titleText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(titleText),
        const Spacer(),
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  snackBarText,
                ),
                duration: const Duration(seconds: 8),
              ),
            );
          },
          icon: const Icon(Icons.help_outline),
        ),
        widget
      ],
    );
  }
}
