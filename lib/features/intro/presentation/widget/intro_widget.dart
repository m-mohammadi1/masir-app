import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/widgets/chunky_box.dart';
import '/widgets/custom_text.dart';

/// One page of the intro: a big chunky illustration tile, a headline and a
/// short line of copy. [icon] stands in for artwork.
class IntroWidget extends StatelessWidget {
  final String title, description;
  final IconData icon;
  final Color tint;
  final Color edge;
  final Color accent;

  const IntroWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.tint,
    required this.edge,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChunkyBox(
          fill: tint,
          edge: edge,
          borderColor: accent,
          radius: MasirRadius.hero,
          width: 200,
          height: 208,
          alignment: Alignment.center,
          child: Icon(icon, size: 96, color: accent),
        ),
        40.h,
        CustomText.display(title, textAlign: TextAlign.center),
        12.h,
        CustomText.body(
          description,
          color: context.colors.inkMuted,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
