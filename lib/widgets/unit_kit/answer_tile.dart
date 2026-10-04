import 'package:flutter/material.dart';

import '/core/feedback/masir_feedback.dart';
import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/widgets/chunky_box.dart';
import '/widgets/custom_text.dart';

enum AnswerState { idle, selected, correct, wrong, disabled }

/// Letters that label four-choice options.
const List<String> kOptionLetters = ['الف', 'ب', 'ج', 'د'];

/// One chunky answer tile: a round badge (option letter or an icon), the
/// answer text and a state mark. Used for four-choice options, true/false,
/// the "I read it" choices and the answer review.
class AnswerTile extends StatelessWidget {
  final String label;

  /// Text inside the leading badge (e.g. the option letter).
  final String? badge;

  /// Icon inside the leading badge, used instead of [badge].
  final IconData? badgeIcon;
  final AnswerState state;
  final VoidCallback? onTap;

  /// Stacks badge above the label, for two tiles side by side.
  final bool vertical;

  const AnswerTile({
    super.key,
    required this.label,
    this.badge,
    this.badgeIcon,
    this.state = AnswerState.idle,
    this.onTap,
    this.vertical = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (fill, edge, border, fg) = switch (state) {
      AnswerState.selected => (
        c.primaryTint,
        c.primaryEdge,
        c.primary,
        c.primary,
      ),
      AnswerState.correct => (c.green100, c.greenEdge, c.green, c.greenEdge),
      AnswerState.wrong => (c.coralSoft, c.coralEdge, c.coral, c.coralEdge),
      _ => (c.surface, c.lip, c.border, c.ink),
    };
    final active = state != AnswerState.idle && state != AnswerState.disabled;
    final mark = switch (state) {
      AnswerState.selected || AnswerState.correct => Icons.check_circle_rounded,
      AnswerState.wrong => Icons.cancel_rounded,
      _ => null,
    };

    final badgeWidget = Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? border : c.border100,
        shape: BoxShape.circle,
      ),
      child: badgeIcon != null
          ? Icon(
              badgeIcon,
              size: MasirIconSize.md,
              color: active ? c.white : c.inkMuted,
            )
          : CustomText.micro(badge ?? '', color: active ? c.white : c.inkMuted),
    );

    final text = CustomText.bodyStrong(
      label,
      color: fg,
      textAlign: vertical ? TextAlign.center : null,
    );

    final content = vertical
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              badgeWidget,
              const SizedBox(height: MasirSpace.sm),
              text,
            ],
          )
        : Row(
            children: [
              badgeWidget,
              const SizedBox(width: MasirSpace.md),
              Expanded(child: text),
              if (mark != null) ...[
                const SizedBox(width: MasirSpace.sm),
                Icon(mark, color: border, size: MasirIconSize.lg),
              ],
            ],
          );

    Widget tile = ChunkyBox(
      fill: fill,
      edge: edge,
      borderColor: border,
      radius: MasirRadius.row,
      padding: EdgeInsets.symmetric(
        horizontal: MasirSpace.lg,
        vertical: vertical ? MasirSpace.lg : MasirSpace.md,
      ),
      haptic: false,
      onTap: state == AnswerState.disabled || onTap == null
          ? null
          : () {
              MasirFeedback.select();
              onTap!();
            },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 36),
        child: Center(child: content),
      ),
    );

    if (state == AnswerState.disabled) {
      tile = Opacity(opacity: 0.6, child: tile);
    }

    // A short pop whenever the tile becomes selected / graded.
    if (active && !MediaQuery.disableAnimationsOf(context)) {
      tile = TweenAnimationBuilder<double>(
        key: ValueKey(state),
        tween: Tween(begin: 0.94, end: 1),
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutBack,
        builder: (context, scale, child) =>
            Transform.scale(scale: scale, child: child),
        child: tile,
      );
    }
    return tile;
  }
}
