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
  static const double _width = 42;
  static const double _height = 24;
  static const double _thumbSize = 18;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        widget.isLoading
            ? const Padding(padding: EdgeInsets.all(12), child: CustomLoading())
            : Directionality(
                // Keep the "on = thumb slides right" convention regardless
                // of the surrounding RTL layout, matching the old Switch.
                textDirection: TextDirection.ltr,
                child: GestureDetector(
                  onTap: () => widget.onChange(!widget.active),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    width: _width,
                    height: _height,
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(_height),
                      color: widget.active
                          ? AppColor.primaryTint
                          : AppColor.surface,
                      border: Border.all(
                        color: widget.active
                            ? AppColor.primary
                            : AppColor.border,
                        width: 1.2,
                      ),
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      alignment: widget.active
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: _thumbSize,
                        height: _thumbSize,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.active
                              ? AppColor.primary
                              : AppColor.inkFaint,
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.ink.withValues(alpha: 0.22),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: widget.icon != null
                            ? IconTheme(
                                data: IconThemeData(
                                  size: 12,
                                  color: AppColor.surface,
                                ),
                                child: widget.icon!,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
        8.w,
        CustomText(widget.title, fontSize: 12, fontWeight: FontWeight.w500),
      ],
    );
  }
}
