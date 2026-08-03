import '/widgets/custom_text.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';

import '../core/helper/custom_colors.dart';

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
    this.height = 48,
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
    late final Size size = MediaQuery.sizeOf(context);
    return loading
        ? SizedBox(
            height: height,
            width: width ?? size.width,
            child: backgroundColor == null
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: topPadding),
                      child: const CustomLoading(),
                    ),
                  )
                : Center(
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        color: borderColor,
                        strokeWidth: 2.5,
                      ),
                    ),
                  ),
          )
        : Padding(
            padding: padding ?? EdgeInsets.zero,
            child: OnClick(
              onTap: !enable || loading ? null : onTap,
              child: Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(buttonSizeRadius ?? 14),
                  border: Border.all(
                    color: borderColor ?? AppColor.border,
                    width: 1.1,
                  ),
                  color: backgroundColor ?? AppColor.surface,
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.ink.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child:
                    child ??
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[icon!, const SizedBox(width: 8)],
                        CustomText(
                          title ?? "",
                          fontSize: textStyle?.fontSize,
                          color: textStyle?.color,
                          fontWeight: textStyle?.fontWeight,
                        ),
                      ],
                    ),
              ),
            ),
          );
  }
}
