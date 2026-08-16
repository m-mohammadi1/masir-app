import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/widgets/custom_text.dart';
import '/core/theme/theme_context.dart';

class OptionWidget extends StatelessWidget {
  final String title;
  final bool selected;
  final bool readOnly;
  final VoidCallback? onTap;

  const OptionWidget({
    super.key,
    required this.title,
    this.selected = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OnClick(
      onTap: readOnly ? null : onTap,
      child: Opacity(
        opacity: readOnly ? 0.5 : 1,
        child: Container(
          height: 48,
          width: context.appSize.width,
          decoration: BoxDecoration(
            color: selected ? context.colors.primary : null,
            borderRadius: BorderRadius.circular(8),
            border: selected
                ? null
                : Border.all(color: context.colors.primary, width: 1.5),
          ),
          child: Center(
            child: CustomText(
              title,
              fontWeight: FontWeight.bold,
              color: selected ? context.colors.white : context.colors.primary,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
