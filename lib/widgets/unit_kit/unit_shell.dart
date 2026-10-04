import 'package:flutter/material.dart';

import '/core/theme/masir_style.dart';
import '/features/quiz/presentation/widgets/unit_action_buttons.dart';
import '/widgets/masir_page.dart';
import '/widgets/unit_kit/unit_header.dart';
import '/widgets/unit_kit/unit_type_style.dart';

/// The frame every unit screen shares: focus bar, [UnitHeader], the content,
/// preview banner / footer slots and the sticky action area.
class UnitShell extends StatelessWidget {
  final String type;
  final String title;
  final bool isCompleted;
  final String? meta;
  final List<Widget> children;
  final Widget? banner;
  final Widget? footer;
  final Widget? headerIcon;
  final VoidCallback? onComplete;
  final VoidCallback onBack;

  /// Defaults to the per-type label ("خوندم", "دیدم", ...).
  final String? primaryTitle;
  final bool isSubmitting;
  final ScrollController? controller;

  /// 0..100 for the focus-bar progress; the bar stays empty when null.
  final num? progress;

  /// Replaces the default complete/back buttons (e.g. the quiz stepper).
  final Widget? actions;

  const UnitShell({
    super.key,
    required this.type,
    required this.title,
    required this.isCompleted,
    required this.onBack,
    this.meta,
    this.children = const [],
    this.banner,
    this.footer,
    this.headerIcon,
    this.onComplete,
    this.primaryTitle,
    this.isSubmitting = false,
    this.controller,
    this.progress,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return MasirPage.focus(
      onClose: onBack,
      trailing: headerIcon,
      progress: progress,
      controller: controller,
      stickyBottom:
          actions ??
          UnitActionButtons(
            showPrimary: !isCompleted,
            primaryTitle: primaryTitle ?? UnitTypeStyle.doneLabelOf(type),
            isSubmitting: isSubmitting,
            onPrimary: onComplete,
            onBack: onBack,
          ),
      children: [
        UnitHeader(
          type: type,
          title: title,
          meta: meta,
          isCompleted: isCompleted,
        ),
        if (banner != null) ...[const SizedBox(height: MasirSpace.md), banner!],
        const SizedBox(height: MasirSpace.lg),
        ...children,
        if (footer != null) ...[const SizedBox(height: MasirSpace.lg), footer!],
      ],
    );
  }
}
