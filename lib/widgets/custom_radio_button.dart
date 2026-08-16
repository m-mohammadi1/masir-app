import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import '/core/helper/custom_colors.dart';
import '/widgets/custom_text.dart';

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
                      color: AppColor.surface,
                      border: Border.all(
                        color: i == selected
                            ? AppColor.primary
                            : AppColor.border,
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
