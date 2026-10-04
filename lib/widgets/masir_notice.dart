import 'package:flutter/material.dart';

import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/widgets/custom_text.dart';

enum NoticeTone { success, error, info }

/// The one medium-sized popup card used for every feedback message: errors,
/// successes, hints and celebrations. Not too small, not a full dialog.
class MasirNotice extends StatelessWidget {
  static const double maxWidth = 440;
  static const double minHeight = 64;

  final String title;
  final String? message;
  final NoticeTone tone;
  final IconData? icon;

  const MasirNotice({
    super.key,
    required this.title,
    this.message,
    this.tone = NoticeTone.info,
    this.icon,
  });

  IconData get _icon =>
      icon ??
      switch (tone) {
        NoticeTone.success => Icons.check_rounded,
        NoticeTone.error => Icons.priority_high_rounded,
        NoticeTone.info => Icons.info_outline_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (fill, accent) = switch (tone) {
      NoticeTone.success => (c.green100, c.greenEdge),
      NoticeTone.error => (c.coralSoft, c.coral),
      NoticeTone.info => (c.primaryTint, c.primary),
    };
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final hasMessage = message != null && message!.isNotEmpty;

    // heightFactor keeps it from stretching to the full height it is given.
    return Center(
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: maxWidth,
          minHeight: minHeight,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: MasirSpace.lg,
            vertical: MasirSpace.md,
          ),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(MasirRadius.card),
            // A thicker bottom edge gives the same chunky lip as buttons.
            border: Border(
              top: BorderSide(color: accent, width: Chunky.border),
              left: BorderSide(color: accent, width: Chunky.border),
              right: BorderSide(color: accent, width: Chunky.border),
              bottom: BorderSide(color: accent, width: Chunky.lip + 1),
            ),
          ),
          child: Row(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: reduce ? 1 : 0, end: 1),
                duration: const Duration(milliseconds: 700),
                curve: Curves.elasticOut,
                builder: (context, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_icon, color: c.white, size: 22),
                ),
              ),
              const SizedBox(width: MasirSpace.md),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText.bodyStrong(
                      title,
                      color: c.ink,
                      maxLines: hasMessage ? 2 : 3,
                    ),
                    if (hasMessage) ...[
                      const SizedBox(height: 2),
                      CustomText.caption(
                        message!,
                        color: c.inkMuted,
                        maxLines: 2,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
