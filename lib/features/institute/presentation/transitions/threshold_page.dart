import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The page every institute screen sits in.
///
/// Its key is the same for every institute. The shell's nested navigator has
/// one GlobalKey, so two shell pages must never be on screen together; with a
/// shared key, going from one institute to another reuses this page (the
/// shell inside is keyed per institute and starts fresh) instead of overlapping
/// two pages during the transition.
class ThresholdPage extends CustomTransitionPage<void> {
  ThresholdPage({required super.child})
    : super(
        key: const ValueKey('institute-shell'),
        transitionDuration: const Duration(milliseconds: 450),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          if (MediaQuery.disableAnimationsOf(context)) {
            return FadeTransition(opacity: animation, child: child);
          }
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
            reverseCurve: Curves.easeInOutCubic,
          );
          return AnimatedBuilder(
            animation: curved,
            builder: (context, _) {
              return ClipPath(
                clipper: CircleRevealClipper(curved.value),
                child: FadeTransition(opacity: curved, child: child),
              );
            },
          );
        },
      );
}

/// A circle growing from [center] (default: upper middle) until it covers
/// the whole box at [progress] 1.
class CircleRevealClipper extends CustomClipper<Path> {
  final double progress;
  final Offset? center;

  CircleRevealClipper(this.progress, {this.center});

  @override
  Path getClip(Size size) {
    final c = center ?? Offset(size.width / 2, size.height * 0.28);
    // Far enough to reach the farthest corner from the centre.
    final maxRadius = [
      Offset.zero,
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ].map((corner) => (corner - c).distance).reduce(math.max);
    return Path()
      ..addOval(Rect.fromCircle(center: c, radius: maxRadius * progress));
  }

  @override
  bool shouldReclip(covariant CircleRevealClipper oldClipper) {
    return oldClipper.progress != progress || oldClipper.center != center;
  }
}

Page<void> thresholdPage(
  BuildContext context,
  GoRouterState state,
  Widget child,
) => ThresholdPage(child: child);
