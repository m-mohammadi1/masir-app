import 'package:flutter/material.dart';

import '/core/helper/jalali_format.dart';
import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/widgets/chunky_box.dart';
import '/widgets/custom_text.dart';
import '/widgets/icon_tile.dart';
import '/widgets/masir_card.dart';
import '/widgets/progress_pill.dart';
import 'paper_theme.dart';

// Stops on the roadmap. They are pure visuals: TrailCanvas centres each one on
// the trail. Nothing here hangs text where the trail runs; unit titles live
// in the tap card, and the only labels on the line are the opaque chapter
// plates and path signposts the trail deliberately passes through.

/// Size of a unit pin's face.
const double kRoadmapPinSize = 64;

/// Chapter title plate: a full-width card the trail passes behind.
class RoadmapChapterPlate extends StatelessWidget {
  final int index;
  final String title;
  final int progress;
  final bool isComplete;

  const RoadmapChapterPlate({
    super.key,
    required this.index,
    required this.title,
    required this.progress,
    required this.isComplete,
  });

  @override
  Widget build(BuildContext context) {
    final t = PaperTheme.of(context);
    final accent = isComplete ? t.success : t.accent;

    final content = Row(
      children: [
        isComplete
            ? const IconTile(Icons.check_rounded, tone: IconTileTone.success)
            : Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: t.accentTint,
                  borderRadius: BorderRadius.circular(MasirRadius.chip),
                ),
                child: CustomText.headline(
                  faDigits(index + 1),
                  color: t.accent,
                ),
              ),
        const SizedBox(width: MasirSpace.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CustomText.micro('فصل ${faDigits(index + 1)}', color: accent),
                  const SizedBox(width: MasirSpace.sm),
                  Expanded(child: CustomText.bodyStrong(title, maxLines: 1)),
                ],
              ),
              const SizedBox(height: MasirSpace.sm - 2),
              ProgressPill(value: progress, height: 6, color: accent),
            ],
          ),
        ),
        const SizedBox(width: MasirSpace.md),
        CustomText.caption(
          isComplete ? 'کامل' : '${faDigits(progress)}٪',
          color: accent,
          weight: MasirText.heavy,
        ),
      ],
    );

    const padding = EdgeInsets.symmetric(
      horizontal: MasirSpace.md,
      vertical: MasirSpace.sm,
    );

    if (!isComplete) return MasirCard(padding: padding, child: content);
    return ChunkyBox(
      fill: t.successSoft,
      edge: t.successEdge.withValues(alpha: 0.35),
      borderColor: t.successEdge.withValues(alpha: 0.35),
      radius: MasirRadius.card,
      padding: padding,
      child: content,
    );
  }
}

/// Path signpost: a compact chip centred on the trail, like a station sign.
/// The trail runs vertically through it instead of crossing a side label.
class RoadmapPathSign extends StatelessWidget {
  final String title;
  final int progress;

  const RoadmapPathSign({
    super.key,
    required this.title,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final t = PaperTheme.of(context);
    final isComplete = progress >= 100;
    final fg = isComplete ? t.successEdge : t.sunEdge;
    final soft = isComplete ? t.successSoft : t.sunSoft;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 260),
      child: ChunkyBox(
        fill: soft,
        edge: fg,
        borderColor: fg,
        radius: MasirRadius.pill,
        padding: const EdgeInsets.fromLTRB(
          MasirSpace.lg,
          MasirSpace.sm,
          MasirSpace.sm,
          MasirSpace.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isComplete ? Icons.flag_circle_rounded : Icons.route_rounded,
              size: MasirIconSize.md,
              color: fg,
            ),
            const SizedBox(width: MasirSpace.sm),
            Flexible(
              child: CustomText.caption(
                title,
                weight: MasirText.strong,
                color: t.ink,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: MasirSpace.sm),
            CustomText.micro(
              isComplete ? 'کامل' : '${faDigits(progress)}٪',
              color: fg,
            ),
          ],
        ),
      ),
    );
  }
}

/// A unit: a round chunky button with its type icon. No caption: the title
/// is in the tap card. The "شروع" / "رایگان" bubble sits beside the pin on
/// the side away from the trail.
class RoadmapUnitPin extends StatelessWidget {
  final String unitId;
  final IconData icon;
  final bool isCompleted;
  final bool isLocked;
  final bool isCurrent;
  final bool isPreview;

  /// The unit just finished: plays a one-shot pop.
  final bool celebrate;

  /// Which side of the pin the bubble goes on.
  final bool bubbleOnLeft;

  /// Read by screen readers: title and type.
  final String semanticsLabel;

  /// Called with the pin's rect on screen, to anchor the card.
  final ValueChanged<Rect> onTap;

  const RoadmapUnitPin({
    super.key,
    required this.unitId,
    required this.icon,
    required this.isCompleted,
    required this.isLocked,
    required this.isCurrent,
    required this.isPreview,
    this.celebrate = false,
    required this.bubbleOnLeft,
    required this.semanticsLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = PaperTheme.of(context);
    final Color fill;
    final Color edge;
    Color? border;
    final Color fg;
    final IconData glyph;

    if (isCompleted) {
      fill = t.success;
      edge = t.successEdge;
      fg = t.colors.white;
      glyph = Icons.check_rounded;
    } else if (isLocked) {
      fill = t.colors.border100;
      edge = t.border;
      fg = t.locked;
      glyph = Icons.lock_rounded;
    } else if (isCurrent) {
      fill = t.accent;
      edge = t.accentEdge;
      fg = t.onAccent;
      glyph = icon;
    } else {
      fill = t.surface;
      edge = t.accent.withValues(alpha: 0.35);
      border = t.accent.withValues(alpha: 0.35);
      fg = t.accent;
      glyph = icon;
    }

    final bubble = isCurrent
        ? _SideBubble(
            label: 'شروع',
            fill: t.accent,
            fg: t.onAccent,
            pointsRight: bubbleOnLeft,
          )
        : (isPreview && !isLocked && !isCompleted)
        ? _SideBubble(
            label: 'رایگان',
            fill: t.sunSoft,
            fg: t.sunEdge,
            pointsRight: bubbleOnLeft,
          )
        : null;

    return Semantics(
      button: true,
      label: semanticsLabel,
      child: SizedBox(
        width: kRoadmapPinSize,
        height: kRoadmapPinSize,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            if (isCurrent) const PulseRing(size: kRoadmapPinSize),
            if (celebrate) const DonePop(size: kRoadmapPinSize),
            Positioned(
              left: 0,
              top: 0,
              width: kRoadmapPinSize,
              height: kRoadmapPinSize + Chunky.lip,
              // Becoming the current unit (after the trail reaches it) pops.
              child: _PopIn(
                key: ValueKey('pin-$unitId-${isCurrent ? 'current' : 'idle'}'),
                active: isCurrent,
                child: Builder(
                  builder: (context) => ChunkyBox(
                    key: ValueKey('roadmap-pin-$unitId'),
                    fill: fill,
                    edge: edge,
                    borderColor: border,
                    radius: kRoadmapPinSize / 2,
                    alignment: Alignment.center,
                    onTap: () {
                      final box = context.findRenderObject() as RenderBox?;
                      if (box == null || !box.hasSize) return;
                      final origin = box.localToGlobal(Offset.zero);
                      onTap(
                        origin & const Size(kRoadmapPinSize, kRoadmapPinSize),
                      );
                    },
                    child: Icon(glyph, size: MasirIconSize.lg + 2, color: fg),
                  ),
                ),
              ),
            ),
            if (bubble != null)
              Positioned(
                top: 0,
                bottom: 0,
                left: bubbleOnLeft ? null : kRoadmapPinSize + 4,
                right: bubbleOnLeft ? kRoadmapPinSize + 4 : null,
                child: IgnorePointer(child: Center(child: bubble)),
              ),
          ],
        ),
      ),
    );
  }
}

/// Small speech bubble with its tail pointing at the pin beside it.
class _SideBubble extends StatelessWidget {
  final String label;
  final Color fill;
  final Color fg;
  final bool pointsRight;

  const _SideBubble({
    required this.label,
    required this.fill,
    required this.fg,
    required this.pointsRight,
  });

  @override
  Widget build(BuildContext context) {
    final body = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: MasirSpace.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(MasirRadius.pill),
      ),
      child: CustomText.micro(label, color: fg),
    );
    final tail = CustomPaint(
      size: const Size(5, 10),
      painter: _SideTailPainter(fill, pointsRight: pointsRight),
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.ltr,
      children: pointsRight ? [body, tail] : [tail, body],
    );
  }
}

class _SideTailPainter extends CustomPainter {
  final Color color;
  final bool pointsRight;

  const _SideTailPainter(this.color, {required this.pointsRight});

  @override
  void paint(Canvas canvas, Size size) {
    final path = pointsRight
        ? (Path()
            ..moveTo(0, 0)
            ..lineTo(size.width, size.height / 2)
            ..lineTo(0, size.height))
        : (Path()
            ..moveTo(size.width, 0)
            ..lineTo(0, size.height / 2)
            ..lineTo(size.width, size.height));
    canvas.drawPath(path..close(), Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _SideTailPainter old) =>
      old.color != color || old.pointsRight != pointsRight;
}

/// Scales its child in with a little overshoot when [active] turns on.
class _PopIn extends StatelessWidget {
  final bool active;
  final Widget child;

  const _PopIn({super.key, required this.active, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!active || MediaQuery.disableAnimationsOf(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.82, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: child,
    );
  }
}

/// A round chunky medallion; its face centre is this widget's centre. An
/// optional caption hangs below (used only where nothing follows on the
/// trail).
class _Medallion extends StatelessWidget {
  final double size;
  final Color fill;
  final Color edge;
  final Color? borderColor;
  final IconData icon;
  final Color iconColor;
  final Widget? caption;

  const _Medallion({
    super.key,
    required this.size,
    required this.fill,
    required this.edge,
    this.borderColor,
    required this.icon,
    required this.iconColor,
    this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: 0,
            width: size,
            height: size + Chunky.lip,
            child: ChunkyBox(
              fill: fill,
              edge: edge,
              borderColor: borderColor,
              radius: size / 2,
              alignment: Alignment.center,
              child: Icon(icon, size: size * 0.5, color: iconColor),
            ),
          ),
          if (caption != null)
            Positioned(
              top: size + Chunky.lip + MasirSpace.sm,
              left: 0,
              right: 0,
              height: 0,
              child: OverflowBox(
                maxWidth: double.infinity,
                maxHeight: double.infinity,
                alignment: Alignment.topCenter,
                child: caption,
              ),
            ),
        ],
      ),
    );
  }
}

/// Trophy at the end of a completed chapter. No caption: the trail continues
/// straight down from it, and the chapter plate already says "کامل".
class RoadmapTrophy extends StatelessWidget {
  const RoadmapTrophy({super.key});

  @override
  Widget build(BuildContext context) {
    final t = PaperTheme.of(context);
    return Semantics(
      label: 'این فصل کامل شد',
      child: _Medallion(
        key: const ValueKey('roadmap-trophy'),
        size: 64,
        fill: t.sun,
        edge: t.sunEdge,
        icon: Icons.workspace_premium_rounded,
        iconColor: t.colors.white,
      ),
    );
  }
}

/// The finish line: always the last stop, so the destination is visible from
/// the start. Its caption hangs below, where the trail has already ended.
class RoadmapFinish extends StatelessWidget {
  final bool isComplete;

  const RoadmapFinish({super.key, required this.isComplete});

  @override
  Widget build(BuildContext context) {
    final t = PaperTheme.of(context);
    if (!isComplete) {
      return _Medallion(
        key: const ValueKey('roadmap-finish'),
        size: 72,
        fill: t.sunSoft,
        edge: t.sunEdge,
        borderColor: t.sunEdge,
        icon: Icons.flag_rounded,
        iconColor: t.sunEdge,
        caption: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText.bodyStrong('پایان مسیر', textAlign: TextAlign.center),
            const SizedBox(height: 2),
            CustomText.caption(
              'با تموم شدن دوره باز می‌شه',
              color: t.inkMuted,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    return _Medallion(
      key: const ValueKey('roadmap-finish'),
      size: 80,
      fill: t.success,
      edge: t.successEdge,
      icon: Icons.emoji_events_rounded,
      iconColor: t.colors.white,
      caption: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText.bodyStrong(
            'دوره تموم شد!',
            color: t.success,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          CustomText.caption(
            'همه‌ی واحدها رو گذروندی',
            color: t.inkMuted,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Soft ring that breathes around the current unit. Static when the system
/// asks for reduced motion.
class PulseRing extends StatefulWidget {
  final double size;

  const PulseRing({super.key, required this.size});

  @override
  State<PulseRing> createState() => _PulseRingState();
}

class _PulseRingState extends State<PulseRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );
  bool _reduce = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduce = MediaQuery.disableAnimationsOf(context);
    if (_reduce) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colors.primary;
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _reduce ? 0.0 : Curves.easeOut.transform(_controller.value);
          final scale = _reduce ? 1.18 : 1.0 + 0.4 * t;
          final opacity = _reduce ? 0.28 : 0.4 * (1 - t);
          return Transform.scale(
            scale: scale,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withValues(alpha: opacity),
                  width: 4,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A one-shot green ring that blooms out of a pin the student just finished.
class DonePop extends StatefulWidget {
  final double size;

  const DonePop({super.key, required this.size});

  @override
  State<DonePop> createState() => _DonePopState();
}

class _DonePopState extends State<DonePop> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (!MediaQuery.disableAnimationsOf(context)) _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colors.green;
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (_controller.value == 0 || _controller.value >= 1) {
            return const SizedBox.shrink();
          }
          final t = Curves.easeOutCubic.transform(_controller.value);
          return Transform.scale(
            scale: 1.0 + 0.9 * t,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withValues(alpha: 0.6 * (1 - t)),
                  width: 5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
