import '/widgets/custom_text.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import '/core/theme/theme_context.dart';
import '/widgets/chunky_box.dart';

/// Neutral chunky button: white face, hairline border, soft lip.
class CustomOutlineButton extends StatelessWidget {
  static Container? initCustomButton;
  final double? height, width, buttonSizeRadius;
  final String? title;
  final bool loading;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final bool enable;
  final TextStyle? textStyle;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final double topPadding;
  final Widget? icon;
  final Color? borderColor;

  const CustomOutlineButton({
    super.key,
    this.title,
    this.loading = false,
    this.textStyle,
    this.height = 52,
    this.width,
    this.onTap,
    this.backgroundColor,
    this.buttonSizeRadius,
    this.enable = true,
    this.child,
    this.padding,
    this.topPadding = 0,
    this.icon,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if (loading) {
      return SizedBox(
        height: height,
        width: width ?? size.width,
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: const CustomLoading(),
          ),
        ),
      );
    }
    final c = context.colors;
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: ChunkyBox(
        width: width,
        height: height,
        radius: buttonSizeRadius ?? 16,
        fill: backgroundColor ?? c.surface,
        edge: c.lip,
        borderColor: borderColor ?? c.border,
        alignment: Alignment.center,
        onTap: !enable ? null : onTap,
        child:
            child ??
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[icon!, const SizedBox(width: 8)],
                CustomText(
                  title ?? "",
                  fontSize: textStyle?.fontSize ?? 15,
                  color: textStyle?.color,
                  fontWeight: textStyle?.fontWeight ?? FontWeight.w800,
                ),
              ],
            ),
      ),
    );
  }
}
