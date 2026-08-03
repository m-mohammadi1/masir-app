import '/core/helper/custom_colors.dart';
import '/core/helper/helper_extension.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_text.dart';

class CustomTextField extends StatelessWidget {
  final String? hint, labelText;
  final Widget? leftWidget;
  final TextEditingController controller;
  final Function(String)? onChanged, onSubmitted;
  final Function()? onTap;
  final TextInputAction action;
  final TextInputType? type;
  final bool isPassword;
  final int line;
  final int? maxLength;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final double textFieldRadius;
  final Color? borderColor, backgroundColor;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? currentFocus, nextFocus;
  final Widget? prefixIcon, suffixIcon;
  final BoxConstraints? suffixBoxConstraints, prefixBoxConstraints;
  final TextDirection? textDirection;
  final String? errorMessage;
  final bool? enabled;
  final bool isRequired;
  final double? hintSize;
  final EdgeInsets? contentPadding;

  const CustomTextField({
    super.key,
    required this.controller,
    this.isPassword = false,
    this.isRequired = false,
    this.onChanged,
    this.onSubmitted,
    this.contentPadding,
    this.hint,
    this.onTap,
    this.hintSize,
    this.labelText,
    this.leftWidget,
    this.line = 1,
    this.maxLength,
    this.textFieldRadius = 12,
    this.style,
    this.labelStyle,
    this.errorMessage,
    this.hintStyle,
    this.action = TextInputAction.next,
    this.inputFormatters,
    this.borderColor,
    this.backgroundColor,
    this.currentFocus,
    this.nextFocus,
    this.type,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixBoxConstraints,
    this.prefixBoxConstraints,
    this.textDirection,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (labelText != null)
          Row(
            children: [
              CustomText(
                labelText!,
                fontWeight: FontWeight.w500,
                style: labelStyle,
              ),

              4.w,
              if (isRequired)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: CustomText("*", color: Colors.red),
                ),
              if (leftWidget != null) ...[Spacer(), leftWidget!],
            ],
          ),
        8.h,
        OnClick(
          onTap: () {
            if (onTap != null) {
              onTap!();
            }
          },
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: TextField(
              textInputAction: action,
              inputFormatters: inputFormatters,
              textDirection: textDirection,
              maxLines: line,
              onChanged: onChanged,
              enabled: (enabled == true && onTap == null),
              decoration: InputDecoration(
                fillColor: backgroundColor ?? AppColor.surface,
                hintTextDirection: textDirection,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,

                filled: true,
                // focusColor: Colors.transparent,
                contentPadding: contentPadding ?? const EdgeInsets.all(14),
                counterText: "",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: !errorMessage.isNullOrEmpty
                        ? AppColor.error
                        : borderColor ?? AppColor.primary,
                    width: 1.2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: !errorMessage.isNullOrEmpty
                        ? AppColor.error
                        : borderColor ?? AppColor.border,
                    width: 1.2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: !errorMessage.isNullOrEmpty
                        ? AppColor.error
                        : borderColor ?? AppColor.border,
                    width: 1.2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                suffixIconConstraints: suffixBoxConstraints,
                prefixIconConstraints: prefixBoxConstraints,
                hintText: hint,
                hintStyle:
                    hintStyle ??
                    customTextStyle(
                      color: AppColor.text92,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
              ),
              style:
                  style ??
                  customTextStyle(
                    color: AppColor.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
              controller: controller,
              keyboardType: type,
              maxLength: maxLength,
              obscureText: isPassword,
              obscuringCharacter: "*",
              focusNode: currentFocus,
              autofocus: false,
              onSubmitted: (value) {
                if (nextFocus != null) {
                  FocusScope.of(context).requestFocus(nextFocus);
                  Future.delayed(Duration(milliseconds: 100), () {
                    Scrollable.ensureVisible(
                      context,
                      duration: Duration(milliseconds: 300),
                      alignment: 0.3,
                    );
                  });
                }
              },
            ),
          ),
        ),
        if (!errorMessage.isNullOrEmpty) ...[
          4.h,
          CustomText(errorMessage!, color: AppColor.error),
        ],
      ],
    );
  }
}
