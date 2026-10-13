import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/widgets.dart';

/// One stop on the roadmap: a chapter plate, a path signpost, a unit, a
/// chapter trophy or the course finish.
///
/// The layout below is the single source of truth for where every stop sits:
/// the painter draws the trail through the same centres the canvas places the
/// widgets at, so the line and the markers can never disagree.
class TrailNode {
  /// Vertical space this stop takes on the trail; its centre is the middle.
  final double height;

  /// Empty space above this stop (before a new chapter).
  final double leadingGap;

  /// Horizontal centre as a fraction of the canvas width.
  final double x;

  /// Width of the box the widget is laid out in, centred on [x]. Null means
  /// the full canvas width (chapter plates, signposts).
  final double? boxWidth;

  /// Module id, so a deep link can scroll to its chapter.
  final String? anchorId;

  /// Unit id, for unit stops.
  final String? unitId;

  final Widget Function(double canvasWidth) build;

  const TrailNode({
    required this.height,
    this.leadingGap = 0,
    this.x = 0.5,
    this.boxWidth,
    this.anchorId,
    this.unitId,
    required this.build,
  });
}

/// Where units sit across the canvas: a soft weave around the centre line
/// instead of a hard left/right zigzag. Each path starts next to its centred
/// signpost and swings out and back, alternating direction from one path to
/// the next. [jitter] in [-1, 1] adds a little hand-drawn irregularity.
double weaveX(int unitIndex, {required bool swingRight, double jitter = 0}) {
  const amplitude = 0.22;
  const step = math.pi / 4;
  final phase = math.sin((unitIndex + 1) * step);
  final side = swingRight ? 1 : -1;
  return 0.5 + side * amplitude * phase + jitter * 0.02;
}

/// Geometry of a laid-out trail for one canvas width.
class TrailGeometry {
  final List<TrailNode> nodes;

  /// Vertical centre of every stop.
  final List<double> centersY;

  /// Total canvas height.
  final double height;

  /// The whole trail as one smooth curve through every stop's centre.
  final Path path;

  /// Distance along [path] from the start to each stop's centre.
  final List<double> distances;

  TrailGeometry._(
    this.nodes,
    this.centersY,
    this.height,
    this.path,
    this.distances,
  );

  /// Lays out [nodes] for a canvas [width]. [seed] keeps the hand-drawn
  /// variation stable for a course across rebuilds and sessions.
  factory TrailGeometry.layout(
    List<TrailNode> nodes, {
    required double width,
    required int seed,
  }) {
    final centersY = computeCentersY(nodes);
    final height = nodes.isEmpty ? 0.0 : centersY.last + nodes.last.height / 2;
    final points = [
      for (var i = 0; i < nodes.length; i++)
        Offset(nodes[i].x * width, centersY[i]),
    ];
    final (path, distances) = _smoothPath(points, seed);
    return TrailGeometry._(nodes, centersY, height, path, distances);
  }

  Offset centerOf(int index, double width) =>
      Offset(nodes[index].x * width, centersY[index]);

  /// Distance along the trail for a fractional stop position: 2.0 is the
  /// third stop's centre, 2.5 is halfway along the stretch to the fourth.
  double distanceAt(double position) {
    if (distances.isEmpty) return 0;
    final p = position.clamp(0.0, (distances.length - 1).toDouble());
    final i = p.floor();
    if (i >= distances.length - 1) return distances.last;
    final t = p - i;
    return lerpDouble(distances[i], distances[i + 1], t)!;
  }

  double get length => distances.isEmpty ? 0 : distances.last;
}

/// Vertical centre of every stop, stacking heights and leading gaps.
List<double> computeCentersY(List<TrailNode> nodes) {
  final centers = <double>[];
  var y = 0.0;
  for (final node in nodes) {
    y += node.leadingGap;
    centers.add(y + node.height / 2);
    y += node.height;
  }
  return centers;
}

/// A Catmull-Rom spline through [points] as cubic Béziers: tangents are
/// continuous at every stop, so the trail never kinks where two stretches
/// meet. Each stop gets a slightly different tension (seeded) so the curve
/// keeps a hand-drawn feel without wobbling.
(Path, List<double>) _smoothPath(List<Offset> points, int seed) {
  final path = Path();
  final distances = <double>[];
  if (points.isEmpty) return (path, distances);

  final rng = math.Random(seed);
  final tension = [
    for (var i = 0; i < points.length; i++) 0.85 + rng.nextDouble() * 0.3,
  ];

  // Tangent at a stop: along the line between its neighbours, but kept
  // mostly vertical so the trail flows down the screen instead of swinging
  // wide sideways out of a node.
  Offset tangent(int i) {
    final prev = points[math.max(i - 1, 0)];
    final next = points[math.min(i + 1, points.length - 1)];
    final d = next - prev;
    return Offset(d.dx * 0.6, d.dy) * (0.5 * tension[i]);
  }

  path.moveTo(points.first.dx, points.first.dy);
  distances.add(0);
  var total = 0.0;
  for (var i = 1; i < points.length; i++) {
    final p0 = points[i - 1];
    final p1 = points[i];
    final c0 = p0 + tangent(i - 1) / 3;
    final c1 = p1 - tangent(i) / 3;
    final segment = Path()
      ..moveTo(p0.dx, p0.dy)
      ..cubicTo(c0.dx, c0.dy, c1.dx, c1.dy, p1.dx, p1.dy);
    path.cubicTo(c0.dx, c0.dy, c1.dx, c1.dy, p1.dx, p1.dy);
    for (final metric in segment.computeMetrics()) {
      total += metric.length;
    }
    distances.add(total);
  }
  return (path, distances);
}
