import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '/app/common/video.dart';
import '/app/course/plan_sheet.dart';
import '/app/routes.dart';
import '/app/state/progress_events.dart';
import '/app/state/load_cubit.dart';
import '/app/state/nav.dart';
import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/api/models.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

/// «جزئیات دوره»: intro video, what the course is, its price ticket, its
/// chapters, outcomes, audience, teacher and FAQ, with a bottom bar that
/// follows the student's access (guest, active, expiring, expired).
class CourseDetailPage extends StatelessWidget {
  final String courseId;
  const CourseDetailPage({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) =>
        LoadCubit<CourseDetail>(() => inject<MasirApi>().course(courseId))
          ..load(),
    child: Builder(
      builder: (context) => ReloadOnProgress(
        onChange: () => context.read<LoadCubit<CourseDetail>>().load(),
        child: BlocBuilder<LoadCubit<CourseDetail>, Load<CourseDetail>>(
          builder: (context, s) {
            final d = s.data;
            return BrandScope(
              brand: d?.instituteBrand ?? context.brand,
              child: Scaffold(
                backgroundColor: C.paper,
                body: d == null
                    ? LoadView<CourseDetail>(
                        skeleton: const _Skeleton(),
                        builder: (_, _) => const SizedBox(),
                      )
                    : _Body(d: d),
                bottomNavigationBar: d == null ? null : _BottomBar(d: d),
              ),
            );
          },
        ),
      ),
    ),
  );
}

class _Body extends StatelessWidget {
  final CourseDetail d;
  const _Body({required this.d});

  @override
  Widget build(BuildContext context) {
    final c = d.card;
    final pal = context.pal;
    final brand = context.brand;
    return RefreshIndicator(
      onRefresh: () => context.read<LoadCubit<CourseDetail>>().load(),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _Hero(d: d),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Who, what, how many.
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: GestureDetector(
                    onTap: () => context.push(Routes.threshold(c.instituteId)),
                    child: Container(
                      height: 36,
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        6,
                        0,
                        12,
                        0,
                      ),
                      decoration: BoxDecoration(
                        color: pal.soft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InstituteLogo(brand: brand, size: 26, fontSize: 13),
                          const SizedBox(width: 8),
                          Text(
                            brand.name,
                            style: T.of(14, FontWeight.w800, pal.ink),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(c.title, style: T.of(30, FontWeight.w900, C.ink, 1.35)),
                if (c.description.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    c.description,
                    style: T.of(16, FontWeight.w500, C.body, 1.9),
                  ),
                ],
                if (d.enrolledCount > 0) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _Faces(teachers: c.teachers),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            style: T.of(14, FontWeight.w500, C.body),
                            children: [
                              TextSpan(
                                text: '${fa(d.enrolledCount)} نفر',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const TextSpan(
                                text: ' الان دارن این دوره رو می‌خونن',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 28),
                Row(
                  children: [
                    if (c.level != null && levelNames[c.level] != null) ...[
                      Expanded(
                        child: _Fact(
                          icon: MI.level,
                          value: levelNames[c.level]!,
                          label: 'سطح',
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: _Fact(
                        icon: MI.listDots,
                        value: '${fa(c.unitCount)} واحد',
                        label: 'در ${fa(c.moduleCount)} فصل',
                      ),
                    ),
                    if (c.durationMinutes > 0) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: _Fact(
                          icon: MI.clock,
                          value: approxDuration(c.durationMinutes),
                          label: 'حدودی',
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 28),
                _Ticket(c: c),
                if (d.modules.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  SectionTitle(
                    'مسیر این دوره',
                    action: 'نقشه‌ی کامل',
                    onAction: () => context.push(Routes.roadmap(c.id)),
                  ),
                  const SizedBox(height: 14),
                  _Chapters(modules: d.modules),
                ],
                if (d.outcomes.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  Text(
                    'توی این دوره چی یاد می‌گیری؟',
                    style: T.of(20, FontWeight.w900),
                  ),
                  const SizedBox(height: 14),
                  for (final o in d.outcomes) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: C.surface,
                        border: Border.all(color: C.border, width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const _Check(),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(o, style: T.of(15, FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
                if (d.requirements.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Text('برای کی مناسبه؟', style: T.of(20, FontWeight.w900)),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    decoration: BoxDecoration(
                      color: C.surface,
                      border: Border.all(color: C.border, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        for (var i = 0; i < d.requirements.length; i++) ...[
                          if (i > 0) const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 1),
                                child: _Check(),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  d.requirements[i],
                                  style: T.of(15, FontWeight.w500, C.ink, 1.8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
                if (c.teachers.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  Text(
                    c.teachers.length > 1 ? 'استادها' : 'استاد',
                    style: T.of(20, FontWeight.w900),
                  ),
                  for (final t in c.teachers) ...[
                    const SizedBox(height: 14),
                    _TeacherRow(t: t),
                  ],
                ],
                const SizedBox(height: 28),
                Text('سؤال‌های رایج', style: T.of(20, FontWeight.w900)),
                const SizedBox(height: 12),
                for (final (i, f) in _faq(c).indexed) ...[
                  _Faq(q: f.$1, a: f.$2, open: i == 0),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<(String, String)> _faq(CourseCard c) => [
    if (c.freeCourse)
      (
        'این دوره پولیه؟',
        'نه؛ همه‌ی واحدهای این دوره رایگانه و اشتراک لازم نداره.',
      )
    else if (c.previewUnits > 0)
      (
        'اول می‌تونم امتحانش کنم؟',
        'آره؛ ${fa(c.previewUnits)} واحد اول رایگانه و اشتراک لازم نداره.',
      ),
    if (!c.freeCourse) ...[
      (
        'اشتراک که تموم شه چی می‌شه؟',
        'هیچ‌چیز پاک نمی‌شه. پیشرفت و جام‌هات می‌مونن و با تمدید، از همون‌جا ادامه می‌دی.',
      ),
      (
        'تمدید خودکاره؟',
        'نه. ۷، ۳ و ۱ روز قبل از پایان، با اعلان و پیامک یادآوری می‌گیری و خودت تمدید می‌کنی.',
      ),
    ],
    (
      'واحدهای تموم‌شده رو دوباره می‌تونم ببینم؟',
      'آره؛ هر واحدی که باز شده رو هر وقت خواستی از نقشه دوباره باز کن.',
    ),
  ];
}

class _Hero extends StatelessWidget {
  final CourseDetail d;
  const _Hero({required this.d});

  @override
  Widget build(BuildContext context) {
    final c = d.card;
    final top = MediaQuery.paddingOf(context).top;
    final poster = CoverImage(url: c.coverUrl, brand: context.brand);
    Widget white(MI icon, String label, VoidCallback onTap) => Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(color: Color(0x2E000000), offset: Offset(0, 3)),
            ],
          ),
          alignment: Alignment.center,
          child: MIcon(icon, size: 22, strokeWidth: 2.4),
        ),
      ),
    );
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      child: SizedBox(
        height: 240 + top,
        child: ColoredBox(
          color: const Color(0xFF1A1622),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: EdgeInsets.only(top: top),
                child: c.introVideoUrl.isNotEmpty
                    ? MasirVideo(
                        url: c.introVideoUrl,
                        poster: poster,
                        durationSeconds: c.introVideoSeconds,
                        posterLabel: c.introVideoSeconds > 0
                            ? 'ویدیوی معرفی · ${clock(c.introVideoSeconds)}'
                            : 'ویدیوی معرفی',
                      )
                    : poster,
              ),
              if (c.introVideoUrl.isEmpty)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 90 + top,
                  child: const _TopShade(),
                ),
              Positioned(
                top: top + 12,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    white(MI.back, 'برگشت', () => back(context)),
                    const Spacer(),
                    white(
                      MI.share,
                      'اشتراک‌گذاری',
                      () => SharePlus.instance.share(
                        ShareParams(text: '«${c.title}» رو توی مسیر ببین'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopShade extends StatelessWidget {
  const _TopShade();
  @override
  Widget build(BuildContext context) => const DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x7314101C), Color(0x0014101C)],
      ),
    ),
  );
}

class _Faces extends StatelessWidget {
  final List<TeacherSummary> teachers;
  const _Faces({required this.teachers});

  @override
  Widget build(BuildContext context) {
    final faces = teachers.take(3).toList();
    if (faces.isEmpty) return const SizedBox();
    return SizedBox(
      width: 28 + (faces.length - 1) * 18,
      height: 28,
      child: Stack(
        children: [
          for (var i = 0; i < faces.length; i++)
            PositionedDirectional(
              start: i * 18,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: C.paper, width: 2),
                ),
                child: ClipOval(
                  child: Avatar(
                    url: faces[i].photoUrl,
                    name: faces[i].name,
                    size: 24,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  final MI icon;
  final String value;
  final String label;
  const _Fact({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
    decoration: cardDecoration(radius: 18),
    child: Column(
      children: [
        MIcon(icon, size: 22, color: context.pal.p, strokeWidth: 2.6),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          style: T.of(15, FontWeight.w800),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: T.of(12, FontWeight.w500, C.muted),
        ),
      ],
    ),
  );
}

/// Ticket: price on the right, the free stub on the left behind a dashed tear.
class _Ticket extends StatelessWidget {
  final CourseCard c;
  const _Ticket({required this.c});

  @override
  Widget build(BuildContext context) {
    final plans = c.plans
        .map((p) => planNames[p.period])
        .whereType<String>()
        .toList();
    final String head;
    final String price;
    final String sub;
    if (c.freeCourse) {
      head = 'این دوره';
      price = 'کاملاً رایگان';
      sub = 'همه‌ی ${fa(c.unitCount)} واحد بدون اشتراک باز می‌شن';
    } else {
      head = 'اشتراک این دوره';
      price = 'از ${perMonth(c.fromPerMonth)} تومان';
      sub = plans.length > 1
          ? '${plans.sublist(0, plans.length - 1).join('، ')} یا ${plans.last}'
          : plans.join();
    }
    final stub = !c.freeCourse && c.previewUnits > 0;
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [BoxShadow(color: C.lip, offset: Offset(0, 4))],
        borderRadius: BorderRadius.all(Radius.circular(22)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: C.surface,
                      borderRadius: stub
                          ? const BorderRadiusDirectional.horizontal(
                              start: Radius.circular(22),
                            ).resolve(Directionality.of(context))
                          : BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(head, style: T.of(13, FontWeight.w500, C.muted)),
                        const SizedBox(height: 2),
                        Text(price, style: T.of(20, FontWeight.w800)),
                        if (sub.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(sub, style: T.of(13, FontWeight.w500, C.muted)),
                        ],
                      ],
                    ),
                  ),
                ),
                if (stub)
                  Container(
                    width: 118,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: C.greenSoft,
                      borderRadius: const BorderRadiusDirectional.horizontal(
                        end: Radius.circular(22),
                      ).resolve(Directionality.of(context)),
                    ),
                    child: CustomPaint(
                      painter: _DashedEdge(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${fa(c.previewUnits)} واحد اول',
                            textAlign: TextAlign.center,
                            style: T.of(17, FontWeight.w800, C.greenText),
                          ),
                          Text(
                            'رایگان',
                            style: T.of(13, FontWeight.w700, C.greenText),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (stub) ...[
            PositionedDirectional(end: 107, top: -11, child: const _Notch()),
            PositionedDirectional(end: 107, bottom: -11, child: const _Notch()),
          ],
        ],
      ),
    );
  }
}

class _Notch extends StatelessWidget {
  const _Notch();
  @override
  Widget build(BuildContext context) => Container(
    width: 22,
    height: 22,
    decoration: const BoxDecoration(color: C.paper, shape: BoxShape.circle),
  );
}

/// The dashed tear line on the stub's inner edge.
class _DashedEdge extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFFBFE6CD)
      ..strokeWidth = 3;
    // RTL: the stub sits on the left, so its inner edge is the right side.
    final x = size.width + 12 - 1.5;
    for (double y = -12; y < size.height + 12; y += 10) {
      canvas.drawLine(Offset(x, y), Offset(x, y + 5), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Chapters extends StatelessWidget {
  final List<CourseModuleSummary> modules;
  const _Chapters({required this.modules});

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    Widget square(Widget child, Color bg, Color lipC) => Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [lip(lipC)],
      ),
      alignment: Alignment.center,
      child: child,
    );
    final rows = <Widget>[];
    for (var i = 0; i < modules.length; i++) {
      final m = modules[i];
      final allFree = m.freeUnits > 0 && m.freeUnits >= m.unitCount;
      final sub = allFree
          ? '${fa(m.unitCount)} واحد، همه رایگان'
          : m.freeUnits > 0
          ? '${fa(m.unitCount)} واحد، ${fa(m.freeUnits)} تاش رایگان'
          : '${fa(m.pathCount)} مسیر، ${fa(m.unitCount)} واحد';
      rows.add(
        Row(
          children: [
            allFree
                ? square(
                    Text(fa(i + 1), style: T.of(18, FontWeight.w900, C.sunInk)),
                    C.sun,
                    C.sunDark,
                  )
                : square(
                    Text(fa(i + 1), style: T.of(18, FontWeight.w900, pal.on)),
                    pal.p,
                    pal.e,
                  ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m.title, style: T.of(16, FontWeight.w800)),
                  Text(sub, style: T.of(13, FontWeight.w500, C.muted)),
                ],
              ),
            ),
            if (m.freeUnits > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: C.sunSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'رایگان',
                  style: T.of(12, FontWeight.w800, C.sunText),
                ),
              ),
          ],
        ),
      );
    }
    rows.add(
      Row(
        children: [
          square(
            const MIcon(
              MI.flag,
              size: 22,
              color: Colors.white,
              strokeWidth: 2.4,
            ),
            C.ink,
            const Color(0xFF0E0C12),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'پایان مسیر و ${fa(modules.length)} جام فصل',
              style: T.of(16, FontWeight.w800),
            ),
          ),
        ],
      ),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: C.surface,
        border: Border.all(color: C.border, width: 2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          // Dashed trail behind the squares.
          PositionedDirectional(
            start: 21,
            top: 24,
            bottom: 24,
            child: CustomPaint(
              size: const Size(6, double.infinity),
              painter: _Trail(pal.soft),
            ),
          ),
          Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0) const SizedBox(height: 22),
                rows[i],
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _Trail extends CustomPainter {
  final Color color;
  _Trail(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color;
    for (double y = 0; y < size.height; y += 18) {
      canvas.drawRRect(
        RRect.fromLTRBR(
          0,
          y,
          size.width,
          (y + 10).clamp(0, size.height),
          const Radius.circular(3),
        ),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _Trail old) => old.color != color;
}

class _Check extends StatelessWidget {
  const _Check();
  @override
  Widget build(BuildContext context) => Container(
    width: 28,
    height: 28,
    decoration: const BoxDecoration(color: C.green, shape: BoxShape.circle),
    alignment: Alignment.center,
    child: const MIcon(
      MI.check,
      size: 14,
      color: Colors.white,
      strokeWidth: 3.4,
    ),
  );
}

class _TeacherRow extends StatelessWidget {
  final TeacherSummary t;
  const _TeacherRow({required this.t});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => context.push(Routes.teacher(t.userId)),
    child: Row(
      children: [
        Transform.rotate(
          angle: -4 * 3.14159 / 180,
          child: Container(
            width: 92,
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 18),
            decoration: BoxDecoration(
              color: C.surface,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: C.border, width: 2),
              boxShadow: [lip(C.lip, 3)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: SizedBox(
                height: 80,
                child: t.photoUrl.isNotEmpty
                    ? CoverImage(url: t.photoUrl)
                    : Avatar(name: t.name, size: 80),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.name, style: T.of(17, FontWeight.w800)),
              if (t.headline.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(t.headline, style: T.of(14, FontWeight.w500, C.muted)),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

class _Faq extends StatefulWidget {
  final String q;
  final String a;
  final bool open;
  const _Faq({required this.q, required this.a, this.open = false});

  @override
  State<_Faq> createState() => _FaqState();
}

class _FaqState extends State<_Faq> {
  late bool _open = widget.open;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: C.surface,
      border: Border.all(color: C.border, width: 2),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          expanded: _open,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => _open = !_open),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 52),
              child: Row(
                children: [
                  Expanded(
                    child: Text(widget.q, style: T.of(15, FontWeight.w800)),
                  ),
                  AnimatedRotation(
                    turns: _open ? .5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const MIcon(
                      MI.chevronDown,
                      size: 20,
                      color: C.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.topCenter,
          child: _open
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Text(
                    widget.a,
                    style: T.of(14, FontWeight.w500, C.body, 1.9),
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    ),
  );
}

/// Bottom bar per access state.
class _BottomBar extends StatefulWidget {
  final CourseDetail d;
  const _BottomBar({required this.d});

  @override
  State<_BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<_BottomBar> {
  bool _busy = false;

  CourseCard get c => widget.d.card;

  Future<void> _reload() => context.read<LoadCubit<CourseDetail>>().load();

  Future<void> _plans({bool renew = false}) async {
    await showPlanSheet(
      context,
      courseId: c.id,
      renew: renew,
      brand: context.brand,
    );
    if (mounted) _reload();
  }

  Future<void> _start() async {
    setState(() => _busy = true);
    final api = inject<MasirApi>();
    final r = await api.enroll(c.id);
    if (!mounted) return;
    final failed = r.fold((e) => e, (_) => null);
    if (failed != null) {
      setState(() => _busy = false);
      Toast.show(
        context,
        title: 'شروع نشد',
        body: failed.friendly,
        tone: ToastTone.error,
      );
      return;
    }
    final o = await api.outline(c.id);
    if (!mounted) return;
    setState(() => _busy = false);
    final first = o.fold(
      (_) => null,
      (o) => o.currentUnit ?? o.units.firstOrNull,
    );
    await showStartedSheet(context, course: c, first: first);
    if (mounted) _reload();
  }

  @override
  Widget build(BuildContext context) {
    final a = c.access;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final Widget body;
    Widget progress() => Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${fa(c.completedUnits)} از ${fa(c.unitCount)} واحد، ${pct(c.progressPercent)}',
                style: T.of(13, FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Track(value: c.progressPercent / 100, height: 8),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Btn(
          'ادامه یادگیری',
          expand: false,
          height: 54,
          fontSize: 16,
          onPressed: () => context.push(Routes.roadmap(c.id)),
        ),
      ],
    );
    switch (a.state) {
      case AccessState.guest:
        body = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Btn(
              c.freeCourse ? 'شروع دوره' : 'شروع رایگان',
              height: 54,
              fontSize: 17,
              loading: _busy,
              onPressed: _start,
            ),
            if (!c.freeCourse && c.fromPerMonth > 0) ...[
              const SizedBox(height: 8),
              Btn(
                'یا همین حالا اشتراک بگیر · از ${perMonth(c.fromPerMonth)}',
                kind: BtnKind.ghost,
                height: 44,
                fontSize: 15,
                onPressed: _plans,
              ),
            ],
          ],
        );
      case AccessState.trial:
        final left = (c.previewUnits - c.completedUnits).clamp(
          0,
          c.previewUnits,
        );
        body = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            progress(),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    left > 0
                        ? 'بخش رایگان · ${fa(left)} واحد رایگان مونده'
                        : 'بخش رایگان تموم شد؛ بقیه با اشتراک باز می‌شن.',
                    style: T.of(12, FontWeight.w500, C.muted),
                  ),
                ),
                GestureDetector(
                  onTap: _plans,
                  child: Text(
                    'اشتراک بگیر',
                    style: T.of(13, FontWeight.w800, context.pal.ink),
                  ),
                ),
              ],
            ),
          ],
        );
      case AccessState.active:
      case AccessState.freeCourse:
        body = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            progress(),
            if (a.paidActive && a.accessEndsAt != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const MIcon(
                    MI.check,
                    size: 16,
                    color: C.greenText,
                    strokeWidth: 3,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'اشتراک ${planNames[a.plan] ?? ''} · تا ${jDay(a.accessEndsAt!)}',
                    style: T.of(12, FontWeight.w500, C.muted),
                  ),
                ],
              ),
            ],
          ],
        );
      case AccessState.expiring:
        body = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 8, 8),
              decoration: BoxDecoration(
                color: C.sunSoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        style: T.of(
                          14,
                          FontWeight.w500,
                          const Color(0xFF5A3B00),
                          1.7,
                        ),
                        children: [
                          TextSpan(
                            text: '${fa(a.daysLeft ?? 0)} روز',
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          const TextSpan(text: ' تا پایان اشتراکت مونده.'),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _plans(renew: true),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        widthFactor: 1,
                        child: Text(
                          'تمدید',
                          style: T.of(14, FontWeight.w800, C.sunText),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            progress(),
          ],
        );
      case AccessState.expired:
        final unit = c.currentUnit?.title;
        body = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text.rich(
              TextSpan(
                style: T.of(14, FontWeight.w500, C.body, 1.8),
                children: [
                  TextSpan(
                    text: a.accessEndsAt != null
                        ? 'اشتراکت ${jDay(a.accessEndsAt!)} تموم شد. '
                        : 'اشتراکت تموم شد. ',
                  ),
                  TextSpan(
                    text: 'پیشرفتت (${pct(c.progressPercent)}) سر جاشه',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  TextSpan(
                    text: unit != null
                        ? '؛ با تمدید از «$unit» ادامه می‌دی.'
                        : '؛ با تمدید از همون‌جا ادامه می‌دی.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Btn(
              'تمدید اشتراک',
              height: 54,
              fontSize: 17,
              onPressed: () => _plans(renew: true),
            ),
          ],
        );
    }
    return Container(
      decoration: const BoxDecoration(
        color: C.surface,
        border: Border(top: BorderSide(color: C.border, width: 2)),
      ),
      padding: EdgeInsets.fromLTRB(16, 12, 16, 20 + bottom),
      child: body,
    );
  }
}

/// «ایول، شروع کردی!»: after the free start, the first step and a way in.
Future<void> showStartedSheet(
  BuildContext context, {
  required CourseCard course,
  OutlineUnit? first,
}) {
  final locked = (course.unitCount - course.previewUnits).clamp(
    0,
    course.unitCount,
  );
  return showMasirSheet(
    context,
    builder: (sheet) {
      final pal = sheet.pal;
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 140,
              height: 124,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 2,
                    right: 4,
                    child: Transform.rotate(
                      angle: .35,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: C.sun,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: C.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    left: 6,
                    child: Transform.rotate(
                      angle: -.52,
                      child: Container(
                        width: 14,
                        height: 6,
                        decoration: BoxDecoration(
                          color: pal.p,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 112,
                    height: 112,
                    decoration: BoxDecoration(
                      color: pal.p,
                      borderRadius: BorderRadius.circular(34),
                      boxShadow: [lip(pal.e, 6)],
                    ),
                    alignment: Alignment.center,
                    child: MasirSmallMark(size: 56, color: pal.on),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('ایول، شروع کردی!', style: T.of(26, FontWeight.w900)),
            const SizedBox(height: 6),
            Text(
              course.freeCourse
                  ? 'همه‌ی واحدهای «${course.title}» رایگانه. قدم‌به‌قدم برو جلو.'
                  : '${fa(course.previewUnits)} واحد اول «${course.title}» رایگانه. بقیه‌ی ${fa(locked)} واحد با اشتراک باز می‌شن، هر وقت آماده بودی.',
              textAlign: TextAlign.center,
              style: T.of(15, FontWeight.w500, C.body, 1.9),
            ),
            if (first != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: C.sand,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: MIcon(
                        unitIcon(first.type),
                        size: 20,
                        color: pal.ink,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'اولین قدم',
                            style: T.of(12, FontWeight.w500, C.muted),
                          ),
                          Text(
                            [
                              '${unitTypeNames[first.type] ?? ''}: ${first.title}',
                              if (unitMeta(
                                first.type,
                                first.durationMinutes,
                                first.questionCount,
                              ).isNotEmpty)
                                unitMeta(
                                  first.type,
                                  first.durationMinutes,
                                  first.questionCount,
                                ),
                            ].join(' · '),
                            style: T.of(15, FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Btn(
              'شروع یادگیری',
              height: 56,
              fontSize: 17,
              onPressed: () {
                Navigator.of(sheet).pop();
                if (first != null) {
                  context.push(
                    Routes.unit(first.id),
                    extra: {'course_id': course.id},
                  );
                } else {
                  context.push(Routes.roadmap(course.id));
                }
              },
            ),
            const SizedBox(height: 4),
            Btn(
              'بعداً',
              kind: BtnKind.ghost,
              height: 44,
              fontSize: 15,
              onPressed: () => Navigator.of(sheet).pop(),
            ),
          ],
        ),
      );
    },
  );
}

/// Icon per unit type.
MI unitIcon(String type) => switch (type) {
  'video' => MI.video,
  'audio' => MI.headphones,
  'practice' => MI.pencil,
  'quiz' => MI.quiz,
  _ => MI.book,
};

class _Skeleton extends StatelessWidget {
  const _Skeleton();
  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.zero,
    children: [
      Bone(height: 240 + MediaQuery.paddingOf(context).top, radius: 28),
      const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Bone(width: 120, height: 30, radius: 12),
            SizedBox(height: 14),
            Bone(width: 220, height: 30),
            SizedBox(height: 14),
            Bone(height: 14),
            SizedBox(height: 8),
            Bone(width: 240, height: 14),
            SizedBox(height: 28),
            Bone(height: 90, radius: 18),
            SizedBox(height: 28),
            Bone(height: 100, radius: 22),
          ],
        ),
      ),
    ],
  );
}
