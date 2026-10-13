import 'dart:math' as math;

import 'package:flutter/material.dart';

import '/core/theme/institute_themed.dart';
import '/core/theme/masir_style.dart';
import '/widgets/chunky_box.dart';
import '/widgets/custom_button.dart';
import '/widgets/custom_text.dart';
import 'paper_theme.dart';

/// What the student chose on a unit's card.
enum UnitCardAction { open, join }

/// The state a unit's card describes.
enum UnitCardState { completed, current, open, preview, locked }

/// Shows the card for a unit anchored to its pin ([anchor], on screen). It
/// opens as a light dialog route, so tapping outside or the system back (the
/// Android button / gesture) closes it, and the roadmap can't scroll under it.
Future<UnitCardAction?> showUnitCard(
  BuildContext context, {
  required Rect anchor,
  required String title,
  required String typeLabel,
  required IconData icon,
  required UnitCardState state,
  String? themePreset,
}) {
  return showGeneralDialog<UnitCardAction>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withValues(alpha: 0.12),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (dialogContext, _, _) => InstituteThemed(
      preset: themePreset,
      child: _UnitCardLayout(
        anchor: anchor,
        title: title,
        typeLabel: typeLabel,
        icon: icon,
        state: state,
      ),
    ),
    transitionBuilder: (context, animation, _, child) {
      if (MediaQuery.disableAnimationsOf(context)) {
        return FadeTransition(opacity: animation, child: child);
      }
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(opacity: curved, child: child);
    },
  );
}

class _UnitCardLayout extends StatelessWidget {
  final Rect anchor;
  final String title;
  final String typeLabel;
  final IconData icon;
  final UnitCardState state;

  const _UnitCardLayout({
    required this.anchor,
    required this.title,
    required this.typeLabel,
    required this.icon,
    required this.state,
  });

  static const double _maxWidth = 300;
  static const double _gap = 10;
  static const double _arrow = 10;

  /// Rough card height, only used to decide whether it fits below the pin.
  static const double _estimatedHeight = 190;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screen = media.size;
    final width = math.min(_maxWidth, screen.width - 2 * MasirSpace.lg);
    final left = (anchor.center.dx - width / 2).clamp(
      MasirSpace.lg,
      screen.width - MasirSpace.lg - width,
    );
    final spaceBelow =
        screen.height - media.padding.bottom - anchor.bottom - _gap;
    final below = spaceBelow >= _estimatedHeight + _arrow;
    final arrowX = (anchor.center.dx - left).clamp(24.0, width - 24.0);

    final card = _UnitCard(
      title: title,
      typeLabel: typeLabel,
      icon: icon,
      state: state,
      arrowX: arrowX,
      arrowUp: below,
    );

    // The card scales out of the pin it belongs to.
    final alignment = Alignment((arrowX / width) * 2 - 1, below ? -1 : 1);

    return Stack(
      children: [
        Positioned(
          left: left,
          width: width,
          top: below ? anchor.bottom + _gap : null,
          bottom: below ? null : screen.height - anchor.top + _gap,
          child: _ScaleIn(alignment: alignment, child: card),
        ),
      ],
    );
  }
}

class _ScaleIn extends StatelessWidget {
  final Alignment alignment;
  final Widget child;

  const _ScaleIn({required this.alignment, required this.child});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, alignment: alignment, child: child),
      child: child,
    );
  }
}

class _UnitCard extends StatelessWidget {
  final String title;
  final String typeLabel;
  final IconData icon;
  final UnitCardState state;
  final double arrowX;
  final bool arrowUp;

  const _UnitCard({
    required this.title,
    required this.typeLabel,
    required this.icon,
    required this.state,
    required this.arrowX,
    required this.arrowUp,
  });

  @override
  Widget build(BuildContext context) {
    final t = PaperTheme.of(context);
    final (Color tint, Color fg, IconData glyph) = switch (state) {
      UnitCardState.completed => (
        t.successSoft,
        t.successEdge,
        Icons.check_rounded,
      ),
      UnitCardState.locked => (
        t.colors.border100,
        t.locked,
        Icons.lock_rounded,
      ),
      UnitCardState.preview => (t.sunSoft, t.sunEdge, icon),
      _ => (t.accentTint, t.accent, icon),
    };
    final note = switch (state) {
      UnitCardState.completed => 'این واحد رو گذروندی',
      UnitCardState.locked => 'برای ادامه ثبت‌نام کن',
      UnitCardState.preview => 'پیش‌نمایش رایگان',
      _ => null,
    };
    final (String action, UnitCardAction result) = switch (state) {
      UnitCardState.completed => ('مرور', UnitCardAction.open),
      UnitCardState.locked => ('ثبت‌نام', UnitCardAction.join),
      _ => ('شروع', UnitCardAction.open),
    };

    final body = ChunkyBox(
      fill: t.surface,
      edge: t.lip,
      borderColor: t.border,
      radius: MasirRadius.card,
      padding: const EdgeInsets.all(MasirSpace.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: tint,
                  borderRadius: BorderRadius.circular(MasirRadius.chip),
                ),
                child: Icon(glyph, color: fg, size: MasirIconSize.lg),
              ),
              const SizedBox(width: MasirSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText.micro(typeLabel, color: t.inkMuted),
                    const SizedBox(height: 2),
                    CustomText.headline(title, maxLines: 2),
                  ],
                ),
              ),
            ],
          ),
          if (note != null) ...[
            const SizedBox(height: MasirSpace.sm),
            CustomText.caption(
              note,
              color: state == UnitCardState.locked ? t.inkMuted : fg,
            ),
          ],
          const SizedBox(height: MasirSpace.md),
          CustomButton(
            title: action,
            onTap: () => Navigator.of(context).pop(result),
          ),
        ],
      ),
    );

    final arrow = Padding(
      padding: EdgeInsetsDirectional.zero,
      child: Align(
        alignment: AlignmentDirectional.topStart,
        child: Padding(
          padding: EdgeInsets.only(left: arrowX - _UnitCardLayout._arrow),
          child: CustomPaint(
            size: const Size(
              _UnitCardLayout._arrow * 2,
              _UnitCardLayout._arrow,
            ),
            painter: _ArrowPainter(
              fill: t.surface,
              border: t.border,
              up: arrowUp,
            ),
          ),
        ),
      ),
    );

    return Material(
      type: MaterialType.transparency,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (arrowUp) arrow,
            Directionality(textDirection: TextDirection.rtl, child: body),
            if (!arrowUp)
              Transform.translate(offset: const Offset(0, -1), child: arrow),
          ],
        ),
      ),
    );
  }
}

/// The little triangle joining the card to its pin.
class _ArrowPainter extends CustomPainter {
  final Color fill;
  final Color border;
  final bool up;

  const _ArrowPainter({
    required this.fill,
    required this.border,
    required this.up,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = up
        ? (Path()
            ..moveTo(0, size.height + 1)
            ..lineTo(size.width / 2, 0)
            ..lineTo(size.width, size.height + 1))
        : (Path()
            ..moveTo(0, -1)
            ..lineTo(size.width / 2, size.height)
            ..lineTo(size.width, -1));
    canvas.drawPath(path, Paint()..color = fill);
    canvas.drawPath(
      path,
      Paint()
        ..color = border
        ..style = PaintingStyle.stroke
        ..strokeWidth = Chunky.border,
    );
  }

  @override
  bool shouldRepaint(covariant _ArrowPainter old) =>
      old.fill != fill || old.border != border || old.up != up;
}
