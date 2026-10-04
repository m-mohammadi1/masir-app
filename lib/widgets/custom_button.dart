import '../core/helper/assets.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';

import 'chunky_box.dart';
import 'custom_text.dart';
import '/core/theme/masir_colors.dart';
import '/core/theme/theme_context.dart';

enum ButtonVariant { primary, secondary, ghost, danger, success }

/// Darkens [c] for the solid lip under a chunky control.
Color edgeOf(Color c, {double amount = 0.18}) {
  final hsl = HSLColor.fromColor(c);
  return hsl
      .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
      .toColor();
}

class CustomButton extends StatelessWidget {
  static Container? initCustomButton;
  final double? height, width, buttonSizeRadius;
  final String? title;
  final bool loading;
  final bool addIcon;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? enableColor, borderColor;
  final bool enable;
  final TextStyle? textStyle;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final double topPadding;
  final ButtonVariant variant;

  const CustomButton({
    super.key,
    this.title,
    this.loading = false,
    this.addIcon = false,
    this.textStyle,
    this.height = 52,
    this.width,
    this.onTap,
    this.backgroundColor,
    this.enableColor,
    this.borderColor,
    this.buttonSizeRadius,
    this.enable = true,
    this.child,
    this.padding,
    this.topPadding = 0,
    this.variant = ButtonVariant.primary,
  });

  ({Color fill, Color edge, Color text, Color? border}) _palette(
    MasirColors c,
  ) {
    if (!enable) {
      final fill = enableColor ?? c.border100;
      return (
        fill: fill,
        edge: enableColor != null ? edgeOf(fill, amount: 0.1) : c.lip,
        text: enableColor != null ? c.white : c.locked,
        border: null,
      );
    }
    if (backgroundColor != null) {
      return (
        fill: backgroundColor!,
        edge: edgeOf(backgroundColor!),
        text: c.white,
        border: null,
      );
    }
    switch (variant) {
      case ButtonVariant.primary:
        return (fill: c.primary, edge: c.primaryEdge, text: c.onPrimary, border: null);
      case ButtonVariant.secondary:
        return (fill: c.primaryTint, edge: c.primary.withValues(alpha: 0.35), text: c.primary, border: null);
      case ButtonVariant.ghost:
        return (fill: c.surface, edge: c.lip, text: c.primary, border: c.border);
      case ButtonVariant.danger:
        return (fill: c.coral, edge: c.coralEdge, text: c.white, border: null);
      case ButtonVariant.success:
        return (fill: c.green, edge: c.greenEdge, text: c.white, border: null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = width ?? MediaQuery.sizeOf(context).width;
    if (loading) {
      return SizedBox(
        height: height,
        width: w,
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: backgroundColor == null
                ? const CustomLoading()
                : SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      color: backgroundColor,
                      strokeWidth: 2.5,
                    ),
                  ),
          ),
        ),
      );
    }

    final p = _palette(context.colors);
    final h = height ?? 52;
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: ChunkyBox(
        width: w,
        height: h,
        radius: buttonSizeRadius ?? 16,
        fill: p.fill,
        edge: p.edge,
        borderColor: p.border,
        alignment: Alignment.center,
        onTap: !enable ? null : onTap,
        child:
            child ??
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (addIcon) ...[
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: CustomImage(assets: Assets.add, color: p.text),
                    ),
                  ),
                  4.w,
                ],
                CustomText(
                  "${title?.tr}",
                  style: textStyle,
                  color: p.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ],
            ),
      ),
    );
  }
}
