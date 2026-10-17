import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/app/institute/institute_shell.dart';
import '/app/routes.dart';
import '/app/state/progress_events.dart';
import '/app/state/session.dart';
import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/api/models.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

/// «من در این مؤسسه»: membership card, numbers, my courses here, chapter
/// trophies and this institute's settings. Guests see an invitation to join.
class InstituteMePage extends StatefulWidget {
  final String instituteId;
  const InstituteMePage({super.key, required this.instituteId});

  @override
  State<InstituteMePage> createState() => _InstituteMePageState();
}

class _InstituteMePageState extends State<InstituteMePage> {
  final api = inject<MasirApi>();
  InstituteMe? _me;
  ApiError? _error;
  bool _busy = false;

  String get id => widget.instituteId;

  @override
  void dispose() {
    ProgressEvents.changed.removeListener(_onProgress);
    super.dispose();
  }

  void _onProgress() {
    if (mounted) _load();
  }

  @override
  void initState() {
    super.initState();
    ProgressEvents.changed.addListener(_onProgress);
    _load();
  }

  Future<void> _load() async {
    if (Session.student.value == null) {
      api.me().then((r) => r.fold((_) {}, (s) => Session.student.value = s));
    }
    final r = await api.instituteMe(id);
    if (!mounted) return;
    r.fold(
      (e) => setState(() => _error = e),
      (m) => setState(() {
        _me = m;
        _error = null;
      }),
    );
  }

  Future<void> _setPrefs({bool? announcements, bool? teacher}) async {
    final m = _me!;
    final a = announcements ?? m.notifyAnnouncements;
    final t = teacher ?? m.notifyTeacherMessages;
    final r = await api.setInstitutePrefs(
      id,
      announcements: a,
      teacherMessages: t,
    );
    if (!mounted) return;
    r.fold(
      (e) => Toast.show(
        context,
        title: 'ذخیره نشد',
        body: e.friendly,
        tone: ToastTone.error,
      ),
      (n) => setState(() => _me = n),
    );
  }

  Future<void> _leave(String name) async {
    final ok = await confirmSheet(
      context,
      title: 'از $name خارج می‌شی؟',
      body:
          'عضویت رایگانه و هر وقت خواستی برمی‌گردی. اشتراک‌های فعالت تا آخر مدتشون می‌مونن.',
      keep: 'می‌مونم',
      leave: 'خارج شو',
    );
    if (!ok || !mounted) return;
    final r = await api.leaveInstitute(id);
    if (!mounted) return;
    r.fold(
      (e) => Toast.show(
        context,
        title: 'خارج نشدی',
        body: e.friendly,
        tone: ToastTone.error,
      ),
      (_) {
        InstituteCache.forget(id);
        Session.exitToMasir();
        context.go(Routes.myInstitutes);
      },
    );
  }

  Future<void> _join() async {
    setState(() => _busy = true);
    final r = await api.joinInstitute(id);
    if (!mounted) return;
    setState(() => _busy = false);
    r.fold(
      (e) => Toast.show(
        context,
        title: '${context.brand.memberWord} نشدی',
        body: e.friendly,
        tone: ToastTone.error,
      ),
      (_) {
        InstituteCache.forget(id);
        _load();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final me = _me;
    if (me == null) {
      return _error != null
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: InlineError(body: _error!.friendly, onRetry: _load),
            )
          : const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Bone(height: 230, radius: 26),
                  SizedBox(height: 20),
                  Bone(height: 80, radius: 18),
                ],
              ),
            );
    }
    final inst = InstituteCache.peek(id);
    final name = inst?.name ?? '';
    if (!me.member) return _Guest(busy: _busy, onJoin: _join);
    final earned = me.trophies.where((t) => t.earned).length;
    Widget stat(int v, String label) => Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: C.surface,
          border: Border.all(color: C.border, width: 2),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Text(fa(v), style: T.of(20, FontWeight.w800)),
            Text(label, style: T.of(12, FontWeight.w500, C.muted)),
          ],
        ),
      ),
    );
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
        children: [
          _MemberCard(me: me, detail: inst),
          const SizedBox(height: 20),
          Row(
            children: [
              stat(me.completedUnits, 'واحد تموم‌شده'),
              const SizedBox(width: 10),
              stat(earned, 'جام فصل'),
              const SizedBox(width: 10),
              stat(me.courses.length, 'دوره'),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SectionTitle(
              'دوره‌های من اینجا',
              action: 'اشتراک‌ها',
              onAction: () => context.push(Routes.subscriptions),
            ),
          ),
          const SizedBox(height: 10),
          if (me.courses.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: C.surface,
                border: Border.all(color: C.border, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'هنوز دوره‌ای اینجا شروع نکردی. از تب «دوره‌ها» یکی رو انتخاب کن.',
                style: T.of(14, FontWeight.w500, C.body, 1.8),
              ),
            )
          else
            for (final c in me.courses) ...[
              _MyCourseRow(course: c),
              const SizedBox(height: 10),
            ],
          if (me.trophies.isNotEmpty) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text('جام‌های من', style: T.of(18, FontWeight.w900)),
            ),
            const SizedBox(height: 12),
            _Trophies(items: me.trophies),
          ],
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
            decoration: BoxDecoration(
              color: C.surface,
              border: Border.all(color: C.border, width: 2),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 2),
                  child: Text(
                    'تنظیمات این مؤسسه',
                    style: T.of(16, FontWeight.w900),
                  ),
                ),
                _PrefRow(
                  title: 'اطلاعیه‌های $name',
                  sub: 'کلاس‌های رفع اشکال و خبرهای تازه',
                  value: me.notifyAnnouncements,
                  onChanged: (v) => _setPrefs(announcements: v),
                ),
                _PrefRow(
                  title: 'پیام استادها',
                  sub: 'وقتی استاد جوابت رو می‌ده',
                  value: me.notifyTeacherMessages,
                  onChanged: (v) => _setPrefs(teacher: v),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Semantics(
                    button: true,
                    child: GestureDetector(
                      onTap: () => _leave(name),
                      child: SizedBox(
                        height: 40,
                        child: Center(
                          widthFactor: 1,
                          child: Text(
                            'خروج از $name',
                            style: T.of(15, FontWeight.w800, C.coralText),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  'عضویت رایگانه و هر وقت خواستی برمی‌گردی. اشتراک‌های فعالت تا آخر مدتشون می‌مونن.',
                  style: T.of(12, FontWeight.w500, C.muted, 1.8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final InstituteMe me;
  final InstituteDetail? detail;
  const _MemberCard({required this.me, required this.detail});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<Student?>(
    valueListenable: Session.student,
    builder: (context, student, _) => _card(context, student),
  );

  Widget _card(BuildContext context, Student? student) {
    final brand = context.brand;
    final pal = brand.palette;
    final name = detail?.name ?? '';
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: pal.p,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [lip(pal.e, 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 96,
            child: CoverImage(url: brand.coverUrl, brand: brand),
          ),
          Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: .5,
                  child: PatternFill(pattern: brand.pattern, color: pal.e),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ShiftUp(
                      dy: 34,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: pal.p, width: 4),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              student?.initial ?? '',
                              style: T.of(26, FontWeight.w900, pal.ink),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            height: 30,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Center(
                              widthFactor: 1,
                              child: Text(
                                context.brand.solo
                                    ? 'کارت شاگردی'
                                    : 'کارت عضویت',
                                style: T.of(12, FontWeight.w900, pal.ink),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      student?.name.isNotEmpty == true
                          ? student!.name
                          : (student?.username ?? ''),
                      style: T.of(21, FontWeight.w800, pal.on, 1.4),
                    ),
                    Text(
                      me.memberSince != null
                          ? '${context.brand.memberWord} $name از ${jMonthYear(me.memberSince!)}'
                          : '${context.brand.memberWord} $name',
                      style: T.of(13, FontWeight.w600, pal.on),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'پیشرفت کلی اینجا',
                            style: T.of(13, FontWeight.w800, pal.on),
                          ),
                        ),
                        Text(
                          pct(me.progressPercent),
                          style: T.of(13, FontWeight.w800, pal.on),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: SizedBox(
                        height: 10,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ColoredBox(
                                color: pal.on.withValues(alpha: .3),
                              ),
                            ),
                            FractionallySizedBox(
                              alignment: AlignmentDirectional.centerStart,
                              widthFactor: (me.progressPercent / 100)
                                  .clamp(0, 1)
                                  .toDouble(),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: pal.darkText ? pal.on : Colors.white,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MyCourseRow extends StatelessWidget {
  final CourseCard course;
  const _MyCourseRow({required this.course});

  @override
  Widget build(BuildContext context) {
    final c = course;
    final a = c.access;
    final trial = a.state == AccessState.trial;
    final expired = a.state == AccessState.expired;
    final String sub;
    if (a.paidActive && a.accessEndsAt != null) {
      sub = 'اشتراک ${planNames[a.plan] ?? ''} · تا ${jDay(a.accessEndsAt!)}'
          .replaceAll('  ', ' ');
    } else if (c.freeCourse) {
      sub = 'رایگان · ${fa(c.unitCount)} واحد';
    } else if (expired) {
      sub = 'اشتراک تموم شده · ${pct(c.progressPercent)}';
    } else {
      sub =
          'بخش رایگان · ${fa(c.completedUnits.clamp(0, c.previewUnits))} از ${fa(c.previewUnits)} واحد';
    }
    final freeLeft = (c.previewUnits - c.completedUnits).clamp(
      0,
      c.previewUnits,
    );
    return GestureDetector(
      onTap: () => context.push(
        a.fullAccess || trial ? Routes.roadmap(c.id) : Routes.course(c.id),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: cardDecoration(radius: 20),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 76,
                height: 60,
                child: CoverImage(url: c.coverUrl, brand: context.brand),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: T.of(15, FontWeight.w800),
                  ),
                  const SizedBox(height: 5),
                  Text(sub, style: T.of(12, FontWeight.w500, C.muted)),
                  const SizedBox(height: 5),
                  if (trial)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: C.sunSoft,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        freeLeft > 0
                            ? '${fa(freeLeft)} واحد رایگان مونده'
                            : 'بخش رایگان تموم شد',
                        style: T.of(11, FontWeight.w800, C.sunText),
                      ),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: Track(
                            value: c.progressPercent / 100,
                            height: 6,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          pct(c.progressPercent),
                          style: T.of(
                            12,
                            FontWeight.w800,
                            expired ? C.muted : C.greenText,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Trophies extends StatelessWidget {
  final List<
    ({String courseTitle, String moduleTitle, int moduleOrder, bool earned})
  >
  items;
  const _Trophies({required this.items});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    decoration: BoxDecoration(
      color: C.surface,
      border: Border.all(color: C.border, width: 2),
      borderRadius: BorderRadius.circular(22),
    ),
    child: LayoutBuilder(
      builder: (context, box) {
        final w = (box.maxWidth - 16) / 3;
        return Wrap(
          spacing: 8,
          runSpacing: 14,
          children: [
            for (final t in items)
              SizedBox(
                width: w,
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: t.earned
                          ? BoxDecoration(
                              color: C.sun,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [lip(C.sunDark)],
                            )
                          : BoxDecoration(
                              color: C.sand,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: C.lip, width: 2),
                            ),
                      alignment: Alignment.center,
                      child: MIcon(
                        t.earned ? MI.cup : MI.lock,
                        size: t.earned ? 26 : 22,
                        color: t.earned ? C.sunInk : C.lockedLip,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'فصل ${fa(t.moduleOrder)}',
                      style: T.of(13, FontWeight.w800),
                    ),
                    Text(
                      t.moduleTitle,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: T.of(11, FontWeight.w500, C.muted),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    ),
  );
}

class _PrefRow extends StatelessWidget {
  final String title;
  final String sub;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _PrefRow({
    required this.title,
    required this.sub,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 56),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: C.sand, width: 2)),
    ),
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: T.of(15, FontWeight.w700)),
              Text(sub, style: T.of(12, FontWeight.w500, C.muted)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        MSwitch(value: value, onChanged: onChanged, label: title),
      ],
    ),
  );
}

class _Guest extends StatelessWidget {
  final bool busy;
  final VoidCallback onJoin;
  const _Guest({required this.busy, required this.onJoin});

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: pal.soft,
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: MIcon(MI.user, size: 44, color: pal.ink, strokeWidth: 2),
            ),
            const SizedBox(height: 16),
            Text(
              context.brand.solo ? 'هنوز شاگرد نشدی' : 'هنوز عضو نشده‌ای',
              style: T.of(22, FontWeight.w900),
            ),
            const SizedBox(height: 16),
            Text(
              context.brand.solo
                  ? 'رایگانه. بعدش کلاس‌ها و پیشرفتت همین‌جا کنار هم میان.'
                  : 'عضویت رایگانه. عضو که بشی، کارت عضویت و پیشرفتت توی این مؤسسه همین‌جا میاد.',
              textAlign: TextAlign.center,
              style: T.of(15, FontWeight.w500, C.body, 1.9),
            ),
            const SizedBox(height: 20),
            Btn(
              context.brand.joinLabel,
              height: 52,
              fontSize: 16,
              loading: busy,
              onPressed: onJoin,
            ),
          ],
        ),
      ),
    );
  }
}
