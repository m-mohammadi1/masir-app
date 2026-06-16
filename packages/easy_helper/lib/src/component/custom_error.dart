import 'package:flutter/material.dart';

class CustomError extends StatelessWidget {
  final String message;
  final Color? textColor;
  static Color? initialColor;
  final VoidCallback? retry;

  const CustomError({
    super.key,
    required this.message,
    this.textColor,
    this.retry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: textColor ?? CustomError.initialColor,
              ),
            ),
            if (retry != null)
              TextButton(
                child: const Text("حاول مرة أخرى"),
                onPressed: retry,
              ),
          ],
        ),
      ),
    );
  }
}
