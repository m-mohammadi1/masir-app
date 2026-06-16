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
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: value ? AppColor.primary : Colors.transparent,
              border: !value ? Border.all(color: AppColor.text92 , width: 1.2) : null,
              borderRadius: BorderRadius.circular(6),
            ),
            child: value
                ? Icon(Icons.done, color: Colors.white, size: 16)
                : SizedBox(),
          ),
        ),
        if(hint !=null)...[
          4.w,
          CustomText(hint!, fontSize: 12,)
        ]
      ],
    );
  }
}
