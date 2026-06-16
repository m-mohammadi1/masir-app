import '../core/helper/assets.dart';
import '/core/helper/custom_colors.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

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

  const CustomButton({
    super.key,
    this.title,
    this.loading = false,
    this.addIcon = false,
    this.textStyle,
    this.height = 48,
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
  });

  @override
  Widget build(BuildContext context) {
    return loading
        ? SizedBox(
            height: height,
            width: width ?? MediaQuery.sizeOf(context).width,
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
                        color: backgroundColor ?? AppColor.primary,
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
                width: width ?? MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(buttonSizeRadius ?? 8),
                  color: enable
                      ? (backgroundColor ?? AppColor.primary)
                      : enableColor ?? AppColor.primary.withValues(alpha: 0.5),
                  border: enable
                      ? null
                      : Border.all(color: borderColor ?? AppColor.border),
                ),
                alignment: Alignment.center,
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
                              child: CustomImage(assets: Assets.add),
                            ),
                          ),
                          4.w,
                        ],
                        CustomText(
                          "${title?.tr}",
                          style: textStyle,
                          color: AppColor.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
              ),
            ),
          );
  }
}
