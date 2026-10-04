import 'package:flutter/material.dart';
import '/core/theme/theme_context.dart';
import 'custom_button.dart';
import 'custom_text.dart';

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
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c.coralSoft,
              ),
              child: Icon(Icons.wifi_off_rounded, size: 36, color: c.coral),
            ),
            const SizedBox(height: 16),
            CustomText(
              message,
              textAlign: TextAlign.center,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textColor ?? c.ink,
            ),
            if (retry != null) ...[
              const SizedBox(height: 24),
              CustomButton(title: 'تلاش مجدد', onTap: retry, width: 200),
            ],
          ],
        ),
      ),
    );
  }
}
