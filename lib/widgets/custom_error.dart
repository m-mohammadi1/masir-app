import '/core/copy/masir_copy.dart';
import 'package:flutter/material.dart';
import '/core/theme/masir_style.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: MasirSpace.xxl),
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
            const SizedBox(height: MasirSpace.lg),
            CustomText.bodyStrong(
              message,
              textAlign: TextAlign.center,
              color: textColor ?? c.ink,
            ),
            if (retry != null) ...[
              const SizedBox(height: MasirSpace.xl),
              CustomButton(title: MasirCopy.retry, onTap: retry, width: 260),
            ],
          ],
        ),
      ),
    );
  }
}
