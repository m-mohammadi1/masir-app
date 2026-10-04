import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/widgets/chunky_box.dart';
import 'package:mohammad/widgets/custom_text.dart';
import '/core/theme/theme_context.dart';

/// Chunky answer tile. Unselected = surface + lip; selected = primary tint with
/// a primary border and edge.
class OptionWidget extends StatelessWidget {
  final String title;
  final bool selected;
  final bool readOnly;
  final VoidCallback? onTap;

  const OptionWidget({
    super.key,
    required this.title,
    this.selected = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Opacity(
      opacity: readOnly ? 0.6 : 1,
      child: ChunkyBox(
        fill: selected ? c.primaryTint : c.surface,
        edge: selected ? c.primaryEdge : c.lip,
        borderColor: selected ? c.primary : c.border,
        height: 56,
        width: context.appSize.width,
        alignment: Alignment.center,
        onTap: readOnly ? null : onTap,
        child: CustomText.headline(title, color: selected ? c.primary : c.ink),
      ),
    );
  }
}
