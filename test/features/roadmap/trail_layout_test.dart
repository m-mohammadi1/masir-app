import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/features/main/presentation/page/outline/roadmap/trail_layout.dart';

TrailNode stop(double height, {double x = 0.5, double gap = 0}) => TrailNode(
  height: height,
  x: x,
  leadingGap: gap,
  build: (_) => const SizedBox(),
);

void main() {
  final nodes = [
    stop(76),
    stop(72),
    for (var i = 0; i < 6; i++) stop(100, x: weaveX(i, swingRight: true)),
    stop(76, gap: 36),
    stop(150),
  ];

  test('stops stack their heights and leading gaps', () {
    final centers = computeCentersY(nodes);
    expect(centers.first, 38);
    expect(centers[1], 76 + 36);
    // The chapter after the units starts after its gap.
    expect(centers[8], 76 + 72 + 6 * 100 + 36 + 38);
  });

  test('distance along the trail only grows, from 0 at the first stop', () {
    final g = TrailGeometry.layout(nodes, width: 366, seed: 7);
    expect(g.distances.first, 0);
    for (var i = 1; i < g.distances.length; i++) {
      // Each stretch is at least as long as the vertical drop between stops.
      expect(
        g.distances[i] - g.distances[i - 1],
        greaterThanOrEqualTo(g.centersY[i] - g.centersY[i - 1] - 0.5),
      );
    }
    expect(g.length, g.distances.last);
  });

  test('a fractional position lies between its two stops', () {
    final g = TrailGeometry.layout(nodes, width: 366, seed: 7);
    expect(g.distanceAt(3), g.distances[3]);
    expect(g.distanceAt(3.5), greaterThan(g.distances[3]));
    expect(g.distanceAt(3.5), lessThan(g.distances[4]));
    expect(g.distanceAt(-1), 0);
    expect(g.distanceAt(99), g.length);
  });

  test('units weave out and back on the chosen side, inside the canvas', () {
    final right = [for (var i = 0; i < 8; i++) weaveX(i, swingRight: true)];
    final left = [for (var i = 0; i < 8; i++) weaveX(i, swingRight: false)];
    for (final x in [...right, ...left]) {
      expect(x, inInclusiveRange(0.27, 0.73));
    }
    // Out to a peak and back towards the centre.
    expect(right[0], greaterThan(0.5));
    expect(right[1], greaterThan(right[0]));
    expect(right[2], lessThan(right[1]));
    expect(left[1], lessThan(0.5));
    // Jitter only nudges.
    expect(
      (weaveX(1, swingRight: true, jitter: 1) - right[1]).abs(),
      lessThanOrEqualTo(0.02 + 1e-9),
    );
  });

  test('the same course always gets the same trail', () {
    final a = TrailGeometry.layout(nodes, width: 366, seed: 42);
    final b = TrailGeometry.layout(nodes, width: 366, seed: 42);
    expect(a.distances, b.distances);
  });
}
