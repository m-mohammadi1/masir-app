import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import '/widgets/custom_text.dart';
import '/core/theme/theme_context.dart';

class CustomCheckBox extends StatelessWidget {
  final bool value;
  final String? hint;
  final Function(bool) onChange;

  const CustomCheckBox({
    super.key,
    this.hint,
    required this.value,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OnClick(
          onTap: () => onChange(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: value ? context.colors.primary : context.colors.surface,
              border: Border(
                top: BorderSide(
                  color: value ? context.colors.primary : context.colors.border,
                  width: 2,
                ),
                left: BorderSide(
                  color: value ? context.colors.primary : context.colors.border,
                  width: 2,
                ),
                right: BorderSide(
                  color: value ? context.colors.primary : context.colors.border,
                  width: 2,
                ),
                bottom: BorderSide(
                  color: value ? context.colors.primaryEdge : context.colors.lip,
                  width: 4,
                ),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: value
                ? Icon(Icons.done_rounded, color: context.colors.onPrimary, size: 16)
                : SizedBox(),
          ),
        ),
        if (hint != null) ...[8.w, CustomText(hint!, fontSize: 13)],
      ],
    );
  }
}
