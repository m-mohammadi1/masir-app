import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import '/core/helper/assets.dart';
import '/core/helper/go_back.dart';
import '/core/theme/theme_context.dart';
import '/widgets/chunky_box.dart';
import '/core/theme/masir_style.dart';

class CustomBackButton extends StatelessWidget {
  final Function? backAction;

  const CustomBackButton({super.key, this.backAction});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: ChunkyBox(
        width: 40,
        height: 40,
        radius: MasirRadius.row,
        fill: c.surface,
        edge: c.lip,
        borderColor: c.border,
        alignment: Alignment.center,
        onTap: () {
          if (backAction != null) {
            backAction!();
          } else {
            goBack(context);
          }
        },
        child: SizedBox(
          width: 16,
          height: 16,
          child: CustomImage(assets: Assets.arrowBack, color: c.ink),
        ),
      ),
    );
  }
}
