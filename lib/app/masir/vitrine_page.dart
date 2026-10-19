import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/app/common/widgets.dart';
import '/app/course/plan_sheet.dart';
import '/app/routes.dart';
import '/app/state/progress_events.dart';
import '/app/state/session.dart';
import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/api/models.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

class VitrineState {
  final Student? student;
  final StudentStats? stats;
  final int unread;
  final List<WalletCard>? wallet;
  final List<Subscription> subs;
  final MainFeed? feed;
  final List<Topic> topics;
  final ApiError? walletError;
  final Set<String> dismissed;

  const VitrineState({
    this.student,
    this.stats,
    this.unread = 0,
    this.wallet,
    this.subs = const [],
    this.feed,
    this.topics = const [],
    this.walletError,
    this.dismissed = const {},
  });

  VitrineState copy({
    Student? student,
    StudentStats? stats,
    int? unread,
    List<WalletCard>? wallet,
    List<Subscription>? subs,
    MainFeed? feed,
    List<Topic>? topics,
    ApiError? walletError,
    bool clearError = false,
    Set<String>? dismissed,
  }) => VitrineState(
    student: student ?? this.student,
    stats: stats ?? this.stats,
    unread: unread ?? this.unread,
    wallet: wallet ?? this.wallet,
    subs: subs ?? this.subs,
    feed: feed ?? this.feed,
    topics: topics ?? this.topics,
    walletError: clearError ? null : walletError ?? this.walletError,
    dismissed: dismissed ?? this.dismissed,
  );

  /// The course the student is on (most recently active institute).
  WalletCard? get current =>
      wallet?.where((w) => w.course?.currentUnit != null).firstOrNull ??
      wallet?.firstOrNull;

  Subscription? get expiring => subs
      .where((s) => s.course.access.state == AccessState.expiring)
      .firstOrNull;
}

/// Loads every Vitrine section in parallel; each section shows on its own.
class VitrineCubit extends Cubit<VitrineState> {
  final MasirApi api;
  VitrineCubit(this.api) : super(VitrineState(student: Session.student.value));

  Future<void> load() async {
    await Future.wait([
      api.me().then(
        (r) => r.fold((_) {}, (s) {
          Session.student.value = s;
          _emit(state.copy(student: s));
        }),
      ),
      api.stats().then(
        (r) => r.fold((_) {}, (s) => _emit(state.copy(stats: s))),
      ),
      api.unreadCount().then(
        (r) => r.fold((_) {}, (n) => _emit(state.copy(unread: n))),
      ),
      api.wallet().then(
        (r) => r.fold(
          (e) => _emit(state.copy(walletError: e)),
          (w) => _emit(state.copy(wallet: w, clearError: true)),
        ),
      ),
      api.subscriptions().then(
        (r) => r.fold((_) {}, (s) => _emit(state.copy(subs: s))),
      ),
      api.mainFeed().then(
        (r) => r.fold((_) {}, (f) => _emit(state.copy(feed: f))),
      ),
      api.topics().then(
        (r) => r.fold((_) {}, (t) => _emit(state.copy(topics: t))),
      ),
    ]);
  }

  void dismiss(String id) =>
      _emit(state.copy(dismissed: {...state.dismissed, id}));

  void _emit(VitrineState s) {
    if (!isClosed) emit(s);
  }
}

class VitrinePage extends StatelessWidget {
  const VitrinePage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => VitrineCubit(inject<MasirApi>())..load(),
    child: Builder(
      builder: (context) => ReloadOnProgress(
        onChange: () => context.read<VitrineCubit>().load(),
        child: const _Vitrine(),
      ),
    ),
  );
}

class _Vitrine extends StatelessWidget {
  const _Vitrine();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VitrineCubit, VitrineState>(
      builder: (context, s) {
        final cubit = context.read<VitrineCubit>();
        final current = s.current;
        final others = (s.wallet ?? []).where((w) => w != current).toList();
        final recs = [...?s.feed?.recommended, ...?s.feed?.featuredInstitutes]
            .where(
              (i) =>
                  !(s.wallet ?? []).any((w) => w.institute.id == i.id) &&
                  !s.dismissed.contains(i.id),
            )
            .fold<List<InstituteSummary>>(
              [],
              (l, i) => l.any((x) => x.id == i.id) ? l : [...l, i],
            );
        final courses = [...?s.feed?.newCourses, ...?s.feed?.featuredCourses]
            .fold<List<FeedCourse>>(
              [],
              (l, c) => l.any((x) => x.id == c.id) ? l : [...l, c],
            );

        return RefreshIndicator(
          color: C.violet,
          onRefresh: cubit.load,
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              0,
              MediaQuery.paddingOf(context).top + 20,
              0,
              32,
            ),
            children: [
              _Header(student: s.student, unread: s.unread),
              if (s.expiring != null) ...[
                const SizedBox(height: 28),
                _RenewAlert(sub: s.expiring!),
              ],
              if (s.stats != null && s.stats!.week.isNotEmpty) ...[
                const SizedBox(height: 28),
                _Streak(stats: s.stats!),
              ],
              if (s.wallet == null && s.walletError == null) ...[
                const SizedBox(height: 28),
                const _NextStepSkeleton(),
              ],
              if (s.walletError != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
                  child: InlineError(
                    title: 'مؤسسه‌هات بارگذاری نشد',
                    onRetry: cubit.load,
                  ),
                ),
              if (current?.course?.currentUnit != null) ...[
                const SizedBox(height: 28),
                _NextStep(card: current!),
              ],
              if (current != null) ...[
                const SizedBox(height: 28),
                _CurrentInstitute(card: current),
              ],
              if (s.wallet != null && s.wallet!.isEmpty) ...[
                const SizedBox(height: 28),
                const _NoInstitute(),
              ],
              if ((s.wallet ?? []).any((w) => w.course != null)) ...[
                const SizedBox(height: 28),
                _MyPaths(
                  cards: s.wallet!.where((w) => w.course != null).toList(),
                ),
              ],
              if (others.isNotEmpty) ...[
                const SizedBox(height: 28),
                _OtherInstitutes(cards: others),
              ],
              if (recs.isNotEmpty) ...[
                const SizedBox(height: 28),
                _Recommended(
                  items: recs.take(6).toList(),
                  onDismiss: cubit.dismiss,
                ),
              ],
              if (s.topics.isNotEmpty) ...[
                const SizedBox(height: 28),
                _Topics(topics: s.topics),
              ],
              if (courses.isNotEmpty) ...[
                const SizedBox(height: 28),
                _NewCourses(items: courses.take(8).toList()),
              ],
              if ((s.feed?.activity ?? []).isNotEmpty) ...[
                const SizedBox(height: 28),
                _Fresh(
                  items: s.feed!.activity.take(4).toList(),
                  wallet: s.wallet ?? [],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

const _hPad = EdgeInsets.symmetric(horizontal: 16);

class _Header extends StatelessWidget {
  final Student? student;
  final int unread;
  const _Header({this.student, required this.unread});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Semantics(
            button: true,
            label: 'پروفایل',
            child: GestureDetector(
              onTap: () => context.go(Routes.profile),
              child: Transform.rotate(
                angle: -0.07,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: C.violetSoft,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [lip(C.violetBorder, 3)],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    student?.initial ?? '',
                    style: T.of(19, FontWeight.w900, C.violetDark),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${greeting(now)} ${student?.firstName ?? ''}'.trim(),
                  style: T.of(26, FontWeight.w900, C.ink, 1.3),
                ),
                Text(
                  jWeekdayDay(now),
                  style: T.of(14, FontWeight.w500, C.muted),
                ),
              ],
            ),
          ),
          // One node for the screen reader: the label carries the count, and
          // the inner button and badge stay out of the way.
          Semantics(
            button: true,
            container: true,
            excludeSemantics: true,
            onTap: () => context.push(Routes.inbox),
            label: unread > 0
                ? 'صندوق پیام، ${fa(unread)} پیام نخونده'
                : 'صندوق پیام',
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Lip(
                  onTap: () => context.push(Routes.inbox),
                  radius: 16,
                  lipHeight: 3,
                  child: const SizedBox.square(
                    dimension: 44,
                    child: Center(child: MIcon(MI.bell, size: 22)),
                  ),
                ),
                if (unread > 0)
                  Positioned(
                    top: -6,
                    left: -6,
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 22),
                      height: 22,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: C.coral,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: C.paper, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        fa(unread > 99 ? 99 : unread),
                        style: T.of(11, FontWeight.w800, Colors.white, 1),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RenewAlert extends StatelessWidget {
  final Subscription sub;
  const _RenewAlert({required this.sub});

  @override
  Widget build(BuildContext context) => Padding(
    padding: _hPad,
    child: Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(14, 10, 10, 10),
        decoration: BoxDecoration(
          color: C.sunSoft,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: C.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const MIcon(MI.clock, size: 20, color: Color(0xFF8A5A00)),
            ),
            const SizedBox(width: 12),
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
                    TextSpan(text: 'اشتراک «${sub.course.title}» '),
                    TextSpan(
                      text: '${fa(sub.course.access.daysLeft ?? 0)} روز',
                      style: T.of(14, FontWeight.w800, const Color(0xFF5A3B00)),
                    ),
                    const TextSpan(text: ' دیگه تموم می‌شه.'),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => showPlanSheet(
                context,
                courseId: sub.course.id,
                renew: true,
                brand: sub.institute?.brand,
              ),
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: C.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  'تمدید',
                  style: T.of(14, FontWeight.w800, C.sunText),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _Streak extends StatelessWidget {
  final StudentStats stats;
  const _Streak({required this.stats});

  @override
  Widget build(BuildContext context) => Padding(
    padding: _hPad,
    child: Semantics(
      label: 'زنجیره‌ی این هفته: ${fa(stats.streakDays)} روز پشت سر هم',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: C.surface,
          border: Border.all(color: C.border, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            MIcon(
              MI.flame,
              size: 26,
              color: stats.streakDays > 0
                  ? const Color(0xFFFF8A00)
                  : C.lockedLip,
            ),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${fa(stats.streakDays)} روز',
                  style: T.of(17, FontWeight.w800, C.ink, 1.3),
                ),
                Text(
                  'پشت سر هم',
                  style: T.of(11, FontWeight.w500, C.muted, 1.3),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  for (var i = 0; i < stats.week.length; i++)
                    Expanded(
                      child: _Day(
                        day: stats.week[i],
                        letter: weekdayLetters[i],
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

class _Day extends StatelessWidget {
  final WeekDay day;
  final String letter;
  const _Day({required this.day, required this.letter});

  @override
  Widget build(BuildContext context) {
    final todayPending = day.today && !day.done;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: day.done ? C.green : C.surface,
            shape: BoxShape.circle,
            border: todayPending
                ? null
                : Border.all(color: day.done ? C.green : C.border, width: 2),
          ),
          foregroundDecoration: todayPending
              ? const _DashedCircle(color: Color(0xFFFF8A00))
              : null,
          alignment: Alignment.center,
          child: day.done
              ? const MIcon(
                  MI.check,
                  size: 14,
                  color: Colors.white,
                  strokeWidth: 4,
                )
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          letter,
          style: T.of(
            11,
            FontWeight.w700,
            todayPending ? const Color(0xFFB35F00) : C.muted,
          ),
        ),
      ],
    );
  }
}

/// Dashed ring for "today, not done yet".
class _DashedCircle extends Decoration {
  final Color color;
  const _DashedCircle({required this.color});
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _DashedPainter(color);
}

class _DashedPainter extends BoxPainter {
  final Color color;
  _DashedPainter(this.color);
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final size = cfg.size!;
    final rect = (offset & size).deflate(1);
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    const n = 12;
    for (var i = 0; i < n; i++) {
      canvas.drawArc(rect, i * 2 * 3.14159 / n, 3.14159 / n, false, p);
    }
  }
}

class _NextStepSkeleton extends StatelessWidget {
  const _NextStepSkeleton();
  @override
  Widget build(BuildContext context) =>
      const Padding(padding: _hPad, child: Bone(height: 200, radius: 26));
}

class _NextStep extends StatelessWidget {
  final WalletCard card;
  const _NextStep({required this.card});

  @override
  Widget build(BuildContext context) {
    final course = card.course!;
    final unit = course.currentUnit!;
    final brand = card.institute.brand;
    final pal = brand.palette;
    final locked = unit.needsSubscription;
    return Padding(
      padding: _hPad,
      child: Semantics(
        label: 'قدم بعدی',
        // The card has a name, but its button and text stay their own nodes.
        container: true,
        explicitChildNodes: true,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                boxShadow: [lip(C.lip, 5)],
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: pal.p,
                        borderRadius: const BorderRadiusDirectional.horizontal(
                          start: Radius.circular(26),
                        ).resolve(TextDirection.rtl),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LippedLogo(
                            brand: brand,
                            size: 56,
                            inverted: true,
                            lipHeight: 4,
                          ),
                          const SizedBox(height: 12),
                          Column(
                            children: [
                              Text(
                                pct(course.progressPercent),
                                style: T.of(26, FontWeight.w800, pal.on, 1.2),
                              ),
                              Text(
                                'از دوره',
                                style: T.of(
                                  11,
                                  FontWeight.w500,
                                  pal.on.withValues(alpha: .8),
                                  1.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: C.surface,
                          borderRadius:
                              const BorderRadiusDirectional.horizontal(
                                end: Radius.circular(26),
                              ).resolve(TextDirection.rtl),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'قدم بعدی',
                              style: T.of(13, FontWeight.w700, pal.ink),
                            ),
                            Text(
                              unit.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: T.of(22, FontWeight.w800, C.ink, 1.4),
                            ),
                            Text(
                              unit.durationMinutes > 0
                                  ? '${course.title}، حدود ${minutes(unit.durationMinutes)}'
                                  : course.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: T.of(13, FontWeight.w500, C.muted),
                            ),
                            const SizedBox(height: 12),
                            StationTrack(
                              percent: course.progressPercent,
                              palette: pal,
                              goalFlag: true,
                            ),
                            const SizedBox(height: 12),
                            Btn(
                              locked
                                  ? 'اشتراک بگیر و ادامه بده'
                                  : 'ادامه یادگیری',
                              palette: pal,
                              height: 52,
                              fontSize: 16,
                              icon: locked ? MI.lock : MI.play,
                              onPressed: () {
                                if (locked) {
                                  showPlanSheet(
                                    context,
                                    courseId: course.id,
                                    brand: brand,
                                    returnUnitId: unit.id,
                                  );
                                } else {
                                  Session.space.value = Brand.masir;
                                  context.push(
                                    Routes.unit(unit.id),
                                    extra: {'course_id': course.id},
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Ticket notches where the stub meets the body.
            PositionedDirectional(start: 89, top: -11, child: _notch()),
            PositionedDirectional(start: 89, bottom: -11, child: _notch()),
          ],
        ),
      ),
    );
  }

  Widget _notch() => Container(
    width: 22,
    height: 22,
    decoration: const BoxDecoration(color: C.paper, shape: BoxShape.circle),
  );
}

class _CurrentInstitute extends StatelessWidget {
  final WalletCard card;
  const _CurrentInstitute({required this.card});

  @override
  Widget build(BuildContext context) {
    final inst = card.institute;
    final brand = inst.brand;
    final pal = brand.palette;
    final photo = card.photoUrl.isNotEmpty ? card.photoUrl : card.coverUrl;
    final meta = [
      if (inst.topic.isNotEmpty) inst.topic,
      '${fa(inst.courseCount)} دوره',
      '${fa(inst.studentCount)} ${brand.peersWord}',
    ].join(' • ');
    return Padding(
      padding: _hPad,
      child: Semantics(
        label: 'مؤسسه‌ی فعلی',
        // The card has a name, but its button and text stay their own nodes.
        container: true,
        explicitChildNodes: true,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: pal.p,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [lip(pal.e, 6)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 150,
                child: CoverImage(url: photo, brand: brand),
              ),
              Stack(
                children: [
                  Positioned.fill(
                    child: PatternFill(pattern: brand.pattern, color: pal.e),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ShiftUp(
                          dy: 38,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              LippedLogo(
                                brand: brand,
                                size: 76,
                                inverted: true,
                                lipHeight: 5,
                              ),
                              const Spacer(),
                              Container(
                                height: 30,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: C.surface,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: C.green,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'مؤسسه‌ی فعلی',
                                      style: T.of(13, FontWeight.w900, pal.ink),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        ShiftUp(
                          dy: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                inst.name,
                                style: T.of(26, FontWeight.w900, pal.on, 1.3),
                              ),
                              Text(
                                meta,
                                style: T.of(14, FontWeight.w600, pal.on),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: _Tile(
                                      big: fa(card.freshAnnouncements),
                                      small: 'اطلاعیه‌ی تازه',
                                      color: pal.on,
                                      onTap: () => context.push(
                                        Routes.announcements(inst.id),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _Tile(
                                      big: card.latestAnnouncementTitle ?? '—',
                                      small: 'آخرین اطلاعیه',
                                      bigSize: 16,
                                      color: pal.on,
                                      onTap: () => context.push(
                                        Routes.announcements(inst.id),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: Lip(
                                      onTap: () => context.push(
                                        Routes.threshold(inst.id),
                                      ),
                                      fill: C.surface,
                                      border: null,
                                      lipColor: pal.e,
                                      radius: 16,
                                      child: SizedBox(
                                        height: 50,
                                        child: Center(
                                          child: Text(
                                            'ورود به ${inst.name}',
                                            style: T.of(
                                              16,
                                              FontWeight.w900,
                                              pal.ink,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Semantics(
                                    button: true,
                                    label: 'عوض کردن مؤسسه‌ی فعلی',
                                    child: GestureDetector(
                                      onTap: () =>
                                          context.go(Routes.myInstitutes),
                                      child: Container(
                                        width: 54,
                                        height: 54,
                                        decoration: BoxDecoration(
                                          color: pal.on.withValues(alpha: .18),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: MIcon(
                                          MI.swap,
                                          color: pal.on,
                                          strokeWidth: 2.4,
                                        ),
                                      ),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String big;
  final String small;
  final double bigSize;
  final Color color;
  final VoidCallback onTap;
  const _Tile({
    required this.big,
    required this.small,
    this.bigSize = 22,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            big,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: T.of(bigSize, FontWeight.w800, color, 1.3),
          ),
          Text(small, style: T.of(13, FontWeight.w700, color)),
        ],
      ),
    ),
  );
}

class _NoInstitute extends StatelessWidget {
  const _NoInstitute();
  @override
  Widget build(BuildContext context) => Padding(
    padding: _hPad,
    child: PaperCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('هنوز عضو مؤسسه‌ای نیستی', style: T.of(18, FontWeight.w800)),
          const SizedBox(height: 6),
          Text(
            'عضویت رایگانه؛ یه مؤسسه پیدا کن و از واحدهای رایگانش شروع کن.',
            style: T.of(14, FontWeight.w500, C.body, 1.8),
          ),
          const SizedBox(height: 14),
          Btn('دیدن مؤسسه‌ها', onPressed: () => context.push(Routes.explore)),
        ],
      ),
    ),
  );
}

class _MyPaths extends StatelessWidget {
  final List<WalletCard> cards;
  const _MyPaths({required this.cards});

  @override
  Widget build(BuildContext context) => Padding(
    padding: _hPad,
    child: Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      decoration: cardDecoration(radius: 26, lipHeight: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SectionTitle(
              'مسیرهای من',
              action: 'همه',
              onAction: () => context.go(Routes.myInstitutes),
            ),
          ),
          for (var i = 0; i < cards.length && i < 4; i++) ...[
            if (i > 0) const SandLine(),
            _PathLine(card: cards[i]),
          ],
        ],
      ),
    ),
  );
}

class _PathLine extends StatelessWidget {
  final WalletCard card;
  const _PathLine({required this.card});

  @override
  Widget build(BuildContext context) {
    final course = card.course!;
    final brand = card.institute.brand;
    final expired = course.access.state == AccessState.expired;
    return InkWell(
      onTap: () => expired
          ? showPlanSheet(
              context,
              courseId: course.id,
              renew: true,
              brand: brand,
            )
          : context.push(Routes.threshold(card.institute.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Column(
          children: [
            Row(
              children: [
                LippedLogo(brand: brand, size: 44),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.institute.name,
                        style: T.of(16, FontWeight.w800),
                      ),
                      Text(
                        [
                          course.title,
                          if (card.nextUnitTitle != null) card.nextUnitTitle!,
                        ].join('، '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: T.of(13, FontWeight.w500, C.muted),
                      ),
                    ],
                  ),
                ),
                Text(
                  expired ? 'تمدید' : pct(course.progressPercent),
                  style: T.of(
                    14,
                    FontWeight.w800,
                    expired ? C.coralText : C.greenText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: StationTrack(
                percent: course.progressPercent,
                palette: brand.palette,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OtherInstitutes extends StatelessWidget {
  final List<WalletCard> cards;
  const _OtherInstitutes({required this.cards});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SectionTitle(
          'مؤسسه‌های دیگه‌ت',
          action: 'همه',
          onAction: () => context.go(Routes.myInstitutes),
        ),
      ),
      const SizedBox(height: 14),
      SizedBox(
        height: 214,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
          children: [
            for (final c in cards) ...[
              InstituteColorCard(card: c),
              const SizedBox(width: 14),
            ],
            Semantics(
              button: true,
              label: 'مؤسسه‌ی تازه',
              child: GestureDetector(
                onTap: () => context.push(Routes.explore),
                child: CustomPaint(
                  painter: _DashedRRect(color: C.violetBorder),
                  child: SizedBox(
                    width: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const MIcon(
                          MI.plus,
                          size: 28,
                          color: C.violetDark,
                          strokeWidth: 2.4,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'مؤسسه‌ی تازه',
                          style: T.of(14, FontWeight.w800, C.violetDark),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

/// Coloured institute card: photo strip, pattern, white logo, status pill.
class InstituteColorCard extends StatelessWidget {
  final WalletCard card;
  final double width;
  const InstituteColorCard({super.key, required this.card, this.width = 268});

  @override
  Widget build(BuildContext context) {
    final brand = card.institute.brand;
    final pal = brand.palette;
    final course = card.course;
    final badge = course == null
        ? null
        : accessBadge(course.access, course.progressPercent);
    final photo = card.photoUrl.isNotEmpty ? card.photoUrl : card.coverUrl;
    return GestureDetector(
      onTap: () => context.push(Routes.threshold(card.institute.id)),
      child: Container(
        width: width,
        margin: const EdgeInsets.only(bottom: 5),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: pal.p,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [lip(pal.e, 5)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 92,
              child: CoverImage(url: photo, brand: brand),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: PatternFill(pattern: brand.pattern, color: pal.e),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShiftUp(
                          dy: 26,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              LippedLogo(
                                brand: brand,
                                size: 52,
                                inverted: true,
                              ),
                              const Spacer(),
                              if (badge != null &&
                                  course!.access.state != AccessState.active &&
                                  course.access.state !=
                                      AccessState.freeCourse &&
                                  course.access.state != AccessState.trial)
                                Container(
                                  height: 26,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: C.surface,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    badge.text,
                                    style: T.of(12, FontWeight.w800, badge.fg),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        ShiftUp(
                          dy: -6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card.institute.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: T.of(17, FontWeight.w800, pal.on, 1.5),
                              ),
                              Text(
                                course == null
                                    ? '${fa(card.institute.courseCount)} دوره'
                                    : '${course.title} • ${pct(course.progressPercent)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: T.of(13, FontWeight.w600, pal.on, 1.6),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

class _DashedRRect extends CustomPainter {
  final Color color;
  _DashedRRect({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size).deflate(1),
          const Radius.circular(24),
        ),
      );
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (final m in path.computeMetrics()) {
      for (double d = 0; d < m.length; d += 10) {
        canvas.drawPath(m.extractPath(d, d + 6), p);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRRect old) => old.color != color;
}

class _Recommended extends StatelessWidget {
  final List<InstituteSummary> items;
  final ValueChanged<String> onDismiss;
  const _Recommended({required this.items, required this.onDismiss});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SectionTitle(
          'شاید دوست داشته باشی',
          subtitle: 'بر اساس دوره‌هایی که می‌خونی',
          action: 'همه‌ی مؤسسه‌ها',
          onAction: () => context.push(Routes.explore),
        ),
      ),
      const SizedBox(height: 14),
      SizedBox(
        height: 318,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(width: 14),
          itemBuilder: (_, i) => RecommendCard(
            item: items[i],
            onDismiss: () => onDismiss(items[i].id),
          ),
        ),
      ),
    ],
  );
}

class RecommendCard extends StatefulWidget {
  final InstituteSummary item;
  final VoidCallback? onDismiss;
  const RecommendCard({super.key, required this.item, this.onDismiss});

  @override
  State<RecommendCard> createState() => _RecommendCardState();
}

class _RecommendCardState extends State<RecommendCard> {
  bool _joining = false;

  Future<void> _join() async {
    setState(() => _joining = true);
    final res = await inject<MasirApi>().joinInstitute(widget.item.id);
    if (!mounted) return;
    setState(() => _joining = false);
    res.fold(
      (e) => Toast.show(
        context,
        title: '${widget.item.brand.memberWord} نشدی',
        body: e.friendly,
        tone: ToastTone.error,
      ),
      (_) => context.push(Routes.threshold(widget.item.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final it = widget.item;
    final pal = it.brand.palette;
    return Container(
      width: 250,
      margin: const EdgeInsets.only(bottom: 5),
      clipBehavior: Clip.antiAlias,
      decoration: cardDecoration(radius: 24, lipHeight: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () => context.push(Routes.instHome(it.id)),
                child: SizedBox(
                  height: 118,
                  child: CoverImage(url: it.brand.coverUrl, brand: it.brand),
                ),
              ),
              if (widget.onDismiss != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Semantics(
                    button: true,
                    label: '${it.name} رو پیشنهاد نکن',
                    child: GestureDetector(
                      onTap: widget.onDismiss,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: C.scrim,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const MIcon(
                          MI.close,
                          size: 18,
                          color: Colors.white,
                          strokeWidth: 2.8,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShiftUp(dy: 26, child: LippedLogo(brand: it.brand, size: 52)),
                  ShiftUp(
                    dy: -4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          it.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: T.of(17, FontWeight.w800, C.ink, 1.5),
                        ),
                        Text(
                          [
                            if (it.topic.isNotEmpty) it.topic,
                            if (it.courseCount > 0)
                              '${fa(it.courseCount)} دوره',
                          ].join(' • '),
                          style: T.of(13, FontWeight.w500, C.muted, 1.6),
                        ),
                        if (it.description.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: C.sand,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const MIcon(
                                  MI.sparkle,
                                  size: 14,
                                  color: C.sunDark,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    it.description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: T.of(
                                      12,
                                      FontWeight.w700,
                                      C.body,
                                      1.6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Spacer(),
                  Lip(
                    onTap: _joining ? null : _join,
                    border: pal.p,
                    lipColor: null,
                    radius: 14,
                    child: SizedBox(
                      height: 40,
                      child: Center(
                        child: _joining
                            ? SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: pal.p,
                                ),
                              )
                            : Text(
                                '${it.brand.joinLabel} • رایگان',
                                style: T.of(15, FontWeight.w800, pal.ink),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Topics extends StatelessWidget {
  final List<Topic> topics;
  const _Topics({required this.topics});

  static const _dots = [
    Color(0xFF1CA7EC),
    Color(0xFF22B573),
    Color(0xFFE11D48),
    C.sun,
    C.violet,
    Color(0xFF0D9488),
  ];
  static const _tilt = [-1.5, 1.0, -0.5, 1.5, -1.0, 0.5];

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('امروز چی یاد بگیریم؟', style: T.of(19, FontWeight.w900)),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var i = 0; i < topics.length; i++)
              Transform.rotate(
                angle: _tilt[i % _tilt.length] * 3.14159 / 180,
                child: Lip(
                  onTap: () => context.push(
                    Routes.explore,
                    extra: {'topic': topics[i].slug},
                  ),
                  radius: 14,
                  lipHeight: 3,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: _dots[i % _dots.length],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(topics[i].name, style: T.of(15, FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    ),
  );
}

class _NewCourses extends StatelessWidget {
  final List<FeedCourse> items;
  const _NewCourses({required this.items});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SectionTitle(
          'دوره‌های تازه',
          action: 'همه',
          onAction: () => context.push(Routes.explore),
        ),
      ),
      const SizedBox(height: 14),
      SizedBox(
        height: 238,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(width: 14),
          itemBuilder: (_, i) {
            final c = items[i];
            return GestureDetector(
              onTap: () => context.push(
                Routes.course(c.id),
                extra: {'brand_palette': c.brand.palette.key},
              ),
              child: Container(
                width: 212,
                margin: const EdgeInsets.only(bottom: 5),
                clipBehavior: Clip.antiAlias,
                decoration: cardDecoration(radius: 22, lipHeight: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 112,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CoverImage(url: c.coverUrl, brand: c.brand),
                          if (c.introSeconds > 0)
                            Positioned(
                              left: 10,
                              bottom: 10,
                              child: VideoBadge(c.introSeconds),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: T.of(16, FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: c.brand.palette.p,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  c.instituteName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: T.of(12, FontWeight.w500, C.muted),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            c.freeCourse
                                ? 'رایگان'
                                : c.previewUnits > 0
                                ? '${fa(c.previewUnits)} واحد اولش رایگانه'
                                : 'از ${perMonth(c.fromPerMonth)}',
                            style: T.of(13, FontWeight.w800, C.greenText),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

class _Fresh extends StatelessWidget {
  final List<FeedActivity> items;
  final List<WalletCard> wallet;
  const _Fresh({required this.items, required this.wallet});

  @override
  Widget build(BuildContext context) => Padding(
    padding: _hPad,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text('تازه از مؤسسه‌هات', style: T.of(19, FontWeight.w900)),
        ),
        const SizedBox(height: 12),
        for (final a in items) ...[
          GestureDetector(
            onTap: () => context.push(Routes.course(a.courseId)),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: C.surface,
                border: Border.all(color: C.border, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  InstituteLogo(
                    brand:
                        wallet
                            .where((w) => w.institute.id == a.instituteId)
                            .firstOrNull
                            ?.institute
                            .brand ??
                        Brand(palette: masirPalette, name: a.instituteName),
                    size: 44,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.title,
                          style: T.of(15, FontWeight.w700, C.ink, 1.6),
                        ),
                        Text(
                          '${a.instituteName}، ${ago(a.createdAt)}',
                          style: T.of(12, FontWeight.w500, C.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    ),
  );
}
