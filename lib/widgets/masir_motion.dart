import 'package:flutter/material.dart';

/// Shared motion for overlays, so every sheet and popup in the app opens and
/// closes the same way.
class MasirMotion {
  const MasirMotion._();

  /// Bottom sheets: a calm rise, and a slightly quicker drop on the way out.
  static const AnimationStyle sheet = AnimationStyle(
    duration: Duration(milliseconds: 380),
    reverseDuration: Duration(milliseconds: 240),
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );
}

/// A centred popup that pops in with a gentle overshoot and shrinks away when
/// closed, over a softly fading scrim.
Future<T?> showMasirDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: 'close',
    barrierColor: Colors.black.withValues(alpha: 0.5),
    transitionDuration: const Duration(milliseconds: 420),
    pageBuilder: (context, _, _) => SafeArea(child: builder(context)),
    transitionBuilder: (context, animation, _, child) {
      final entering = animation.status != AnimationStatus.reverse;
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeInCubic,
      );
      final fade = CurvedAnimation(
        parent: animation,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
        reverseCurve: Curves.easeIn,
      );
      return FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, entering ? 0.08 : 0.04),
            end: Offset.zero,
          ).animate(curved),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.82, end: 1).animate(curved),
            child: child,
          ),
        ),
      );
    },
  );
}

/// A fade-up entrance for a section or row. Items with a growing [index]
/// start a little later (40ms steps, capped), so a page fills in as a gentle
/// cascade instead of appearing all at once.
class MasirEntrance extends StatefulWidget {
  final Widget child;
  final int index;

  /// Items past this index appear without animating.
  static const int maxStaggered = 8;

  const MasirEntrance({super.key, required this.child, this.index = 0});

  @override
  State<MasirEntrance> createState() => _MasirEntranceState();
}

class _MasirEntranceState extends State<MasirEntrance>
    with SingleTickerProviderStateMixin {
  static const int _baseMs = 360;
  static const int _stepMs = 40;
  static const int _maxStepCount = 6;

  late final int _delayMs =
      widget.index.clamp(0, _maxStepCount).toInt() * _stepMs;
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: _baseMs + _delayMs),
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: Interval(
      _delayMs / (_baseMs + _delayMs),
      1,
      curve: Curves.easeOutCubic,
    ),
  );

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(MasirEntrance old) {
    super.didUpdateWidget(old);
    // New kind of content in the same slot (e.g. a skeleton replaced by the
    // loaded page): play the entrance again.
    if (old.child.runtimeType != widget.child.runtimeType &&
        !MediaQuery.disableAnimationsOf(context)) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      child: widget.child,
      builder: (context, child) {
        final v = _curve.value;
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(0, (1 - v) * 16),
            child: child,
          ),
        );
      },
    );
  }
}

/// Wraps the first few [children] in a [MasirEntrance] cascade.
List<Widget> masirStaggered(List<Widget> children) {
  return [
    for (var i = 0; i < children.length; i++)
      if (i < MasirEntrance.maxStaggered)
        MasirEntrance(key: children[i].key, index: i, child: children[i])
      else
        children[i],
  ];
}
