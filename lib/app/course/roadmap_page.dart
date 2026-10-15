import 'dart:math' as math;
import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/app/course/course_detail_page.dart' show unitIcon;
import '/app/course/plan_sheet.dart';
import '/app/routes.dart';
import '/app/state/nav.dart';
import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/api/models.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

/// A finished unit that completed a path; the roadmap celebrates it once
/// when the student comes back to it.
class RoadmapEvents {
  RoadmapEvents._();
  static ({String courseId, ProgressUpdate update})? pathDone;
}

enum _St { done, current, open, free, locked }

/// One thing on the trail: a unit, a chapter trophy or the finish flag.
class _Stop {
  final String id;
  final String type; // unit type, 'trophy' or 'flag'
  final String title;
  final String meta;
  final _St st;
  final OutlineUnit? unit;
  final int module;
  const _Stop({required this.id, required this.type, required this.title, required this.meta, required this.st, this.unit, required this.module});
  bool get special => type == 'trophy' || type == 'flag';
}

class _Plate {
  final int num;
  final String title;
  final _St st;
  final String tag;
  const _Plate(this.num, this.title, this.st, this.tag);
}

class _Marker {
  final String text;
  final _St st;
  const _Marker(this.text, this.st);
}

class _Item {
  final _Plate? plate;
  final _Marker? marker;
  final _Stop? stop;
  const _Item({this.plate, this.marker, this.stop});
}

/// «نقشه‌ی مسیر»: the course as a winding trail of units, with chapter
/// plates, path markers, trophies and the finish flag.
class RoadmapPage extends StatefulWidget {
  final String courseId;
  const RoadmapPage({super.key, required this.courseId});

  @override
  State<RoadmapPage> createState() => _RoadmapPageState();
}

class _RoadmapPageState extends State<RoadmapPage> {
  final api = inject<MasirApi>();
  final _scroll = ScrollController();
  Outline? _o;
  CourseDetail? _course;
  ApiError? _error;
  ProgressUpdate? _celebrate;
  bool _scrolled = false;
  final Map<int, double> _plateTops = {};

  @override
  void initState() {
    super.initState();
    _load();
    api.course(widget.courseId).then((r) => r.fold((_) {}, (c) {
      if (mounted) setState(() => _course = c);
    }));
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final r = await api.outline(widget.courseId);
    if (!mounted) return;
    r.fold((e) => setState(() => _error = e), (o) => setState(() {
      _o = o;
      _error = null;
    }));
    final ev = RoadmapEvents.pathDone;
    if (ev != null && ev.courseId == widget.courseId) {
      RoadmapEvents.pathDone = null;
      setState(() => _celebrate = ev.update);
    }
  }

  bool get _guest => !(_o?.access.enrolled ?? false);

  bool _needsSub(OutlineUnit u) => !(_o!.access.fullAccess) && !u.isPreview && !u.completed;

  Future<void> _openUnit(OutlineUnit u) async {
    if (_guest) {
      final r = await api.enroll(widget.courseId);
      if (!mounted) return;
      final e = r.fold((e) => e, (_) => null);
      if (e != null) {
        Toast.show(context, title: 'باز نشد', body: e.friendly, tone: ToastTone.error);
        return;
      }
    }
    await context.push(Routes.unit(u.id), extra: {'course_id': widget.courseId});
    if (mounted) _load();
  }

  Future<void> _plans() async {
    await showPlanSheet(context, courseId: widget.courseId, renew: _o?.access.state == AccessState.expired, brand: context.brand);
    if (mounted) _load();
  }

  // ------------------------------------------------------------ sequence

  List<_Item> _sequence(Outline o) {
    final guest = _guest;
    final items = <_Item>[];
    for (var mi = 0; mi < o.modules.length; mi++) {
      final m = o.modules[mi];
      final units = [for (final p in m.paths) ...p.units];
      final done = units.where((u) => u.completed).length;
      final hasCurrent = units.any((u) => u.id == o.currentUnitId);
      final hasFree = units.any((u) => u.isPreview);
      final _Plate plate;
      if (guest) {
        plate = _Plate(mi + 1, m.title, hasFree ? _St.open : _St.locked, hasFree ? 'رایگان' : 'قفل');
      } else if (units.isNotEmpty && done == units.length) {
        plate = _Plate(mi + 1, m.title, _St.done, 'کامل');
      } else if (hasCurrent) {
        plate = _Plate(mi + 1, m.title, _St.current, '${fa(done)} از ${fa(units.length)}');
      } else {
        plate = _Plate(mi + 1, m.title, _St.locked, 'قفل');
      }
      for (var pi = 0; pi < m.paths.length; pi++) {
        final p = m.paths[pi];
        final pDone = p.units.isNotEmpty && p.units.every((u) => u.completed);
        final pCurrent = p.units.any((u) => u.id == o.currentUnitId);
        final pFree = p.units.any((u) => u.isPreview);
        final _St st = guest
            ? (pFree ? _St.open : _St.locked)
            : pDone
                ? _St.done
                : pCurrent
                    ? _St.current
                    : _St.locked;
        String text;
        if (guest || st == _St.locked) {
          text = !guest && st == _St.locked && hasCurrent && pi > 0
              ? 'مسیر ${fa(pi + 1)} · بعد از مسیر ${fa(pi)} باز می‌شه'
              : 'مسیر ${fa(pi + 1)} · ${p.title}';
        } else {
          final pct0 = p.units.isEmpty ? 0 : p.units.where((u) => u.completed).length * 100 ~/ p.units.length;
          text = 'مسیر ${fa(pi + 1)} · ${p.title} · ${pct(pct0)}';
        }
        items.add(_Item(plate: pi == 0 ? plate : null, marker: _Marker(text, st)));
        for (final u in p.units) {
          _St s;
          if (u.completed) {
            s = _St.done;
          } else if (!guest && u.id == o.currentUnitId) {
            s = _St.current;
          } else if (guest) {
            s = u.isPreview ? _St.free : _St.locked;
          } else if (!u.locked) {
            s = _St.open;
          } else {
            s = _St.locked;
          }
          items.add(_Item(stop: _Stop(
            id: u.id,
            type: u.type,
            title: u.title,
            meta: unitMeta(u.type, u.durationMinutes, u.questionCount),
            st: s,
            unit: u,
            module: mi,
          )));
        }
      }
      if (m.paths.isEmpty) items.add(_Item(plate: plate));
      final left = units.length - done;
      final last = mi == o.modules.length - 1;
      final tDone = !guest && units.isNotEmpty && left == 0;
      items.add(_Item(stop: _Stop(
        id: 'trophy-${m.id}',
        type: 'trophy',
        title: 'جام فصل ${fa(mi + 1)}',
        meta: guest ? '' : tDone ? 'گرفتیش!' : last ? 'آخرین جام' : 'بعد از ${fa(left)} واحد',
        st: tDone ? _St.done : _St.locked,
        module: mi,
      )));
    }
    final finished = !guest && o.totalUnits > 0 && o.completedUnits >= o.totalUnits;
    items.add(_Item(stop: _Stop(id: 'end', type: 'flag', title: 'پایان مسیر', meta: 'خط پایان', st: finished ? _St.done : _St.locked, module: o.modules.length)));
    return items;
  }

  // ------------------------------------------------------------ build

  @override
  Widget build(BuildContext context) {
    final o = _o;
    final brand = _course?.instituteBrand ?? context.brand;
    return BrandScope(
      brand: brand,
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: C.paper,
          body: Column(children: [
            _Header(
              title: o?.title ?? _course?.card.title ?? '',
              outline: o,
              guest: _guest,
              bump: _celebrate != null,
              onChapters: o == null ? null : () => _chapters(context, o),
            ),
            Expanded(
              child: o == null
                  ? (_error != null
                      ? Padding(padding: const EdgeInsets.all(16), child: InlineError(body: _error!.friendly, onRetry: _load))
                      : const Center(child: SizedBox(width: 32, height: 32, child: CircularProgressIndicator(strokeWidth: 3))))
                  : Stack(children: [
                      Positioned.fill(child: _map(context, o)),
                      if (_celebrate != null)
                        Positioned(
                          left: 12,
                          right: 12,
                          bottom: 16,
                          child: _Celebration(
                            update: _celebrate!,
                            outline: o,
                            onGo: (u) {
                              setState(() => _celebrate = null);
                              _openUnit(u);
                            },
                            onClose: () => setState(() => _celebrate = null),
                          ),
                        ),
                    ]),
            ),
          ]),
          bottomNavigationBar: o == null || _celebrate != null ? null : _bar(context, o),
        );
      }),
    );
  }

  Widget _map(BuildContext context, Outline o) => LayoutBuilder(builder: (context, box) {
    final w = box.maxWidth;
    final pal = context.pal;
    final seq = _sequence(o);
    final plates = <Widget>[];
    final markers = <Widget>[];
    final pins = <Widget>[];
    final pts = <Offset>[];
    double y = 16;
    double? prevCy;
    var side = 0;
    var curIdx = -1;
    double curY = 0;
    _Item? pending;
    const base = 140.0;
    final cxR = w - 92;
    const cxL = 92.0;
    final lw = math.min(170.0, w - 220);
    _plateTops.clear();

    void attach(_Item att, double mid) {
      if (att.marker != null) {
        markers.add(Positioned(top: mid - 16, left: 0, right: 0, child: Center(child: _MarkerChip(m: att.marker!))));
      }
      final p = att.plate;
      if (p != null) {
        final top = att.marker != null ? mid - 16 - 20 - 76 : mid - 38;
        _plateTops[p.num - 1] = top;
        plates.add(Positioned(top: top, left: 16, right: 16, height: 76, child: _PlateCard(p: p)));
      }
    }

    for (final it in seq) {
      final s = it.stop;
      if (s == null) {
        pending = it;
        continue;
      }
      double cy;
      if (prevCy == null) {
        if (pending != null) {
          if (pending.plate != null) {
            attach(_Item(plate: pending.plate), y + 38);
            y += 76 + 20;
          }
          if (pending.marker != null) {
            attach(_Item(marker: pending.marker), y + 16);
            y += 32 + 28;
          }
        }
        cy = y + 42;
      } else {
        var dy = base;
        if (pending?.plate != null) dy += 160;
        if (pending?.marker != null) dy += 36;
        cy = prevCy + dy;
        if (pending != null) attach(pending, prevCy + dy / 2);
      }
      pending = null;
      final isR = side.isEven;
      final cx = isR ? cxR : cxL;
      side++;
      final current = s.st == _St.current;
      final size = current ? 80.0 : (s.special ? 72.0 : 68.0);
      if (current) {
        curIdx = pts.length;
        curY = cy;
      }
      pts.add(Offset(cx, cy));
      final labelLeft = isR ? cx - size / 2 - 14 - lw : cx + size / 2 + 14;
      if (current) {
        pins.add(Positioned(left: cx - size / 2, top: cy - size / 2, width: size, height: size, child: _Pulse(color: pal.p)));
      }
      pins.add(Positioned(
        left: cx - size / 2,
        top: cy - size / 2,
        width: size,
        height: size,
        child: _Pin(stop: s, size: size, guest: _guest, onTap: () => _pick(context, o, s)),
      ));
      if (s.st == _St.free) {
        pins.add(Positioned(
          top: cy - size / 2 - 12,
          left: cx - 28,
          width: 56,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(color: C.sun, borderRadius: BorderRadius.circular(999)),
            child: Text('رایگان', textAlign: TextAlign.center, style: T.of(11, FontWeight.w800, C.sunInk)),
          ),
        ));
      }
      pins.add(Positioned(
        top: cy - (current ? 44 : 26),
        left: labelLeft,
        width: lw,
        child: IgnorePointer(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: isR ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                if (current) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(color: pal.p, borderRadius: BorderRadius.circular(10)),
                    child: Text('شروع', style: T.of(13, FontWeight.w800, pal.on)),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  s.special ? s.meta : [unitTypeNames[s.type] ?? '', if (s.meta.isNotEmpty) s.meta].join(' · '),
                  textAlign: isR ? TextAlign.right : TextAlign.left,
                  style: T.of(12, FontWeight.w600, C.muted),
                ),
                const SizedBox(height: 4),
                Text(
                  s.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: isR ? TextAlign.right : TextAlign.left,
                  style: T.of(14, FontWeight.w800, s.st == _St.locked ? C.muted : C.ink, 1.5),
                ),
              ],
            ),
          ),
        ),
      ));
      prevCy = cy;
    }
    final mapH = (prevCy ?? 0) + 140;
    final walked = curIdx > 0 ? pts.sublist(0, curIdx + 1) : <Offset>[];
    final ahead = _guest ? pts : pts.sublist(math.max(curIdx, 0));

    if (!_scrolled && curIdx >= 0) {
      _scrolled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) {
          _scroll.jumpTo((curY - 260).clamp(0, _scroll.position.maxScrollExtent));
        }
      });
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: SingleChildScrollView(
        controller: _scroll,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: _celebrate != null ? 320 : 0),
        child: SizedBox(
          width: w,
          height: mapH,
          child: Stack(clipBehavior: Clip.none, children: [
            Positioned.fill(child: CustomPaint(painter: _TrailPainter(walked: walked, ahead: ahead))),
            ...plates,
            ...markers,
            ...pins,
          ]),
        ),
      ),
    );
  });

  Widget _bar(BuildContext context, Outline o) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    Widget body;
    if (_guest) {
      final free = o.previewUnitCount;
      final freeCourse = o.access.freeCourse || o.access.state == AccessState.freeCourse;
      body = Row(children: [
        Expanded(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(freeCourse ? 'همه‌ی واحدها رایگانه' : '${fa(free)} واحد اول رایگانه', style: T.of(15, FontWeight.w800)),
          Text(freeCourse ? 'از اولین واحد شروع کن' : 'بقیه با اشتراک باز می‌شه', style: T.of(13, FontWeight.w500, C.muted)),
        ])),
        const SizedBox(width: 12),
        SizedBox(
          width: 150,
          child: freeCourse
              ? Btn('شروع', height: 54, fontSize: 17, onPressed: o.units.isEmpty ? null : () => _openUnit(o.units.first))
              : Btn('اشتراک', height: 54, fontSize: 17, onPressed: _plans),
        ),
      ]);
    } else {
      final cur = o.currentUnit;
      if (cur == null) {
        body = Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('همه‌ی واحدهای این دوره رو تموم کردی!', textAlign: TextAlign.center, style: T.of(14, FontWeight.w700, C.body)),
          const SizedBox(height: 10),
          Btn('برگشت به دوره', kind: BtnKind.secondary, height: 54, fontSize: 17, onPressed: () => back(context, fallback: Routes.course(widget.courseId))),
        ]);
      } else {
        final sub = _needsSub(cur);
        final meta = unitMeta(cur.type, cur.durationMinutes, cur.questionCount);
        body = Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Text('بعدی:', style: T.of(13, FontWeight.w700, C.muted)),
            const SizedBox(width: 8),
            Flexible(child: Text(cur.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.of(13, FontWeight.w700))),
            if (meta.isNotEmpty) Text(' · $meta', style: T.of(13, FontWeight.w500, C.muted)),
          ]),
          const SizedBox(height: 10),
          sub
              ? Btn(o.access.state == AccessState.expired ? 'تمدید اشتراک' : 'اشتراک بگیر و ادامه بده', height: 54, fontSize: 17, onPressed: _plans)
              : Btn('ادامه یادگیری', height: 54, fontSize: 17, onPressed: () => _openUnit(cur)),
        ]);
      }
    }
    return Container(
      decoration: const BoxDecoration(color: C.surface, border: Border(top: BorderSide(color: C.border, width: 2))),
      padding: EdgeInsets.fromLTRB(16, 12, 16, 20 + bottom),
      child: body,
    );
  }

  // ------------------------------------------------------------ sheets

  void _pick(BuildContext context, Outline o, _Stop s) {
    final pal = context.pal;
    final u = s.unit;
    final kicker = s.special ? s.title : '${unitTypeNames[s.type] ?? ''}${s.meta.isNotEmpty ? ' · ${s.meta}' : ''}';
    String note;
    String? cta;
    VoidCallback? action;
    var kind = BtnKind.primary;
    final cur = o.currentUnit;
    switch (s.st) {
      case _St.done:
        if (s.special) {
          note = s.type == 'flag' ? 'کل این دوره رو تموم کردی. ایول!' : 'این فصل رو کامل کردی. جامش مال توئه.';
        } else if (s.type == 'quiz') {
          note = u?.quizScore != null
              ? 'نتیجه‌ی آخرین تلاشت: ${pct(u!.quizScore!)}. اگه دوباره بدی، نتیجه‌ی جدید جاش ثبت می‌شه، حتی اگه کمتر باشه.'
              : 'اگه دوباره بدی، نتیجه‌ی جدید جاش ثبت می‌شه، حتی اگه کمتر باشه.';
        } else {
          note = 'تمومش کردی. هر وقت خواستی برگرد و مرورش کن.';
        }
        if (!s.special) {
          cta = unitRedoLabels[s.type] ?? 'دوباره ببین';
          kind = BtnKind.secondary;
          action = () => _openUnit(u!);
        }
      case _St.current:
        if (u != null && _needsSub(u)) {
          note = 'این واحد با اشتراک باز می‌شه${o.plans.isNotEmpty ? '؛ از ${perMonth(o.plans.map((p) => p.perMonth).reduce(math.min))} تومان' : ''}.';
          cta = 'دیدن اشتراک‌ها';
          action = _plans;
        } else {
          final path = o.modules.expand((m) => m.paths).firstWhere((p) => p.units.any((x) => x.id == s.id));
          final after = path.units.length - 1 - path.units.indexWhere((x) => x.id == s.id);
          note = 'نوبت همینه.${s.meta.isNotEmpty && s.type != 'quiz' ? ' حدود ${s.meta} وقت می‌گیره' : ''}'
              '${after > 0 ? '${s.meta.isNotEmpty && s.type != 'quiz' ? ' و' : ''} بعدش ${fa(after)} قدم دیگه تا آخر این مسیر.' : '${s.meta.isNotEmpty && s.type != 'quiz' ? ' و' : ''} با تموم شدنش این مسیر کامل می‌شه.'}';
          cta = 'شروع';
          action = () => _openUnit(u!);
        }
      case _St.free:
        note = 'این واحد رایگانه؛ بدون اشتراک امتحانش کن.';
        cta = 'شروع رایگان';
        action = () => _openUnit(u!);
      case _St.open:
        note = 'این واحد بازه؛ هر وقت خواستی شروعش کن.';
        cta = 'شروع';
        action = () => _openUnit(u!);
      case _St.locked:
        if (!s.special && u != null && (_guest || _needsSub(u)) && !u.isPreview) {
          final from = o.plans.isNotEmpty ? o.plans.map((p) => p.perMonth).reduce(math.min) : 0;
          note = 'این واحد با اشتراک باز می‌شه${from > 0 ? '؛ از ${perMonth(from)} تومان' : ''}.';
          cta = 'دیدن اشتراک‌ها';
          action = _plans;
        } else {
          note = s.special
              ? (s.type == 'flag' ? 'همه‌ی واحدهای دوره رو تموم کن تا به خط پایان برسی.' : 'همه‌ی واحدهای این فصل رو تموم کن تا جامش رو بگیری.')
              : cur != null
                  ? 'واحدها به ترتیب باز می‌شن؛ اول «${cur.title}» رو تموم کن.'
                  : 'واحدها به ترتیب باز می‌شن.';
          cta = 'هنوز قفله';
        }
    }
    showMasirSheet(context, builder: (sheet) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: pal.soft, borderRadius: BorderRadius.circular(999)),
            child: Center(widthFactor: 1, child: Text(kicker, style: T.of(13, FontWeight.w800, pal.ink))),
          ),
          const Spacer(),
          RoundIcon(MI.close, label: 'بستن', onTap: () => Navigator.of(sheet).pop()),
        ]),
        const SizedBox(height: 14),
        Text(s.title, style: T.of(22, FontWeight.w800, C.ink, 1.4)),
        const SizedBox(height: 14),
        Text(note, style: T.of(15, FontWeight.w500, C.body, 1.9)),
        if (cta != null) ...[
          const SizedBox(height: 14),
          action == null
              ? Container(
                  height: 54,
                  decoration: BoxDecoration(color: C.border, borderRadius: BorderRadius.circular(16)),
                  alignment: Alignment.center,
                  child: Text(cta, style: T.of(17, FontWeight.w800, C.muted)),
                )
              : Btn(cta, kind: kind, height: 54, fontSize: 17, onPressed: () {
                  Navigator.of(sheet).pop();
                  action!();
                }),
        ],
      ]),
    ));
  }

  void _chapters(BuildContext context, Outline o) {
    final pal = context.pal;
    showMasirSheet(context, builder: (sheet) {
      final rows = <Widget>[];
      var seenCurrent = false;
      for (var mi = 0; mi < o.modules.length; mi++) {
        final m = o.modules[mi];
        final units = [for (final p in m.paths) ...p.units];
        final done = units.where((u) => u.completed).length;
        final complete = units.isNotEmpty && done == units.length;
        final current = !complete && units.any((u) => u.id == o.currentUnitId);
        void go() {
          Navigator.of(sheet).pop();
          final top = _plateTops[mi];
          if (top != null && _scroll.hasClients) {
            _scroll.animateTo((top - 16).clamp(0, _scroll.position.maxScrollExtent), duration: const Duration(milliseconds: 420), curve: Curves.easeOutCubic);
          }
        }

        if (complete) {
          rows.add(GestureDetector(
            onTap: go,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: cardDecoration(radius: 20),
              child: Row(children: [
                _square(const MIcon(MI.cup, size: 24, color: C.sunInk), C.sun, C.sunDark),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('فصل ${fa(mi + 1)}', style: T.of(12, FontWeight.w500, C.muted)),
                  Text(m.title, style: T.of(16, FontWeight.w800)),
                ])),
                _pill('کامل', C.greenSoft, C.greenText),
              ]),
            ),
          ));
        } else if (current || (!seenCurrent && !_guest && done > 0)) {
          seenCurrent = true;
          rows.add(Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: pal.p, width: 2),
              boxShadow: [lip(pal.e)],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              GestureDetector(
                onTap: go,
                child: Container(
                  color: pal.p,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(children: [
                    _square(Text(fa(mi + 1), style: T.of(20, FontWeight.w900, pal.ink)), Colors.white, null),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('فصل ${fa(mi + 1)} · الان اینجایی', style: T.of(12, FontWeight.w500, pal.on.withValues(alpha: .9))),
                      Text(m.title, style: T.of(16, FontWeight.w800, pal.on)),
                    ])),
                    Text('${fa(done)} از ${fa(units.length)}', style: T.of(13, FontWeight.w800, pal.on)),
                  ]),
                ),
              ),
              Container(
                color: C.surface,
                padding: const EdgeInsets.fromLTRB(14, 6, 14, 8),
                child: Column(children: [
                  for (var pi = 0; pi < m.paths.length; pi++)
                    _pathRow(m.paths[pi], pi, o, last: pi == m.paths.length - 1, onTap: go),
                ]),
              ),
            ]),
          ));
        } else {
          rows.add(GestureDetector(
            onTap: go,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: C.sand,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: C.lip, width: 2),
              ),
              child: Row(children: [
                _square(Text(fa(mi + 1), style: T.of(20, FontWeight.w900, C.muted)), C.locked, null),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    _guest
                        ? 'فصل ${fa(mi + 1)}${units.any((u) => u.isPreview) ? ' · رایگان' : ''}'
                        : mi > 0
                            ? 'فصل ${fa(mi + 1)} · بعد از تموم شدن فصل ${fa(mi)}'
                            : 'فصل ${fa(mi + 1)}',
                    style: T.of(12, FontWeight.w500, C.muted),
                  ),
                  Text(m.title, style: T.of(16, FontWeight.w800, C.body)),
                ])),
                if (!(_guest && units.any((u) => u.isPreview))) const MIcon(MI.lock, size: 18, color: C.body, strokeWidth: 2.6),
              ]),
            ),
          ));
        }
      }
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Expanded(child: Text('فصل‌ها', style: T.of(20, FontWeight.w800))),
            RoundIcon(MI.close, label: 'بستن', onTap: () => Navigator.of(sheet).pop()),
          ]),
          for (final r in rows) ...[const SizedBox(height: 14), r],
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const MIcon(MI.info, size: 18, color: C.muted),
              const SizedBox(width: 10),
              Expanded(child: Text('هر واحد وقتی باز می‌شه که همه‌ی واحدهای قبلش تموم شده باشن.', style: T.of(13, FontWeight.w500, C.muted, 1.8))),
            ]),
          ),
        ]),
      );
    });
  }

  Widget _pathRow(OutlinePath p, int pi, Outline o, {required bool last, required VoidCallback onTap}) {
    final done = p.units.where((u) => u.completed).length;
    final open = p.units.any((u) => u.completed || u.id == o.currentUnitId);
    final pct0 = p.units.isEmpty ? 0 : done * 100 ~/ p.units.length;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        decoration: BoxDecoration(border: last ? null : const Border(bottom: BorderSide(color: C.sand, width: 2))),
        child: Row(children: [
          open
              ? Container(width: 10, height: 10, decoration: BoxDecoration(color: done == p.units.length ? C.green : C.sun, shape: BoxShape.circle))
              : const MIcon(MI.lock, size: 12, color: C.muted, strokeWidth: 3),
          const SizedBox(width: 10),
          Expanded(child: Text('مسیر ${fa(pi + 1)} · ${p.title}', style: T.of(15, FontWeight.w700, open ? C.ink : C.muted))),
          Text(open ? pct(pct0) : (pi > 0 ? 'بعد از مسیر ${fa(pi)}' : ''), style: T.of(13, FontWeight.w500, C.muted)),
        ]),
      ),
    );
  }

  static Widget _square(Widget child, Color bg, Color? lipColor) => Container(
    width: 48,
    height: 48,
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), boxShadow: lipColor == null ? null : [lip(lipColor)]),
    alignment: Alignment.center,
    child: child,
  );

  static Widget _pill(String text, Color bg, Color fg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
    child: Text(text, style: T.of(13, FontWeight.w800, fg)),
  );
}

class _Header extends StatelessWidget {
  final String title;
  final Outline? outline;
  final bool guest;
  final bool bump;
  final VoidCallback? onChapters;
  const _Header({required this.title, required this.outline, required this.guest, required this.bump, this.onChapters});

  @override
  Widget build(BuildContext context) {
    final o = outline;
    return Container(
      decoration: const BoxDecoration(color: C.paper, border: Border(bottom: BorderSide(color: C.border, width: 2))),
      padding: EdgeInsets.fromLTRB(16, MediaQuery.paddingOf(context).top + 12, 16, 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          BackSquare(label: 'برگشت به دوره', onTap: () => back(context)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('مسیر یادگیری', style: T.of(13, FontWeight.w600, C.muted)),
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.of(18, FontWeight.w800, C.ink, 1.4)),
          ])),
          if (onChapters != null) BackSquare(icon: MI.listDots, label: 'فهرست فصل‌ها', onTap: onChapters),
        ]),
        if (o != null) ...[
          const SizedBox(height: 12),
          if (guest)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: C.sunSoft, border: Border.all(color: C.sunBorder, width: 2), borderRadius: BorderRadius.circular(16)),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: C.sun, borderRadius: BorderRadius.circular(999)),
                  child: Text('رایگان', style: T.of(11, FontWeight.w800, C.sunInk)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    o.access.freeCourse ? 'همه‌ی واحدهای این دوره رایگانه' : '${fa(o.previewUnitCount)} واحد اول رو قبل از اشتراک امتحان کن',
                    style: T.of(13, FontWeight.w700, C.sunText),
                  ),
                ),
              ]),
            )
          else ...[
            Row(children: [
              Expanded(child: Text('${fa(o.completedUnits)} از ${fa(o.totalUnits)} واحد', style: T.of(13, FontWeight.w700))),
              Text(pct(o.progressPercent), style: T.of(13, FontWeight.w700, C.greenText)),
              if (bump) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(color: C.greenSoft, borderRadius: BorderRadius.circular(8)),
                  child: Text('+۱', style: T.of(13, FontWeight.w700, C.greenText)),
                ),
              ],
            ]),
            const SizedBox(height: 6),
            Track(value: o.progressPercent / 100, height: 10),
          ],
        ],
      ]),
    );
  }
}

class _PlateCard extends StatelessWidget {
  final _Plate p;
  const _PlateCard({required this.p});

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    late Color bg, border, lipC, fg, badgeBg, badgeFg, tagBg, tagFg;
    var dashed = false;
    switch (p.st) {
      case _St.done:
        (bg, border, lipC, fg, badgeBg, badgeFg, tagBg, tagFg) = (C.surface, C.border, C.lip, C.ink, C.green, Colors.white, C.greenSoft, C.greenText);
      case _St.current:
        (bg, border, lipC, fg, badgeBg, badgeFg, tagBg, tagFg) = (pal.p, pal.p, pal.e, pal.on, Colors.white, pal.ink, pal.on.withValues(alpha: .22), pal.on);
      case _St.open:
      case _St.free:
        (bg, border, lipC, fg, badgeBg, badgeFg, tagBg, tagFg) = (C.surface, C.sun, C.sunLip, C.ink, C.sun, C.sunInk, C.sunSoft, C.sunText);
      case _St.locked:
        (bg, border, lipC, fg, badgeBg, badgeFg, tagBg, tagFg) = (C.sand, C.lip, Colors.transparent, C.body, C.locked, C.muted, C.locked, C.body);
        dashed = true;
    }
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(14)),
          alignment: Alignment.center,
          child: Text(fa(p.num), style: T.of(18, FontWeight.w900, badgeFg)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('فصل ${fa(p.num)}', style: T.of(12, FontWeight.w700, fg.withValues(alpha: .85))),
          Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.of(17, FontWeight.w800, fg)),
        ])),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: tagBg, borderRadius: BorderRadius.circular(999)),
          child: Text(p.tag, style: T.of(13, FontWeight.w800, tagFg)),
        ),
      ]),
    );
    if (dashed) {
      return CustomPaint(
        painter: _DashedRRect(color: border, radius: 20),
        child: Container(decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)), child: content),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 2),
        boxShadow: [lip(lipC)],
      ),
      child: content,
    );
  }
}

class _MarkerChip extends StatelessWidget {
  final _Marker m;
  const _MarkerChip({required this.m});

  @override
  Widget build(BuildContext context) {
    final (bg, border, fg) = switch (m.st) {
      _St.locked => (C.sand, C.lip, C.muted),
      _St.done => (C.greenSoft, C.green, C.greenText),
      _ => (C.sunSoft, C.sun, C.sunText),
    };
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(color: bg, border: Border.all(color: border, width: 2), borderRadius: BorderRadius.circular(999)),
      child: Center(widthFactor: 1, child: Text(m.text, maxLines: 1, style: T.of(13, FontWeight.w800, fg))),
    );
  }
}

class _Pin extends StatelessWidget {
  final _Stop stop;
  final double size;
  final bool guest;
  final VoidCallback onTap;
  const _Pin({required this.stop, required this.size, required this.guest, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final s = stop;
    final done = s.st == _St.done, current = s.st == _St.current, locked = s.st == _St.locked;
    final free = s.st == _St.free || s.st == _St.open;
    Color bg = C.locked, fg = C.muted;
    List<BoxShadow> shadow = [lip(C.lockedLip, 6)];
    Border? border;
    if (done) {
      bg = C.green;
      fg = Colors.white;
      shadow = [lip(C.greenDark, 6)];
    }
    if (current) {
      bg = pal.p;
      fg = pal.on;
      shadow = [BoxShadow(color: pal.soft, spreadRadius: 10), lip(pal.e, 6)];
    }
    if (free) {
      bg = Colors.white;
      fg = const Color(0xFF7A4A00);
      border = Border.all(color: C.sun, width: 3);
      shadow = [lip(C.sunLip, 6)];
    }
    if (s.type == 'trophy' && done) {
      bg = C.sun;
      fg = C.sunInk;
      shadow = [lip(C.sunDark, 6)];
    }
    if (s.type == 'flag') {
      bg = locked ? C.body : C.ink;
      fg = Colors.white;
      shadow = [lip(const Color(0xFF1A1720), 6)];
    }
    final showType = current || free || (locked && guest);
    final MI icon;
    double iconSize = 30;
    if (s.special) {
      icon = s.type == 'trophy' ? MI.cup : MI.flag;
      iconSize = s.type == 'trophy' ? 34 : 32;
    } else if (done) {
      icon = MI.check;
    } else if (locked && !showType) {
      icon = MI.lock;
      iconSize = 24;
    } else {
      icon = unitIcon(s.type);
      iconSize = s.type == 'html' || s.type == 'quiz' ? 32 : 30;
    }
    final round = s.type == 'quiz' || s.special;
    final aria = s.title + (done ? '، تموم شده' : current ? '، الان نوبت اینه' : free ? '، رایگان' : '، قفل');
    return Semantics(
      button: true,
      label: aria,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            shape: round ? BoxShape.rectangle : BoxShape.circle,
            borderRadius: round ? BorderRadius.circular(24) : null,
            border: border,
            boxShadow: shadow,
          ),
          alignment: Alignment.center,
          child: MIcon(icon, size: iconSize, color: fg, strokeWidth: done ? 3.2 : (icon == MI.lock ? 2.4 : 2.2)),
        ),
      ),
    );
  }
}

/// Soft ring growing out of the current pin.
class _Pulse extends StatefulWidget {
  final Color color;
  const _Pulse({required this.color});

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: AnimatedBuilder(
      animation: _c,
      builder: (_, _) {
        final t = Curves.easeOut.transform(_c.value);
        return Transform.scale(
          scale: 1 + .45 * t,
          child: Opacity(
            opacity: .55 * (1 - t),
            child: DecoratedBox(decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle)),
          ),
        );
      },
    ),
  );
}

/// Green walked trail (with its darker lip) and the dotted way ahead.
class _TrailPainter extends CustomPainter {
  final List<Offset> walked;
  final List<Offset> ahead;
  _TrailPainter({required this.walked, required this.ahead});

  static Path _curve(List<Offset> pts) {
    final p = Path();
    for (var i = 0; i < pts.length; i++) {
      if (i == 0) {
        p.moveTo(pts[0].dx, pts[0].dy);
        continue;
      }
      final q = pts[i - 1], c = pts[i];
      final my = (q.dy + c.dy) / 2;
      p.cubicTo(q.dx, my, c.dx, my, c.dx, c.dy);
    }
    return p;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (ahead.length > 1) {
      final dots = Paint()
        ..color = C.lip
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      for (final PathMetric m in _curve(ahead).computeMetrics()) {
        for (double d = 0; d < m.length; d += 22) {
          canvas.drawPath(m.extractPath(d, math.min(d + 2, m.length)), dots);
        }
      }
    }
    if (walked.length > 1) {
      final path = _curve(walked);
      final stroke = Paint()
        ..strokeWidth = 16
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      canvas.save();
      canvas.translate(0, 4);
      canvas.drawPath(path, stroke..color = C.greenDark);
      canvas.restore();
      canvas.drawPath(path, stroke..color = C.green);
    }
  }

  @override
  bool shouldRepaint(covariant _TrailPainter old) => old.walked != walked || old.ahead != ahead;
}

class _DashedRRect extends CustomPainter {
  final Color color;
  final double radius;
  _DashedRRect({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final path = Path()..addRRect(RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)).deflate(1));
    for (final m in path.computeMetrics()) {
      for (double d = 0; d < m.length; d += 10) {
        canvas.drawPath(m.extractPath(d, math.min(d + 6, m.length)), p);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRect old) => old.color != color;
}

/// «این مسیر کامل شد!»: shown once on the roadmap after a path is finished.
class _Celebration extends StatelessWidget {
  final ProgressUpdate update;
  final Outline outline;
  final ValueChanged<OutlineUnit> onGo;
  final VoidCallback onClose;
  const _Celebration({required this.update, required this.outline, required this.onGo, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final u = update;
    OutlineUnit? next;
    var nextPathNum = 0;
    if (u.nextUnit != null) {
      for (final m in outline.modules) {
        for (var i = 0; i < m.paths.length; i++) {
          final hit = m.paths[i].units.where((x) => x.id == u.nextUnit!.id).firstOrNull;
          if (hit != null) {
            next = hit;
            nextPathNum = i + 1;
          }
        }
      }
    }
    final title = u.courseCompleted ? 'کل دوره رو تموم کردی!' : u.moduleCompleted ? 'جام فصل ${fa(u.moduleOrder)} مال تو شد!' : 'این مسیر کامل شد!';
    final body = u.courseCompleted
        ? '«${outline.title}» رو تا آخر رفتی. ایول!'
        : u.nextPathTitle != null
            ? '«${u.pathTitle}» رو تموم کردی و مسیر «${u.nextPathTitle}» باز شد.'
            : '«${u.pathTitle}» رو تموم کردی.';
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
        decoration: BoxDecoration(
          color: C.surface,
          border: Border.all(color: C.border, width: 2),
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [BoxShadow(color: C.lip, offset: Offset(0, 6)), BoxShadow(color: Color(0x292B2633), offset: Offset(0, 20), blurRadius: 40)],
        ),
        child: Stack(clipBehavior: Clip.none, children: [
          Positioned(top: -4, right: 8, child: Transform.rotate(angle: .52, child: Container(width: 12, height: 5, decoration: BoxDecoration(color: C.sun, borderRadius: BorderRadius.circular(3))))),
          Positioned(top: 12, left: 14, child: Container(width: 9, height: 9, decoration: BoxDecoration(color: pal.p, shape: BoxShape.circle))),
          Positioned(top: 48, right: 34, child: Transform.rotate(angle: .78, child: Container(width: 8, height: 8, decoration: BoxDecoration(color: C.green, borderRadius: BorderRadius.circular(2))))),
          Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(title, textAlign: TextAlign.center, style: T.of(26, FontWeight.w900)),
            const SizedBox(height: 6),
            Text(body, textAlign: TextAlign.center, style: T.of(15, FontWeight.w500, C.body, 1.8)),
            const SizedBox(height: 14),
            Wrap(alignment: WrapAlignment.center, spacing: 8, runSpacing: 8, children: [
              if (u.streakDays > 0)
                Container(
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: C.sunSoft, borderRadius: BorderRadius.circular(12)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const MIcon(MI.flame, size: 16, color: Color(0xFFFF8A00)),
                    const SizedBox(width: 6),
                    Text('${fa(u.streakDays)} روز پیاپی', style: T.of(13, FontWeight.w800, C.sunText)),
                  ]),
                ),
              if (u.moduleTotalUnits > 0)
                Container(
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: C.greenSoft, borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    widthFactor: 1,
                    child: Text('فصل ${fa(u.moduleOrder)} · ${fa(u.moduleCompletedUnits)} از ${fa(u.moduleTotalUnits)}', style: T.of(13, FontWeight.w800, C.greenText)),
                  ),
                ),
            ]),
            const SizedBox(height: 14),
            if (next != null)
              Btn(nextPathNum > 0 ? 'بریم سراغ مسیر ${fa(nextPathNum)}' : 'بریم سراغ بعدی', height: 54, fontSize: 17, onPressed: () => onGo(next!)),
            Btn('بستن و دیدن نقشه', kind: BtnKind.ghost, height: 40, fontSize: 14, onPressed: onClose),
          ]),
        ]),
      ),
    );
  }
}
