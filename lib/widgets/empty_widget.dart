import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import '/core/theme/theme_context.dart';
import '/widgets/custom_text.dart';

class EmptyWidget extends StatelessWidget {
  final String text;
  final String description;
  final IconData icon;

  const EmptyWidget({
    super.key,
    required this.text,
    required this.description,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: colors.inkFaint),
            16.h,
            CustomText(text, fontWeight: FontWeight.w500, color: colors.ink),
            4.h,
            CustomText(
              description,
              fontSize: 12,
              color: colors.text92,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
