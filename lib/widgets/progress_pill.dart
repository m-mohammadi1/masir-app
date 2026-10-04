import 'package:flutter/material.dart';

import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';

/// Thick rounded progress bar that counts up from zero when first shown.
class ProgressPill extends StatelessWidget {
  /// 0..100
  final num value;
  final double height;
  final Color? color;
  final Color? trackColor;

  const ProgressPill({
    super.key,
    required this.value,
    this.height = 10,
    this.color,
    this.trackColor,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final target = (value.clamp(0, 100)) / 100;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: target),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(MasirRadius.pill),
          child: SizedBox(
            height: height,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ColoredBox(color: trackColor ?? c.border),
                ),
                Positioned.fill(
                  child: FractionallySizedBox(
                    alignment: AlignmentDirectional.centerStart,
                    widthFactor: v,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: color ?? c.primary,
                        borderRadius: BorderRadius.circular(MasirRadius.pill),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
