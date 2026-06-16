import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import '/core/helper/custom_colors.dart';

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
    isDismissible: isDismissible,
    isScrollControlled: isScrollControlled ?? false,

    builder: (context) {
      return ClosableKeyBoard(
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: AppColor.border.withValues(alpha: .15),
                blurRadius: 24,
                spreadRadius: 2,
                offset: Offset(0, -8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
                    color: AppColor.text92.withValues(alpha: .4),
                  ),
                  height: 4,
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
    if(callBack == null) return;
    callBack(value);
  });
}
