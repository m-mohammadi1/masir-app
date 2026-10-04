import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import '/core/theme/theme_context.dart';
import '/widgets/masir_motion.dart';
import '/core/theme/masir_style.dart';

Future showCustomModal({
  required BuildContext context,
  Function(dynamic)? callBack,
  required Widget child,
  bool isDismissible = true,
  bool? isScrollControlled,
  double? scrollControlDisabledMaxHeightRatio,
}) async {
  showModalBottomSheet(
    context: context,
    sheetAnimationStyle: MasirMotion.sheet,
    isDismissible: isDismissible,
    isScrollControlled: isScrollControlled ?? false,

    builder: (context) {
      return ClosableKeyBoard(
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(MasirRadius.hero),
            ),
            border: Border(
              top: BorderSide(color: context.colors.border, width: 2),
              left: BorderSide(color: context.colors.border, width: 2),
              right: BorderSide(color: context.colors.border, width: 2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(MasirRadius.card),
                    color: context.colors.border,
                  ),
                  height: 5,
                  width: 48,
                  margin: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              child,
            ],
          ),
        ),
      );
    },
  ).then((value) {
    if (callBack == null) return;
    callBack(value);
  });
}
