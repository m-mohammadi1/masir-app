import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import '/core/helper/custom_colors.dart';
import '/widgets/custom_text.dart';

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
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: value ? AppColor.primary : AppColor.surface,
              border: Border.all(
                color: value ? AppColor.primary : AppColor.border,
                width: 1.3,
              ),
              borderRadius: BorderRadius.circular(6),
              boxShadow: value
                  ? [
                      BoxShadow(
                        color: AppColor.primary.withValues(alpha: 0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: value
                ? Icon(Icons.done, color: AppColor.white, size: 16)
                : SizedBox(),
          ),
        ),
        if (hint != null) ...[4.w, CustomText(hint!, fontSize: 12)],
      ],
    );
  }
}
