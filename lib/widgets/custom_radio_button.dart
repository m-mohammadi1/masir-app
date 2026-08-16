import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import '/widgets/custom_text.dart';
import '/core/theme/theme_context.dart';

class CustomRadioButton extends StatefulWidget {
  final List<String> values;
  final int? selected;

  const CustomRadioButton({super.key, required this.values, this.selected});

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  late int? selected = widget.selected;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int i = 0; i < widget.values.length; i++)
          Expanded(
            child: OnClick(
              onTap: () {
                setState(() {
                  selected = i;
                });
              },
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.colors.surface,
                      border: Border.all(
                        color: i == selected
                            ? context.colors.primary
                            : context.colors.border,
                        width: i == selected ? 6 : 1.3,
                      ),
                    ),
                  ),
                  15.w,
                  CustomText(widget.values[i]),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
