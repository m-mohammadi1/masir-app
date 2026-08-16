import 'package:flutter/material.dart';
import '/core/theme/theme_context.dart';
import 'custom_button.dart';

class CustomError extends StatelessWidget {
  final String message;
  final Color? textColor;
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
                color: textColor ?? context.colors.ink,
              ),
            ),
            if (retry != null) ...[
              const SizedBox(height: 16),
              CustomButton(
                title: 'تلاش مجدد',
                onTap: retry,
                width: 180,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
