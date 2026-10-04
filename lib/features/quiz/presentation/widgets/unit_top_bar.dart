import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';

import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/widgets/custom_text.dart';
import '/widgets/progress_pill.dart';

/// Top of every unit screen: a close "X", a thick progress pill and (optionally)
/// the unit title with a trailing teacher icon. Progress is 0..100.
class UnitTopBar extends StatelessWidget {
  final String title;
  final VoidCallback onClose;
  final num? progress;
  final Widget? trailing;

  const UnitTopBar({
    super.key,
    required this.title,
    required this.onClose,
    this.progress,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        16.h,
        Row(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onClose,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: c.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: c.border, width: Chunky.border),
                ),
                child: Icon(Icons.close_rounded, color: c.inkMuted, size: 22),
              ),
            ),
            14.w,
            Expanded(
              child: progress != null
                  ? ProgressPill(value: progress!, height: 14, color: c.green)
                  : CustomText(
                      title,
                      fontSize: MasirText.titleSize,
                      fontWeight: FontWeight.w800,
                      maxLines: 1,
                    ),
            ),
            if (trailing != null) ...[10.w, trailing!],
          ],
        ),
        if (progress != null && title.isNotEmpty) ...[
          14.h,
          CustomText(
            title,
            fontSize: MasirText.titleSize,
            fontWeight: FontWeight.w800,
            maxLines: 2,
          ),
        ],
      ],
    );
  }
}

/// Bottom action area shared by unit screens, lifted above the content by a
/// top border like a sheet.
class UnitBottomBar extends StatelessWidget {
  final Widget child;

  const UnitBottomBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(top: 14, bottom: 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: c.border, width: Chunky.border)),
      ),
      child: child,
    );
  }
}
