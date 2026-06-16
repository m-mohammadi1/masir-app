import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import '/widgets/custom_text.dart';

class IntroWidget extends StatelessWidget {
  final String title, description, image;
  final int index;

  const IntroWidget({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 63),
          child: CustomImage(assets: "assets/svg/intro/$image.svg"),
        ),

        Container(
          margin: EdgeInsets.only(top: context.appSize.height * .52),
          child: Column(
            children: [
              CustomText(title, fontSize: 24, fontWeight: FontWeight.w700),
              8.h,
              CustomText(
                description,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
