import 'package:flutter/material.dart';
import '/core/helper/custom_colors.dart';

/// Shared "paper sheet" card styling used across the app.
class PaperCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;

  const PaperCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 14,
    this.onTap,
  });

  static BoxDecoration decoration({double borderRadius = 14}) {
    return BoxDecoration(
      color: AppColor.surface,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: AppColor.border, width: 1.1),
      boxShadow: [
        BoxShadow(
          color: AppColor.ink.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: decoration(borderRadius: borderRadius),
      child: child,
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: content,
      ),
    );
  }
}
