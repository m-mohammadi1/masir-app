import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

import '/core/theme/masir_style.dart';
import 'paper_theme.dart';
import 'trail_layout.dart';

/// The whole course on one canvas: the trail painted once, every stop placed
/// on the same centres the trail passes through.
class TrailCanvas extends StatelessWidget {
  final List<TrailNode> nodes;

  /// Keeps the hand-drawn variation stable for a course.
  final int seed;

  /// 0 → 1 entrance; stops rise in staggered, the trail fades in first.
  final Animation<double> entrance;

  /// How far the walked (green) trail reaches, as a fractional stop index.
  final ValueListenable<double> walked;

  const TrailCanvas({
    super.key,
    required this.nodes,
    required this.seed,
    required this.entrance,
    required this.walked,
  });

  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final geometry = TrailGeometry.layout(nodes, width: width, seed: seed);
        return SizedBox(
          width: width,
          height: geometry.height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: entrance,
                    curve: const Interval(0, 0.4, curve: Curves.easeOut),
                  ),
                  child: CustomPaint(
                    painter: TrailPainter(
                      geometry: geometry,
                      walked: walked,
                      theme: PaperTheme.of(context),
                    ),
                  ),
                ),
              ),
              for (var i = 0; i < nodes.length; i++) _place(geometry, i, width),
            ],
          ),
        );
      },
    );
  }

  Widget _place(TrailGeometry geometry, int i, double width) {
    final node = nodes[i];
    final center = geometry.centerOf(i, width);
    final boxWidth = node.boxWidth;
    final child = _NodeEntrance(
      index: i,
      entrance: entrance,
      child: Center(child: node.build(width)),
    );
    return Positioned(
      top: center.dy - node.height / 2,
      height: node.height,
      left: boxWidth == null ? 0 : center.dx - boxWidth / 2,
      width: boxWidth ?? width,
      child: child,
    );
  }
}

/// Fade + rise-in for a stop, staggered by its place on the trail. Purely
/// cosmetic: it never touches layout.
class _NodeEntrance extends StatelessWidget {
  final int index;
  final Animation<double> entrance;
  final Widget child;

  const _NodeEntrance({
    required this.index,
    required this.entrance,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final start = (0.1 + index * 0.025).clamp(0.0, 0.7);
    final end = (start + 0.3).clamp(0.0, 1.0);
    final curve = CurvedAnimation(
      parent: entrance,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: curve,
      builder: (context, child) => Opacity(
        opacity: curve.value,
        child: Transform.translate(
          offset: Offset(0, (1 - curve.value) * 12),
          child: child,
        ),
      ),
      child: child,
    );
  }
}

/// Paints the trail: a thick rounded ribbon with a solid lip underneath (the
/// same depth as ChunkyBox). The walked part is solid green up to [walked];
/// the rest is a dashed neutral track. Lips go down before faces so a lip
/// never covers a neighbouring stretch.
class TrailPainter extends CustomPainter {
  final TrailGeometry geometry;
  final ValueListenable<double> walked;
  final PaperTheme theme;

  TrailPainter({
    required this.geometry,
    required this.walked,
    required this.theme,
  }) : super(repaint: walked);

  static const double walkedWidth = 14;
  static const double trackWidth = 10;
  static const double _dash = 14;
  static const double _gap = 12;

  @override
  void paint(Canvas canvas, Size size) {
    final metrics = geometry.path.computeMetrics().toList();
    if (metrics.isEmpty) return;
    final metric = metrics.first;
    final split = geometry.distanceAt(walked.value).clamp(0.0, metric.length);
    final walkedPath = metric.extractPath(0, split);
    final ahead = metric.extractPath(split, metric.length);

    const lip = Offset(0, Chunky.lip);
    _dashed(canvas, ahead.shift(lip), theme.trailUnwalkedEdge, trackWidth);
    if (split > 0) {
      canvas.drawPath(
        walkedPath.shift(lip),
        _stroke(theme.trailWalkedEdge, walkedWidth),
      );
    }
    _dashed(canvas, ahead, theme.trailUnwalked, trackWidth);
    if (split > 0) {
      canvas.drawPath(walkedPath, _stroke(theme.trailWalked, walkedWidth));
    }
  }

  static Paint _stroke(Color color, double width) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  static void _dashed(Canvas canvas, Path source, Color color, double width) {
    final paint = _stroke(color, width);
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = math.min(distance + _dash, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += _dash + _gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant TrailPainter old) =>
      old.geometry != geometry || old.theme != theme || old.walked != walked;
}
