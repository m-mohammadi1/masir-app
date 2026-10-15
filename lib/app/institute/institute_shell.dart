import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/app/routes.dart';
import '/app/state/session.dart';
import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/api/models.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

/// Institutes loaded this session, so entering one paints its colours at once.
class InstituteCache {
  InstituteCache._();
  static final Map<String, InstituteDetail> _items = {};

  static InstituteDetail? peek(String id) => _items[id];

  static Future<Res<InstituteDetail>> load(String id) async {
    final res = await inject<MasirApi>().institute(id);
    res.fold((_) {}, (d) => _items[id] = d);
    return res;
  }

  static void forget(String id) => _items.remove(id);
}

/// The institute space: takes the institute's colours, coloured top bar with
/// the switcher and the «مسیر» exit pill, and four tabs.
class InstituteShell extends StatefulWidget {
  final String instituteId;
  final String location;
  final Widget child;
  const InstituteShell({super.key, required this.instituteId, required this.location, required this.child});

  @override
  State<InstituteShell> createState() => _InstituteShellState();
}

class _InstituteShellState extends State<InstituteShell> {
  InstituteDetail? _detail;

  @override
  void initState() {
    super.initState();
    _detail = InstituteCache.peek(widget.instituteId);
    if (_detail != null) _enter(_detail!);
    InstituteCache.load(widget.instituteId).then((r) => r.fold((_) {}, (d) {
      if (!mounted) return;
      setState(() => _detail = d);
      _enter(d);
    }));
  }

  void _enter(InstituteDetail d) =>
      WidgetsBinding.instance.addPostFrameCallback((_) => Session.enterInstitute(d.id, d.brand));

  int get _index {
    final l = widget.location;
    if (l.endsWith('/courses')) return 1;
    if (l.endsWith('/teachers')) return 2;
    if (l.endsWith('/me')) return 3;
    return 0;
  }

  static const _titles = ['', 'دوره‌ها', 'اساتید', 'من در این مؤسسه'];

  @override
  Widget build(BuildContext context) {
    final d = _detail;
    final brand = d?.brand ?? Brand.masir;
    final id = widget.instituteId;
    return BrandScope(
      brand: brand,
      child: Scaffold(
        backgroundColor: C.paper,
        body: Column(children: [
          // The home tab draws its own header over the cover photo.
          if (_index != 0)
            InstituteBar(
              title: _titles[_index],
              onExit: () => context.go(Routes.vitrine),
              onSwitch: () => showInstituteSwitcher(context, currentId: id),
            ),
          Expanded(child: widget.child),
        ]),
        bottomNavigationBar: SpaceTabBar(
          items: instituteTabs,
          index: _index,
          onTap: (i) => context.go([Routes.instHome(id), Routes.instCourses(id), Routes.instTeachers(id), Routes.instMe(id)][i]),
        ),
      ),
    );
  }
}

/// Bottom sheet listing the student's institutes; picking one enters it.
Future<void> showInstituteSwitcher(BuildContext context, {required String currentId}) async {
  final res = await inject<MasirApi>().wallet();
  if (!context.mounted) return;
  final cards = res.fold((_) => <WalletCard>[], (w) => w);
  await showMasirSheet(context, builder: (ctx) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
    child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text('مؤسسه‌هات', style: T.of(19, FontWeight.w800)),
      const SizedBox(height: 12),
      for (final c in cards)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: PaperCard(
            padding: const EdgeInsets.all(12),
            border: c.institute.id == currentId ? c.institute.brand.palette.p : C.border,
            onTap: () {
              Navigator.pop(ctx);
              if (c.institute.id != currentId) context.go(Routes.threshold(c.institute.id));
            },
            child: Row(children: [
              InstituteLogo(brand: c.institute.brand, size: 40),
              const SizedBox(width: 12),
              Expanded(child: Text(c.institute.name, style: T.of(15, FontWeight.w800))),
              if (c.institute.id == currentId) Tag.success('اینجایی'),
            ]),
          ),
        ),
      Btn.secondary('خروج به مسیر', height: 52, onPressed: () {
        Navigator.pop(ctx);
        context.go(Routes.vitrine);
      }),
    ]),
  ));
}

/// Entering an institute: its colour grows from the top as a circle (520ms,
/// emphasized), shows the logo and name, then lands on the institute home.
Page<void> thresholdPage(GoRouterState state, String id) => CustomTransitionPage<void>(
  key: state.pageKey,
  opaque: false,
  transitionDuration: Duration.zero,
  child: _Threshold(instituteId: id),
  transitionsBuilder: (_, _, _, child) => child,
);

class _Threshold extends StatefulWidget {
  final String instituteId;
  const _Threshold({required this.instituteId});

  @override
  State<_Threshold> createState() => _ThresholdState();
}

class _ThresholdState extends State<_Threshold> with TickerProviderStateMixin {
  late final AnimationController _reveal = AnimationController(vsync: this, duration: Motion.threshold);
  late final AnimationController _dots = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();
  InstituteDetail? _detail;
  ApiError? _error;

  @override
  void initState() {
    super.initState();
    _detail = InstituteCache.peek(widget.instituteId);
    if (_detail != null) _reveal.forward();
    _go();
  }

  Future<void> _go() async {
    final started = DateTime.now();
    final api = inject<MasirApi>();
    final res = await InstituteCache.load(widget.instituteId);
    if (!mounted) return;
    await res.fold((e) async => setState(() => _error = e), (d) async {
      if (_detail == null) {
        setState(() => _detail = d);
        _reveal.forward();
      }
      if (d.isMember) await api.enterInstitute(widget.instituteId);
      final wait = const Duration(milliseconds: 1100) - DateTime.now().difference(started);
      if (wait > Duration.zero) await Future.delayed(wait);
      if (!mounted) return;
      Session.enterInstitute(d.id, d.brand);
      context.go(Routes.instHome(widget.instituteId));
    });
  }

  @override
  void dispose() {
    _reveal.dispose();
    _dots.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = _detail;
    if (_error != null) {
      return Scaffold(
        backgroundColor: C.paper,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: InlineError(title: 'وارد مؤسسه نشدیم', body: _error!.friendly, onRetry: () {
              setState(() => _error = null);
              _go();
            }),
          ),
        ),
      );
    }
    if (d == null) return const SizedBox.expand();
    final brand = d.brand;
    final pal = brand.palette;
    final reduced = Motion.reduced(context);
    final size = MediaQuery.sizeOf(context);
    return AnimatedBuilder(
      animation: _reveal,
      builder: (context, _) {
        final t = Motion.emphasized.transform(_reveal.value);
        final origin = Offset(size.width / 2, 160);
        final maxR = math.sqrt(math.pow(size.width, 2) + math.pow(size.height, 2)) + 40;
        final content = Stack(fit: StackFit.expand, children: [
          ColoredBox(color: pal.p),
          PatternFill(pattern: brand.pattern, color: pal.e),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  decoration: BoxDecoration(boxShadow: [lip(pal.e, 6)], borderRadius: BorderRadius.circular(34)),
                  child: InstituteLogo(brand: brand, size: 112, inverted: true, fontSize: 49),
                ),
                const SizedBox(height: 18),
                Opacity(opacity: .9, child: Text('داری وارد می‌شی', style: T.of(15, FontWeight.w600, pal.on))),
                const SizedBox(height: 6),
                Text(d.name, textAlign: TextAlign.center, style: T.of(30, FontWeight.w900, pal.on, 1.3)),
                const SizedBox(height: 18),
                AnimatedBuilder(
                  animation: _dots,
                  builder: (_, _) => Row(mainAxisSize: MainAxisSize.min, children: [
                    for (var i = 0; i < 3; i++) ...[
                      if (i > 0) const SizedBox(width: 6),
                      Opacity(
                        opacity: reduced ? [1.0, .6, .3][i] : (1 - ((_dots.value * 3 - i) % 3) / 3).clamp(.3, 1),
                        child: Container(width: 8, height: 8, decoration: BoxDecoration(color: pal.on, shape: BoxShape.circle)),
                      ),
                    ],
                  ]),
                ),
              ]),
            ),
          ),
        ]);
        if (reduced) return Opacity(opacity: t, child: content);
        return ClipPath(clipper: _CircleClip(origin, maxR * t), child: content);
      },
    );
  }
}

class _CircleClip extends CustomClipper<Path> {
  final Offset center;
  final double radius;
  _CircleClip(this.center, this.radius);

  @override
  Path getClip(Size size) => Path()..addOval(Rect.fromCircle(center: center, radius: radius));

  @override
  bool shouldReclip(_CircleClip old) => old.radius != radius || old.center != center;
}
