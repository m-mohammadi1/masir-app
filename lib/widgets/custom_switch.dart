import '/widgets/custom_text.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';

import '../core/helper/custom_colors.dart';

class CustomSwitch extends StatefulWidget {
  final bool active;
  final bool isLoading;
  final String title;
  final Icon? icon;
  final Function(bool) onChange;

  const CustomSwitch({
    super.key,
    required this.isLoading,
    required this.active,
    required this.title,
    required this.onChange,
    this.icon,
  });

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        widget.isLoading
            ? const Padding(padding: EdgeInsets.all(12), child: CustomLoading())
            : Transform.scale(
                scale: .70,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Switch(
                    thumbColor: !widget.active
                        ? WidgetStateProperty.all(AppColor.white)
                        : null,
                    thumbIcon: WidgetStateProperty.all(widget.icon),
                    value: widget.active,
                    inactiveTrackColor: AppColor.secondaryDisable,
                    activeTrackColor: AppColor.primary,
                    trackOutlineColor: widget.active
                        ? null
                        : WidgetStateProperty.all(AppColor.secondaryDisable),
                    onChanged: (value) {
                      widget.onChange(value);
                    },
                  ),
                ),
              ),
        CustomText(widget.title, fontSize: 12, fontWeight: FontWeight.w500),
      ],
    );
  }
}
