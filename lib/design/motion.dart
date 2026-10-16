import 'dart:math' as math;

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'tokens.dart' show fa;

/// Motion tokens (masir-design/rules/motion.md §1). Use nothing else.
///
/// Motion shows direction, is short and never blocks a tap, and is joyful
/// only when the student finished something.
abstract final class MasirMotion {
  // durations
  static const instant = Duration(
    milliseconds: 90,
  ); // button press, tab fade-out
  static const quick = Duration(
    milliseconds: 150,
  ); // reduced-motion fades, dashboard
  static const short = Duration(milliseconds: 220); // list items, tab fade-in
  static const medium = Duration(milliseconds: 300); // page push, toast
  static const long = Duration(
    milliseconds: 400,
  ); // container transform, sheet, pin pop
  static const celebrate = Duration(
    milliseconds: 600,
  ); // green trail, number count-up
  static const threshold = Duration(
    milliseconds: 520,
  ); // circle reveal into an institute
  static const confetti = Duration(milliseconds: 900);

  /// Push back is the push reversed, a little faster.
  static const back = Duration(milliseconds: 250);

  /// Release after a press (pops back with a 1px overshoot).
  static const release = Duration(milliseconds: 120);

  // curves
  static const standard = Cubic(
    0.2,
    0.0,
    0.0,
    1.0,
  ); // anything entering or moving
  static const exit = Cubic(0.3, 0.0, 1.0, 1.0); // anything leaving
  static const spring = Cubic(
    0.34,
    1.56,
    0.64,
    1.0,
  ); // pops and celebrations ONLY

  /// True when the student turned on "reduce motion" on their phone.
  static bool reduced(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);
}

// ---------------------------------------------------------------- §3 push

/// Forward pages come in from the left (RTL) over the old page, which moves
/// 30% the other way and dims to 16% ink. Reduced motion: a 150ms fade.
Widget masirPush(
  BuildContext context,
  Animation<double> a,
  Animation<double> s,
  Widget child,
) {
  if (MasirMotion.reduced(context)) {
    return FadeTransition(opacity: a, child: child);
  }
  final dir = Directionality.of(context) == TextDirection.rtl ? -1.0 : 1.0;
  final inA = CurvedAnimation(
    parent: a,
    curve: MasirMotion.standard,
    reverseCurve: MasirMotion.standard.flipped,
  );
  final outA = CurvedAnimation(
    parent: s,
    curve: MasirMotion.standard,
    reverseCurve: MasirMotion.standard.flipped,
  );
  return SlideTransition(
    position: Tween(begin: Offset(dir, 0), end: Offset.zero).animate(inA),
    child: DecoratedBox(
      // Soft shadow on the incoming page's trailing edge.
      decoration: const BoxDecoration(
        boxShadow: [BoxShadow(color: Color(0x1F2B2633), blurRadius: 16)],
      ),
      child: SlideTransition(
        position: Tween(
          begin: Offset.zero,
          end: Offset(-dir * 0.3, 0),
        ).animate(outA),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            child,
            IgnorePointer(
              child: FadeTransition(
                opacity: Tween(begin: 0.0, end: 0.16).animate(outA),
                child: const ColoredBox(color: Color(0xFF2B2633)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// [masirPush] as a Navigator route (sheets and pages opened imperatively).
class MasirPageRoute<T> extends PageRouteBuilder<T> {
  MasirPageRoute({
    required WidgetBuilder builder,
    super.settings,
    bool short = false,
    super.fullscreenDialog,
  }) : super(
         transitionDuration: short ? MasirMotion.short : MasirMotion.medium,
         reverseTransitionDuration: MasirMotion.back,
         pageBuilder: (context, _, _) => builder(context),
         transitionsBuilder: masirPush,
       );
}

/// [masirPush] as a go_router page. [short] is the quiz's next question (220ms).
CustomTransitionPage<T> masirPage<T>(
  GoRouterState state,
  Widget child, {
  bool short = false,
}) => CustomTransitionPage<T>(
  key: state.pageKey,
  transitionDuration: short ? MasirMotion.short : MasirMotion.medium,
  reverseTransitionDuration: MasirMotion.back,
  transitionsBuilder: masirPush,
  child: child,
);

// ---------------------------------------------------------- §4 fade-through

/// Peer screens (Splash → Intro, Login → Vitrine, Quiz → QuizResult): the
/// old one fades out, the new one fades in from 92–96% scale. 300ms.
CustomTransitionPage<T> masirFadeThroughPage<T>(
  GoRouterState state,
  Widget child,
) => CustomTransitionPage<T>(
  key: state.pageKey,
  transitionDuration: MasirMotion.medium,
  reverseTransitionDuration: MasirMotion.medium,
  transitionsBuilder: (context, a, s, child) => MasirMotion.reduced(context)
      ? FadeTransition(opacity: a, child: child)
      : FadeThroughTransition(
          animation: a,
          secondaryAnimation: s,
          fillColor: Colors.transparent,
          child: child,
        ),
  child: child,
);

/// Tab switcher: fades the current tab out (90ms) and the new one in from
/// slight scale (210ms). Nothing slides; tabs are peers. Give each tab's
/// scroll view a PageStorageKey, because the switcher rebuilds it.
class MasirFadeThrough extends StatelessWidget {
  final int index;
  final Widget child;
  const MasirFadeThrough({super.key, required this.index, required this.child});

  @override
  Widget build(BuildContext context) => PageTransitionSwitcher(
    duration: MasirMotion.reduced(context)
        ? MasirMotion.quick
        : MasirMotion.medium,
    transitionBuilder: (child, primary, secondary) =>
        MasirMotion.reduced(context)
        ? FadeTransition(opacity: primary, child: child)
        : FadeThroughTransition(
            animation: primary,
            secondaryAnimation: secondary,
            fillColor: Colors.transparent,
            child: child,
          ),
    child: KeyedSubtree(key: ValueKey(index), child: child),
  );
}

/// Fade-through over an indexed stack of tabs (go_router's
/// StatefulShellRoute keeps every branch alive; only the visible one shows).
/// Use as `navigatorContainerBuilder`.
class MasirTabStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  const MasirTabStack({super.key, required this.index, required this.children});

  @override
  State<MasirTabStack> createState() => _MasirTabStackState();
}

class _MasirTabStackState extends State<MasirTabStack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: MasirMotion.medium,
    value: 1,
  );
  late int _shown = widget.index;
  int? _leaving;

  @override
  void didUpdateWidget(MasirTabStack old) {
    super.didUpdateWidget(old);
    if (old.index != widget.index) {
      _leaving = _shown;
      _shown = widget.index;
      _c.duration = MasirMotion.reduced(context)
          ? MasirMotion.quick
          : MasirMotion.medium;
      _c.forward(from: 0).whenComplete(() {
        if (mounted) setState(() => _leaving = null);
      });
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = MasirMotion.reduced(context);
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = _c.value;
        // 0–30%: old fades out (≈90ms); 30–100%: new fades/scales in (≈210ms).
        final outO = reduced ? 1 - t : (1 - t / 0.3).clamp(0.0, 1.0);
        final inT = reduced
            ? t
            : MasirMotion.standard.transform(((t - 0.3) / 0.7).clamp(0.0, 1.0));
        return Stack(
          fit: StackFit.expand,
          children: [
            for (var i = 0; i < widget.children.length; i++)
              Offstage(
                offstage: i != _shown && i != _leaving,
                child: TickerMode(
                  enabled: i == _shown || i == _leaving,
                  child: IgnorePointer(
                    ignoring: i != _shown,
                    child: Opacity(
                      opacity: i == _shown
                          ? inT
                          : (i == _leaving ? outO.toDouble() : 0),
                      child: i == _shown && !reduced
                          ? Transform.scale(
                              scale: 0.96 + 0.04 * inT,
                              child: widget.children[i],
                            )
                          : widget.children[i],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// --------------------------------------------------------- §7 circle reveal

/// Clips a page to a circle around [center] that, at fraction 1, reaches the
/// farthest corner.
class CircleRevealClipper extends CustomClipper<Path> {
  CircleRevealClipper(this.center, this.fraction);
  final Offset center;
  final double fraction;

  @override
  Path getClip(Size size) {
    final far = [
      Offset.zero,
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ].map((c) => (c - center).distance).reduce(math.max);
    return Path()
      ..addOval(Rect.fromCircle(center: center, radius: far * fraction));
  }

  @override
  bool shouldReclip(CircleRevealClipper old) =>
      old.fraction != fraction || old.center != center;
}

/// Centre of a widget on screen, for a circle reveal's origin.
Offset? centerOf(GlobalKey key) {
  final box = key.currentContext?.findRenderObject();
  if (box is! RenderBox || !box.hasSize) return null;
  return box.localToGlobal(box.size.center(Offset.zero));
}

/// Entering an institute: a circle grows from [origin] (520ms, reverse
/// 400ms). Reduced motion: a fade. Without an origin it grows from the
/// screen's centre.
CustomTransitionPage<T> circleRevealPage<T>(
  GoRouterState state,
  Widget child, {
  Offset? origin,
  bool opaque = true,
}) => CustomTransitionPage<T>(
  key: state.pageKey,
  opaque: opaque,
  transitionDuration: MasirMotion.threshold,
  reverseTransitionDuration: MasirMotion.long,
  transitionsBuilder: (context, a, _, child) {
    if (MasirMotion.reduced(context)) {
      return FadeTransition(opacity: a, child: child);
    }
    final curved = CurvedAnimation(
      parent: a,
      curve: MasirMotion.standard,
      reverseCurve: MasirMotion.exit,
    );
    return AnimatedBuilder(
      animation: curved,
      child: child,
      builder: (context, child) {
        final size = MediaQuery.sizeOf(context);
        return ClipPath(
          clipper: CircleRevealClipper(
            origin ?? size.center(Offset.zero),
            curved.value,
          ),
          child: child,
        );
      },
    );
  },
  child: child,
);

// ------------------------------------------------------------------ §8 press

/// Anything with a lip: sinks onto its lip on tap down (90ms, standard) and
/// pops back with a slight overshoot on release (120ms, spring). The action
/// fires on tap-up, never after the animation. Reduced motion: no movement,
/// the lip just disappears while pressed.
class MasirPressable extends StatefulWidget {
  /// Builds the element for the current press state (`pressed` true while
  /// the finger is down). Move it with [sink] and drop the lip when pressed.
  final Widget Function(BuildContext context, bool pressed) builder;
  final VoidCallback? onTap;
  final double sink;
  final String? semanticLabel;
  final bool selected;

  const MasirPressable({
    super.key,
    required this.builder,
    this.onTap,
    this.sink = 4,
    this.semanticLabel,
    this.selected = false,
  });

  @override
  State<MasirPressable> createState() => _MasirPressableState();
}

class _MasirPressableState extends State<MasirPressable> {
  bool _down = false;

  void _set(bool v) {
    if (widget.onTap == null || _down == v) return;
    setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    final reduced = MasirMotion.reduced(context);
    final body = AnimatedContainer(
      duration: _down ? MasirMotion.instant : MasirMotion.release,
      curve: _down ? MasirMotion.standard : MasirMotion.spring,
      transform: Matrix4.translationValues(
        0,
        _down && !reduced ? widget.sink : 0,
        0,
      ),
      child: widget.builder(context, _down),
    );
    if (widget.onTap == null) return body;
    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _set(true),
        onTapUp: (_) {
          _set(false);
          widget.onTap?.call();
        },
        onTapCancel: () => _set(false),
        child: body,
      ),
    );
  }
}

// ---------------------------------------------------------------- §11 stagger

/// First visit of a list screen: cards fade in and rise 10px, 220ms each,
/// 40ms apart; at most 6 animate (the rest come with the 6th). Coming back
/// to a screen never replays it: [id] marks the screen as seen.
class MasirStagger extends StatefulWidget {
  final String id;
  final List<Widget> children;
  final Widget Function(List<Widget> children) layout;
  const MasirStagger({
    super.key,
    required this.id,
    required this.children,
    this.layout = _column,
  });

  static Widget _column(List<Widget> c) =>
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: c);

  static final Set<String> _seen = {};

  /// Forget seen screens (sign-out).
  static void reset() => _seen.clear();

  @override
  State<MasirStagger> createState() => _MasirStaggerState();
}

class _MasirStaggerState extends State<MasirStagger>
    with SingleTickerProviderStateMixin {
  static const _max = 6;
  AnimationController? _c;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_c != null || MasirStagger._seen.contains(widget.id)) return;
    MasirStagger._seen.add(widget.id);
    if (MasirMotion.reduced(context)) return;
    final total =
        MasirMotion.short + const Duration(milliseconds: 40) * (_max - 1);
    _c = AnimationController(vsync: this, duration: total)..forward();
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _c;
    if (c == null) return widget.layout(widget.children);
    final totalMs = c.duration!.inMilliseconds;
    return widget.layout([
      for (var i = 0; i < widget.children.length; i++)
        _Staggered(
          animation: CurvedAnimation(
            parent: c,
            curve: Interval(
              (math.min(i, _max - 1) * 40) / totalMs,
              (math.min(i, _max - 1) * 40 + MasirMotion.short.inMilliseconds) /
                  totalMs,
              curve: MasirMotion.standard,
            ),
          ),
          child: widget.children[i],
        ),
    ]);
  }
}

class _Staggered extends AnimatedWidget {
  final Widget child;
  const _Staggered({required Animation<double> animation, required this.child})
    : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final t = (listenable as Animation<double>).value;
    return Opacity(
      opacity: t,
      child: Transform.translate(offset: Offset(0, 10 * (1 - t)), child: child),
    );
  }
}

// --------------------------------------------------------------- §12 count-up

/// Counts from the previous value to [value] (600ms, standard) in Persian
/// digits. The first time it counts from [from]. Reduced motion: jumps.
class MasirCountUp extends StatefulWidget {
  final num value;
  final num from;
  final String Function(String digits) format;
  final TextStyle? style;
  final TextAlign? textAlign;
  const MasirCountUp({
    super.key,
    required this.value,
    this.from = 0,
    this.format = _plain,
    this.style,
    this.textAlign,
  });

  static String _plain(String d) => d;

  /// «۴۵٪»
  static String percent(String d) => '$d٪';

  @override
  State<MasirCountUp> createState() => _MasirCountUpState();
}

class _MasirCountUpState extends State<MasirCountUp> {
  late double _begin = widget.from.toDouble();

  @override
  void didUpdateWidget(MasirCountUp old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) _begin = old.value.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final end = widget.value.toDouble();
    if (MasirMotion.reduced(context)) {
      return Text(
        widget.format(fa(end.round())),
        style: widget.style,
        textAlign: widget.textAlign,
      );
    }
    return TweenAnimationBuilder<double>(
      key: ValueKey(end),
      tween: Tween(begin: _begin, end: end),
      duration: MasirMotion.celebrate,
      curve: MasirMotion.standard,
      builder: (_, v, _) => Text(
        widget.format(fa(v.round())),
        style: widget.style,
        textAlign: widget.textAlign,
      ),
    );
  }
}

/// A value 0–1 that moves from the previous value to the new one (600ms,
/// standard): bars and rings. Reduced motion: jumps.
class MasirProgress extends StatefulWidget {
  final double value;
  final double from;
  final Widget Function(BuildContext context, double value) builder;
  const MasirProgress({
    super.key,
    required this.value,
    this.from = 0,
    required this.builder,
  });

  @override
  State<MasirProgress> createState() => _MasirProgressState();
}

class _MasirProgressState extends State<MasirProgress> {
  late double _begin = widget.from;

  @override
  void didUpdateWidget(MasirProgress old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) _begin = old.value;
  }

  @override
  Widget build(BuildContext context) {
    if (MasirMotion.reduced(context)) {
      return widget.builder(context, widget.value);
    }
    return TweenAnimationBuilder<double>(
      key: ValueKey(widget.value),
      tween: Tween(begin: _begin, end: widget.value),
      duration: MasirMotion.celebrate,
      curve: MasirMotion.standard,
      builder: (context, v, _) => widget.builder(context, v),
    );
  }
}
