import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '/app/common/lesson_blocks.dart';
import '/app/common/rich_body.dart';
import '/app/course/course_detail_page.dart' show unitIcon;
import '/app/course/plan_sheet.dart';
import '/app/course/roadmap_page.dart' show RoadmapEvents;
import '/app/course/course_brand.dart';
import '/app/routes.dart';
import '/app/state/progress_events.dart';
import '/app/state/nav.dart';
import '/app/state/offline_queue.dart';
import '/app/unit/quiz_view.dart';
import '/app/unit/unit_media.dart';
import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/api/models.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

/// Units slide in from the reading side; moving on to the next unit replaces
/// the current page so «back» returns to where the student came from.
Page<void> unitPage(GoRouterState state, String id) {
  final x = extraOf(state);
  return masirPage(
    state,
    UnitPage(
      unitId: id,
      courseId: '${x['course_id'] ?? ''}',
      fromRoadmap: x['from_roadmap'] == true,
    ),
  );
}

class UnitPage extends StatefulWidget {
  final String unitId;
  final String courseId;
  final bool fromRoadmap;
  const UnitPage({
    super.key,
    required this.unitId,
    this.courseId = '',
    this.fromRoadmap = false,
  });

  @override
  State<UnitPage> createState() => _UnitPageState();
}

enum _Mode { content, quiz, result, previewEnd, locked }

class _UnitPageState extends State<UnitPage> {
  final api = inject<MasirApi>();
  UnitContent? _u;
  Outline? _outline;
  CourseDetail? _course;
  ApiError? _error;
  _Mode _mode = _Mode.content;
  QuizResult? _result;
  bool _busy = false;
  bool _done = false;
  final _progress = ValueNotifier<double>(0);
  final _scroll = ScrollController();

  String get courseId => _u?.courseId ?? widget.courseId;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_u?.type != 'html' && _u?.type != 'practice') return;
      final p = _scroll.position;
      _progress.value = p.maxScrollExtent <= 0
          ? 1
          : (p.pixels / p.maxScrollExtent).clamp(0, 1);
    });
    _load();
  }

  @override
  void dispose() {
    _progress.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _error = null;
      _mode = _Mode.content;
    });
    final r = await api.unit(widget.unitId);
    if (!mounted) return;
    await r.fold(
      (e) async {
        final msg = e.message.toLowerCase();
        if (e.status == 403 && msg.contains('subscribed')) {
          setState(() => _mode = _Mode.previewEnd);
        } else if (e.status == 403 && msg.contains('locked')) {
          setState(() => _mode = _Mode.locked);
        } else {
          setState(() => _error = e);
        }
      },
      (u) async {
        setState(() {
          _u = u;
          _mode = u.type == 'quiz' ? _Mode.quiz : _Mode.content;
        });
      },
    );
    final cid = courseId;
    if (cid.isNotEmpty) {
      api
          .outline(cid)
          .then(
            (r) => r.fold(
              (_) {},
              (o) => mounted ? setState(() => _outline = o) : null,
            ),
          );
      api
          .course(cid)
          .then(
            (r) => r.fold((_) {}, (c) {
              CourseBrand.remember(c.card.id, c.instituteBrand);
              if (mounted) setState(() => _course = c);
            }),
          );
    }
  }

  void _close() {
    if (widget.fromRoadmap || !context.canPop()) {
      back(
        context,
        fallback: courseId.isNotEmpty ? Routes.roadmap(courseId) : null,
      );
    } else {
      context.pop();
    }
  }

  Future<void> _complete() async {
    final u = _u!;
    setState(() => _busy = true);
    final r = await api.completeUnit(u.id);
    if (!mounted) return;
    setState(() => _busy = false);
    r.fold((e) {
      if (e.offline) {
        // Kept on the phone and sent when the connection is back.
        OfflineQueue.add(u.id);
        Toast.show(
          context,
          title: 'آفلاین ذخیره شد',
          body: 'وصل که بشی، تیکش خودش ارسال می‌شه.',
          tone: ToastTone.info,
        );
        _close();
        return;
      }
      Toast.show(
        context,
        title: 'ثبت نشد',
        body: e.friendly,
        tone: ToastTone.error,
      );
    }, _celebrate);
  }

  /// motion.md §9: the button turns green and draws a check, «ایول!» drops
  /// in, and the next unit slides in at 600ms, so the screen is never empty.
  Future<void> _celebrate(ProgressUpdate? p) async {
    final u = _u!;
    final next = p?.nextUnit;
    final bigMoment =
        p != null &&
        (p.pathCompleted || p.courseCompleted || p.moduleCompleted);
    setState(() => _done = true);
    HapticFeedback.lightImpact();
    if (!bigMoment) {
      Future.delayed(const Duration(milliseconds: 160), () {
        if (!mounted) return;
        final nextName = next == null ? '' : (unitTypeNames[next.type] ?? '');
        Toast.show(
          context,
          title: 'ایول!',
          body: nextName.isNotEmpty
              ? '«${u.title}» تموم شد · بعدی: $nextName'
              : '«${u.title}» تموم شد',
          duration: const Duration(milliseconds: 1500),
        );
      });
    }
    await Future.delayed(const Duration(milliseconds: 510));
    if (mounted) _moveOn(p);
  }

  /// After a unit counts: celebrate a finished path on the roadmap, show the
  /// end of the free part, or slide in the next unit.
  void _moveOn(ProgressUpdate? p) {
    ProgressEvents.notify();
    final u = _u!;
    if (p == null) {
      _close();
      return;
    }
    if (p.pathCompleted || p.courseCompleted || p.moduleCompleted) {
      RoadmapEvents.pathDone = (courseId: courseId, update: p);
      if (widget.fromRoadmap && context.canPop()) {
        context.pop();
      } else {
        context.pushReplacement(Routes.roadmap(courseId));
      }
      return;
    }
    final next = p.nextUnit;
    if (next == null) {
      _close();
      return;
    }
    if (next.needsSubscription || (u.isLastPreview && !u.isSubscribed)) {
      setState(() => _mode = _Mode.previewEnd);
      return;
    }
    context.pushReplacement(
      Routes.unit(next.id),
      extra: {'course_id': courseId, 'from_roadmap': widget.fromRoadmap},
    );
  }

  Future<void> _plans() async {
    await showPlanSheet(
      context,
      courseId: courseId,
      returnUnitId: widget.unitId,
      brand: context.brand,
    );
    if (mounted) _load();
  }

  @override
  Widget build(BuildContext context) {
    final brand = _course?.instituteBrand ?? context.brand;
    return BrandScope(
      brand: brand,
      child: Builder(
        builder: (context) {
          final Widget body;
          if (_error != null && _error!.offline) {
            body = OfflineView(onRetry: _load, onBack: _close);
          } else if (_error != null) {
            body = SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: CloseCircle(label: 'بستن', onTap: _close),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: InlineError(body: _error!.friendly, onRetry: _load),
                  ),
                ],
              ),
            );
          } else if (_mode == _Mode.previewEnd) {
            body = PreviewEndView(
              outline: _outline,
              onClose: _close,
              onPlans: _plans,
            );
          } else if (_mode == _Mode.locked) {
            body = SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: CloseCircle(label: 'بستن', onTap: _close),
                    ),
                  ),
                  const Spacer(),
                  EmptyState(
                    icon: MI.lock,
                    title: 'این واحد هنوز قفله',
                    body:
                        'واحدها به ترتیب باز می‌شن؛ اول واحدهای قبلی رو تموم کن.',
                    action: 'برگشت به نقشه',
                    onAction: () => courseId.isNotEmpty
                        ? context.pushReplacement(Routes.roadmap(courseId))
                        : _close(),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            );
          } else if (_u == null) {
            body = const _UnitSkeleton();
          } else if (_mode == _Mode.quiz) {
            final qs = QuizQuestion.fromPayload(_u!.payload);
            body = qs.isEmpty
                ? SafeArea(
                    child: Center(
                      child: EmptyState(
                        icon: MI.quiz,
                        title: 'این آزمون هنوز سؤال نداره',
                        body: 'استاد که سؤال‌ها رو بذاره، همین‌جا می‌بینیشون.',
                        action: 'برگشت',
                        onAction: _close,
                      ),
                    ),
                  )
                : QuizRunner(
                    key: ValueKey(
                      'quiz-${_u!.attemptCount}-${_result?.attempts.length ?? 0}',
                    ),
                    unitId: _u!.id,
                    title: _u!.title,
                    questions: qs,
                    onExit: _close,
                    onResult: (r) => setState(() {
                      ProgressEvents.notify();
                      _result = r;
                      _mode = _Mode.result;
                    }),
                  );
          } else if (_mode == _Mode.result) {
            body = QuizResultView(
              result: _result!,
              unitTitle: _u!.title,
              onClose: _close,
              onContinue: () => _moveOn(_result!.progress),
              onReview: () async {
                final r = await context.push<String>(
                  Routes.quizReview(_u!.id),
                  extra: {'course_id': courseId},
                );
                if (r == 'retry' && mounted) setState(() => _mode = _Mode.quiz);
              },
              onRetry: () => setState(() => _mode = _Mode.quiz),
            );
          } else {
            body = _content(context, _u!);
          }
          return Scaffold(
            backgroundColor: C.paper,
            // Quiz → result (and the other modes) are peers: fade-through.
            body: MasirFadeThrough(index: _mode.index, child: body),
          );
        },
      ),
    );
  }

  Widget _content(BuildContext context, UnitContent u) {
    final pal = context.pal;
    final teacher = u.teachers.firstOrNull;
    final meta = unitMeta(u.type, u.durationMinutes, 0);
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final p = u.payload;
    final Widget inner;
    switch (u.type) {
      case 'video':
        inner = VideoUnitPlayer(
          media: MediaPayload.fromJson(p),
          onProgress: (v) => _progress.value = v,
        );
      case 'audio':
        inner = AudioUnitPlayer(
          media: MediaPayload.fromJson(p),
          onProgress: (v) => _progress.value = v,
        );
      case 'practice':
        inner = _Practice(payload: p);
      default:
        inner = LessonBlocks.has(p)
            ? LessonBlocks(payload: p)
            : RichBody('${p['body'] ?? ''}');
    }
    final media = u.type == 'video' || u.type == 'audio';
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, top + 12, 16, 8),
          child: Row(
            children: [
              CloseCircle(label: 'بستن و برگشت به نقشه', onTap: _close),
              const SizedBox(width: 12),
              Expanded(
                child: _PathSteps(
                  unit: u,
                  outline: _outline,
                  progress: _progress,
                ),
              ),
              if (teacher != null) ...[
                const SizedBox(width: 12),
                Semantics(
                  label: 'استاد: ${teacher.name}',
                  child: ClipOval(
                    child: SizedBox.square(
                      dimension: 36,
                      child: teacher.photoUrl.isNotEmpty
                          ? CoverImage(url: teacher.photoUrl)
                          : Avatar(name: teacher.name, size: 36),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (u.isPreview && !u.isSubscribed)
          Container(
            margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: C.sunSoft,
              border: Border.all(color: C.sunBorder, width: 2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: C.sun,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'رایگان',
                    style: T.of(11, FontWeight.w800, C.sunInk),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    u.previewCount > 0
                        ? 'پیش‌نمایش رایگان · ${fa(u.previewIndex)} از ${fa(u.previewCount)}'
                        : 'پیش‌نمایش رایگان',
                    style: T.of(13, FontWeight.w700, C.sunText),
                  ),
                ),
                GestureDetector(
                  onTap: _plans,
                  child: SizedBox(
                    height: 32,
                    child: Center(
                      widthFactor: 1,
                      child: Text(
                        'اشتراک',
                        style: T.of(13, FontWeight.w800, C.sunText),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView(
            controller: _scroll,
            padding: EdgeInsets.fromLTRB(
              media ? 16 : 20,
              12,
              media ? 16 : 20,
              24,
            ),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: media ? 4 : 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: pal.soft,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MIcon(unitIcon(u.type), size: 16, color: pal.ink),
                          const SizedBox(width: 6),
                          Text(
                            [
                              unitTypeNames[u.type] ?? '',
                              if (meta.isNotEmpty) meta,
                            ].join(' · '),
                            style: T.of(13, FontWeight.w800, pal.ink),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      u.title,
                      style: T.of(media ? 24 : 26, FontWeight.w900, C.ink, 1.4),
                    ),
                    if (u.type == 'html') ...[
                      const SizedBox(height: 10),
                      Text(
                        [
                          if (teacher != null) teacher.name,
                          if (u.pathTitle.isNotEmpty) 'مسیر ${u.pathTitle}',
                        ].join(' · '),
                        style: T.of(13, FontWeight.w500, C.muted),
                      ),
                    ],
                    if (u.type == 'practice') ...[
                      const SizedBox(height: 8),
                      Text(
                        // With steps, the intro sits here (UnitPractice).
                        _practiceSteps(p).isNotEmpty &&
                                '${p['instructions'] ?? ''}'.trim().isNotEmpty
                            ? '${p['instructions']}'.trim()
                            : 'این تمرین رو روی کاغذ یا توی فایل انجام بده، بعد برگرد و تیکش رو بزن.',
                        style: T.of(15, FontWeight.w500, C.body, 1.9),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: media ? 16 : 18),
              inner,
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: C.surface,
            border: Border(top: BorderSide(color: C.border, width: 2)),
          ),
          padding: EdgeInsets.fromLTRB(16, 12, 16, 20 + bottom),
          child: AnimatedSwitcher(
            duration: MasirMotion.quick,
            child: _done
                ? const _DoneButton()
                : Btn(
                    unitDoneLabels[u.type] ?? 'تموم شد',
                    height: 56,
                    fontSize: 18,
                    loading: _busy,
                    onPressed: _complete,
                  ),
          ),
        ),
      ],
    );
  }
}

/// Segments for the units of this path: done green, this one filling with
/// the student's progress through it.
class _PathSteps extends StatelessWidget {
  final UnitContent unit;
  final Outline? outline;
  final ValueNotifier<double> progress;
  const _PathSteps({
    required this.unit,
    required this.outline,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    OutlinePath? path;
    for (final m in outline?.modules ?? const <OutlineModule>[]) {
      for (final p in m.paths) {
        if (p.units.any((x) => x.id == unit.id)) path = p;
      }
    }
    final units =
        path?.units ??
        [
          OutlineUnit(
            id: unit.id,
            title: unit.title,
            type: unit.type,
            completed: unit.completed,
            locked: false,
            isPreview: unit.isPreview,
            durationMinutes: unit.durationMinutes,
            questionCount: 0,
          ),
        ];
    final idx = units.indexWhere((x) => x.id == unit.id);
    return Semantics(
      label: 'واحد ${fa(idx + 1)} از ${fa(units.length)} این مسیر',
      child: ValueListenableBuilder<double>(
        valueListenable: progress,
        builder: (_, v, _) => Row(
          children: [
            for (var i = 0; i < units.length; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 10,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: i != idx && units[i].completed ? C.green : C.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: i == idx
                      ? FractionallySizedBox(
                          alignment: AlignmentDirectional.centerStart,
                          widthFactor: unit.completed ? 1 : v.clamp(.04, 1),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: unit.completed ? C.green : pal.p,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

List<String> _practiceSteps(Map<String, dynamic> p) => [
  for (final s in (p['steps'] as List? ?? const []))
    if ('$s'.trim().isNotEmpty) '$s'.trim(),
];

/// The practice's files; older units have only the single attachment.
List<({String url, String name, int size})> _practiceFiles(
  Map<String, dynamic> p,
) {
  final list = [
    for (final a in (p['attachments'] as List? ?? const []).whereType<Map>())
      (
        url: '${a['url'] ?? ''}',
        name: '${a['name'] ?? ''}',
        size: (a['size_bytes'] as num?)?.toInt() ?? 0,
      ),
  ].where((a) => a.url.isNotEmpty).toList();
  if (list.isEmpty && '${p['attachment_url'] ?? ''}'.isNotEmpty) {
    list.add((
      url: '${p['attachment_url']}',
      name: '${p['attachment_name'] ?? ''}',
      size: (p['attachment_size_bytes'] as num?)?.toInt() ?? 0,
    ));
  }
  return list;
}

class _Practice extends StatelessWidget {
  final Map<String, dynamic> payload;
  const _Practice({required this.payload});

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final steps = _practiceSteps(payload);
    final files = _practiceFiles(payload);
    String human(int b) => b >= 1024 * 1024
        ? '${fa((b / 1024 / 1024).toStringAsFixed(1))} مگابایت'
        : '${fa((b / 1024).round())} کیلوبایت';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: cardDecoration(radius: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('چی کار کنی', style: T.of(17, FontWeight.w800)),
              const SizedBox(height: 14),
              if (steps.isEmpty)
                RichBody(
                  '${payload['instructions'] ?? ''}',
                  fontSize: 15,
                  lineHeight: 1.9,
                )
              else
                for (var i = 0; i < steps.length; i++) ...[
                  if (i > 0) const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: pal.p,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          fa(i + 1),
                          style: T.of(14, FontWeight.w800, pal.on, 1),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          steps[i],
                          style: T.of(15, FontWeight.w500, C.ink, 1.9),
                        ),
                      ),
                    ],
                  ),
                ],
            ],
          ),
        ),
        if (files.isNotEmpty) ...[
          const SizedBox(height: 18),
          Text('پیوست', style: T.of(17, FontWeight.w800)),
          for (final f in files) ...[
            const SizedBox(height: 10),
            _PracticeFile(
              url: f.url,
              name: f.name,
              size: f.size > 0 ? human(f.size) : '',
            ),
          ],
        ],
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: C.sunSoft,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 3),
                child: MIcon(MI.clock, size: 20, color: C.sunText),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'عجله نکن؛ پیشرفتت ذخیره شده. هر وقت برگردی، از همین‌جا ادامه می‌دی.',
                  style: T.of(14, FontWeight.w500, C.sunText, 1.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The finished button: green, with a check that draws itself (250ms).
class _DoneButton extends StatelessWidget {
  const _DoneButton();

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'ثبت شد',
    liveRegion: true,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Btn('', kind: BtnKind.success, height: 56, onPressed: () {}),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: MasirMotion.reduced(context) ? 1 : 0, end: 1),
            duration: const Duration(milliseconds: 250),
            curve: MasirMotion.standard,
            builder: (_, t, _) => CustomPaint(
              size: const Size.square(28),
              painter: _CheckPainter(t),
            ),
          ),
        ),
      ],
    ),
  );
}

class _CheckPainter extends CustomPainter {
  final double t;
  _CheckPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * .2, size.height * .53)
      ..lineTo(size.width * .42, size.height * .75)
      ..lineTo(size.width * .82, size.height * .28);
    final metric = path.computeMetrics().first;
    canvas.drawPath(
      metric.extractPath(0, metric.length * t),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.6
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_CheckPainter old) => old.t != t;
}

/// «پایان بخش رایگان»: the free units are done; what a subscription opens.
class PreviewEndView extends StatelessWidget {
  final Outline? outline;
  final VoidCallback onClose;
  final VoidCallback onPlans;
  const PreviewEndView({
    super.key,
    required this.outline,
    required this.onClose,
    required this.onPlans,
  });

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final o = outline;
    final free = (o?.previewUnitCount ?? 0).clamp(0, 5);
    final total = o?.totalUnits ?? 0;
    final rest = (total - free).clamp(0, total);
    final plans = o?.plans ?? const <CoursePlan>[];
    final monthly = plans.where((p) => p.months == 1).firstOrNull;
    final yearly = plans.where((p) => p.months == 12).firstOrNull;
    final priceLine = [
      if (monthly != null) 'اشتراک ماهانه ${shortToman(monthly.price)} تومان',
      if (yearly != null) 'سالانه ماهی ${shortToman(yearly.perMonth)}',
    ].join(' · ');
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;
    Widget doneDot() => Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: C.green,
        shape: BoxShape.circle,
        boxShadow: [lip(C.greenDark)],
      ),
      alignment: Alignment.center,
      child: const MIcon(
        MI.check,
        size: 20,
        color: Colors.white,
        strokeWidth: 3.2,
      ),
    );
    Widget link(bool on) => Container(
      width: 16,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: on ? C.green : C.lip,
        borderRadius: BorderRadius.circular(3),
      ),
    );
    Widget perk(String t, {bool last = false}) => Container(
      constraints: const BoxConstraints(minHeight: 46),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: C.sand, width: 2)),
      ),
      child: Row(
        children: [
          const MIcon(MI.check, size: 18, color: C.greenText, strokeWidth: 3),
          const SizedBox(width: 10),
          Expanded(child: Text(t, style: T.of(15, FontWeight.w500))),
        ],
      ),
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(20, top + 12, 20, 24 + bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: CloseCircle(label: 'بستن', onTap: onClose),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Semantics(
                      label:
                          '${fa(free)} واحد رایگان تموم شد، ${fa(rest)} واحد قفل',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i = 0; i < free; i++) ...[
                            doneDot(),
                            link(i < free - 1),
                          ],
                          if (free == 0) link(false),
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: pal.p,
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [lip(pal.e, 5)],
                            ),
                            alignment: Alignment.center,
                            child: MIcon(
                              MI.unlock,
                              size: 28,
                              color: pal.on,
                              strokeWidth: 2.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: C.sunSoft,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'پایان بخش رایگان',
                        style: T.of(13, FontWeight.w800, C.sunText),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'خوشت اومد؟ ادامه‌ش منتظرته',
                      textAlign: TextAlign.center,
                      style: T.of(28, FontWeight.w900, C.ink, 1.4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      rest > 0
                          ? 'هر ${fa(free)} واحد رایگان رو تموم کردی. با اشتراک، ${fa(rest)} واحد دیگه و همه‌ی جام‌ها باز می‌شن.'
                          : 'بخش رایگان رو تموم کردی. با اشتراک، بقیه‌ی واحدها و همه‌ی جام‌ها باز می‌شن.',
                      textAlign: TextAlign.center,
                      style: T.of(15, FontWeight.w500, C.body, 1.9),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: C.surface,
                        border: Border.all(color: C.border, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          perk(
                            total > 0
                                ? 'همه‌ی ${fa(total)} واحد و جام‌های فصل'
                                : 'همه‌ی واحدها و جام‌های فصل',
                          ),
                          perk('پیشرفتت از همین‌جا ادامه پیدا می‌کنه'),
                          perk(
                            'هر وقت خواستی تمدید نکن؛ چیزی پاک نمی‌شه',
                            last: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (priceLine.isNotEmpty) ...[
            Text(
              priceLine,
              textAlign: TextAlign.center,
              style: T.of(14, FontWeight.w500, C.body),
            ),
            const SizedBox(height: 8),
          ],
          Btn('انتخاب اشتراک', height: 56, fontSize: 18, onPressed: onPlans),
          const SizedBox(height: 8),
          Btn(
            'برگشت به نقشه',
            kind: BtnKind.ghost,
            height: 44,
            fontSize: 15,
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class _UnitSkeleton extends StatelessWidget {
  const _UnitSkeleton();
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      20,
      MediaQuery.paddingOf(context).top + 16,
      20,
      20,
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Bone(width: 44, height: 44, radius: 22),
            SizedBox(width: 12),
            Expanded(child: Bone(height: 10)),
          ],
        ),
        SizedBox(height: 24),
        Bone(width: 110, height: 30, radius: 999),
        SizedBox(height: 12),
        Bone(width: 240, height: 28),
        SizedBox(height: 24),
        Bone(height: 14),
        SizedBox(height: 10),
        Bone(height: 14),
        SizedBox(height: 10),
        Bone(width: 200, height: 14),
        SizedBox(height: 24),
        Bone(height: 168, radius: 20),
      ],
    ),
  );
}

/// One downloadable practice file (PDF, Word or audio).
class _PracticeFile extends StatelessWidget {
  final String url;
  final String name;
  final String size;
  const _PracticeFile({
    required this.url,
    required this.name,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final clean = Uri.decodeComponent(url.split('?').first.split('/').last);
    final shown = name.isNotEmpty ? name : clean;
    final ext = shown.contains('.')
        ? shown.split('.').last.toUpperCase()
        : 'فایل';
    return Semantics(
      button: true,
      label: 'دانلود $shown',
      child: GestureDetector(
        onTap: () =>
            launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: C.surface,
            border: Border.all(color: C.border, width: 2),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE9EA),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  ext.length > 4 ? ext.substring(0, 4) : ext,
                  style: T.of(11, FontWeight.w900, C.coralText),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shown.isEmpty ? 'فایل تمرین' : shown,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: T.of(15, FontWeight.w800),
                    ),
                    if (size.isNotEmpty)
                      Text(size, style: T.of(13, FontWeight.w500, C.muted)),
                  ],
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: pal.soft,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: MIcon(
                  MI.download,
                  size: 20,
                  color: pal.ink,
                  strokeWidth: 2.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
