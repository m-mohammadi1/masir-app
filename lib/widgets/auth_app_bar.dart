import 'package:flutter/material.dart';
import 'custom_text.dart';

class AuthAppBar extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const AuthAppBar({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // OnClick(
        //   onTap: onTap ?? () => CustomNavigator.pop(),
        //   child: Container(
        //     width: 44,
        //     height: 44,
        //     decoration: BoxDecoration(
        //       border: Border.all(width: 1.5, color: context.colors.border),
        //       shape: BoxShape.circle,
        //       color: context.colors.background,
        //     ),
        //     child: Padding(
        //       padding: const EdgeInsets.all(12),
        //       // child: SvgPicture.asset(
        //       //   Assets.,
        //       //   colorFilter: ColorFilter.mode(
        //       //     context.colors.iconColor,
        //       //     BlendMode.srcIn,
        //       //   ),
        //       // ),
        //     ),
        //   ),
        // ),
        CustomText.headline(title),
        // 44.w,
      ],
    );
  }
}
