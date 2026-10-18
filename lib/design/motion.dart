import 'dart:math' as math;

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'tokens.dart' show C, fa;

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

/// [masirPush] for routes go_router and Navigator build by default
/// (MaterialPage, MaterialPageRoute), so every platform moves the same way.
class MasirPushTransitions extends PageTransitionsBuilder {
  const MasirPushTransitions();

  @override
  Duration get transitionDuration => MasirMotion.medium;

  @override
  Duration get reverseTransitionDuration => MasirMotion.back;

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => masirPush(context, animation, secondaryAnimation, child);
}

// ---------------------------------------------------------- §4 fade-through

/// Peer screens (Splash → Intro, Login → Vitrine, Quiz → QuizResult): the
/// old one is gone (go() drops it), the new one fades in from 96% scale over
/// paper. 300ms.
CustomTransitionPage<T> masirFadeThroughPage<T>(
  GoRouterState state,
  Widget child, {
  Duration duration = MasirMotion.medium,
}) => CustomTransitionPage<T>(
  key: state.pageKey,
  transitionDuration: duration,
  reverseTransitionDuration: duration,
  transitionsBuilder: (context, a, _, child) => masirFadeIn(context, a, child),
  child: child,
);

/// The second half of a fade-through: paper at once, then the new screen
/// fades in from 96% scale. Reduced motion: a plain fade.
Widget masirFadeIn(BuildContext context, Animation<double> a, Widget child) {
  if (MasirMotion.reduced(context)) {
    return FadeTransition(opacity: a, child: child);
  }
  final t = CurvedAnimation(
    parent: a,
    curve: const Interval(.3, 1, curve: MasirMotion.standard),
  );
  return ColoredBox(
    color: C.paper,
    child: FadeTransition(
      opacity: t,
      child: ScaleTransition(
        scale: Tween(begin: .96, end: 1.0).animate(t),
        child: child,
      ),
    ),
  );
}

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

/// Where the student last touched the screen, so a circle reveal can grow
/// from the badge they tapped without every caller passing it along.
abstract final class TapOrigin {
  static Offset? _at;
  static DateTime? _when;

  /// The last touch, if it was within the last second.
  static Offset? get recent {
    final w = _when;
    if (w == null ||
        DateTime.now().difference(w) > const Duration(seconds: 1)) {
      return null;
    }
    return _at;
  }

  /// Wrap the app with this to record touches.
  static Widget recorder(Widget child) => Listener(
    behavior: HitTestBehavior.translucent,
    onPointerDown: (e) {
      _at = e.position;
      _when = DateTime.now();
    },
    child: child,
  );
}

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
      // Its own node (a parent card's label must not swallow the button),
      // and with a label the visible text inside isn't read a second time.
      container: true,
      excludeSemantics: widget.semanticLabel != null,
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
    // Spacers don't take a slot; they move with the card after them.
    var slot = 0;
    final slots = [
      for (final w in widget.children) w is SizedBox ? slot : slot++,
    ];
    return widget.layout([
      for (var i = 0; i < widget.children.length; i++)
        _Staggered(
          animation: CurvedAnimation(
            parent: c,
            curve: Interval(
              (math.min(slots[i], _max - 1) * 40) / totalMs,
              (math.min(slots[i], _max - 1) * 40 +
                      MasirMotion.short.inMilliseconds) /
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

// ------------------------------------------------------------ §14 celebration

/// The trophy or check of a big moment: scales 0.6 → 1.12 → 1 and fades in
/// (450ms, spring). Reduced motion: shown as is.
class MasirPopIn extends StatelessWidget {
  final Widget child;
  const MasirPopIn({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (MasirMotion.reduced(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 450),
      builder: (_, t, child) => Opacity(
        opacity: (t * 2.5).clamp(0, 1),
        child: Transform.scale(
          scale: t < .6
              ? 0.6 + 0.52 * MasirMotion.standard.transform(t / .6)
              : 1.12 - 0.12 * MasirMotion.spring.transform((t - .6) / .4),
          child: child,
        ),
      ),
      child: child,
    );
  }
}

/// The headline of a big moment: fades up 8px after [delay].
class MasirRiseIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  const MasirRiseIn({
    super.key,
    required this.child,
    this.delay = const Duration(milliseconds: 250),
  });

  @override
  State<MasirRiseIn> createState() => _MasirRiseInState();
}

class _MasirRiseInState extends State<MasirRiseIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: MasirMotion.medium,
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MasirMotion.reduced(context)) return widget.child;
    return AnimatedBuilder(
      animation: _c,
      child: widget.child,
      builder: (_, child) {
        final t = MasirMotion.standard.transform(_c.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, 8 * (1 - t)),
            child: child,
          ),
        );
      },
    );
  }
}

/// About 16 pieces burst out of the middle once (900ms) and fall away.
/// Place it over the trophy with Positioned.fill. Reduced motion: nothing.
class MasirConfetti extends StatefulWidget {
  final List<Color> colors;
  const MasirConfetti({super.key, required this.colors});

  @override
  State<MasirConfetti> createState() => _MasirConfettiState();
}

class _MasirConfettiState extends State<MasirConfetti>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: MasirMotion.confetti,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!MasirMotion.reduced(context) && _c.isDismissed) _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MasirMotion.reduced(context)) return const SizedBox.shrink();
    return IgnorePointer(
      child: CustomPaint(painter: _ConfettiPainter(_c, widget.colors)),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final Animation<double> t;
  final List<Color> colors;
  _ConfettiPainter(this.t, this.colors) : super(repaint: t);

  static const _n = 16;

  @override
  void paint(Canvas canvas, Size size) {
    final v = t.value;
    if (v <= 0 || v >= 1) return;
    final c = size.center(Offset.zero);
    final reach = math.min(size.width, size.height) * .6 + 40;
    final out = MasirMotion.standard.transform(v);
    final paint = Paint();
    for (var i = 0; i < _n; i++) {
      // Spread evenly with a little jitter, mostly upwards.
      final angle =
          -math.pi / 2 +
          (i / _n - .5) * math.pi * 1.7 +
          (i.isEven ? .12 : -.08);
      final dist = reach * (.65 + (i % 4) * .12) * out;
      final fall = 70 * v * v;
      final pos =
          c + Offset(math.cos(angle) * dist, math.sin(angle) * dist + fall);
      paint.color = colors[i % colors.length].withValues(
        alpha: (1 - math.max(0, v - .6) / .4).clamp(0, 1),
      );
      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(angle + v * (i.isEven ? 6 : -5));
      final rect = i % 3 == 0
          ? const Rect.fromLTWH(-4, -4, 8, 8)
          : const Rect.fromLTWH(-6, -2.5, 12, 5);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(2)),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => false;
}

// ------------------------------------------------------------------ §15 shake

/// Shakes [child] sideways (0 → 6 → −6 → 6 → −6 → 0 px, 300ms) each time
/// [error] turns into a new message. The field only, never the screen.
/// Reduced motion: still.
class MasirShake extends StatefulWidget {
  final Object? error;
  final Widget child;
  const MasirShake({super.key, required this.error, required this.child});

  @override
  State<MasirShake> createState() => _MasirShakeState();
}

class _MasirShakeState extends State<MasirShake>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: MasirMotion.medium,
  );

  @override
  void didUpdateWidget(MasirShake old) {
    super.didUpdateWidget(old);
    if (widget.error != null &&
        widget.error != false &&
        widget.error != old.error &&
        !MasirMotion.reduced(context)) {
      _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    child: widget.child,
    builder: (_, child) {
      final t = _c.value;
      // Four half-swings that settle back to rest.
      final dx = _c.isAnimating ? 6 * math.sin(t * math.pi * 4) : 0.0;
      return Transform.translate(offset: Offset(dx, 0), child: child);
    },
  );
}

// ------------------------------------------------------------ steps (§3 short)

/// Steps inside one screen (sign-up steps, quiz questions): a short push.
/// The next step comes in from the reading side (220ms) and the old one
/// leaves the other way; going back reverses it. Reduced motion: a fade.
class MasirStepSwitcher extends StatelessWidget {
  final int step;
  final bool forward;
  final Widget child;
  const MasirStepSwitcher({
    super.key,
    required this.step,
    required this.forward,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final reduced = MasirMotion.reduced(context);
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return ClipRect(
      child: AnimatedSwitcher(
        duration: reduced ? MasirMotion.quick : MasirMotion.short,
        switchInCurve: MasirMotion.standard,
        switchOutCurve: MasirMotion.exit,
        layoutBuilder: (current, previous) => Stack(
          alignment: Alignment.topCenter,
          children: [...previous, ?current],
        ),
        transitionBuilder: (child, a) {
          final fade = FadeTransition(opacity: a, child: child);
          if (reduced) return fade;
          final incoming = child.key == ValueKey(step);
          // RTL forward: in from the left, out to the right.
          final side = (rtl ? -1.0 : 1.0) * (forward ? 1 : -1);
          return SlideTransition(
            position: Tween(
              begin: Offset(side * (incoming ? .3 : -.3), 0),
              end: Offset.zero,
            ).animate(a),
            child: fade,
          );
        },
        child: KeyedSubtree(key: ValueKey(step), child: child),
      ),
    );
  }
}
