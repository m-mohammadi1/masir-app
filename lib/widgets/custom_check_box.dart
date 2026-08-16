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
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: value ? context.colors.primary : context.colors.surface,
              border: Border.all(
                color: value ? context.colors.primary : context.colors.border,
                width: 1.3,
              ),
              borderRadius: BorderRadius.circular(6),
              boxShadow: value
                  ? [
                      BoxShadow(
                        color: context.colors.primary.withValues(alpha: 0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: value
                ? Icon(Icons.done, color: context.colors.white, size: 16)
                : SizedBox(),
          ),
        ),
        if (hint != null) ...[4.w, CustomText(hint!, fontSize: 12)],
      ],
    );
  }
}
