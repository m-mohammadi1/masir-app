import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/app/course/plan_sheet.dart';
import '/app/routes.dart';
import '/app/state/nav.dart';
import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/api/models.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

/// «صندوق پیام»: renewal reminders, announcements and Masir messages,
/// grouped by today / this week / older.
class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  final api = inject<MasirApi>();
  List<InboxItem>? _items;
  Map<String, Brand> _brands = {};
  ApiError? _error;
  bool _showOlder = false;

  @override
  void initState() {
    super.initState();
    _load();
    api.wallet().then(
      (r) => r.fold((_) {}, (w) {
        if (mounted) {
          setState(
            () => _brands = {
              for (final c in w) c.institute.id: c.institute.brand,
            },
          );
        }
      }),
    );
  }

  Future<void> _load() async {
    final res = await api.inbox();
    if (!mounted) return;
    res.fold(
      (e) => setState(() => _error = e),
      (l) => setState(() => _items = l),
    );
  }

  Future<void> _readAll() async {
    await api.markAllRead();
    _load();
  }

  void _open(InboxItem it) {
    if (!it.read) api.markRead(it.id);
    final p = it.payload;
    final inst = '${p['institute_id'] ?? ''}';
    switch (it.type) {
      case 'subscription.reminder':
        showPlanSheet(
          context,
          courseId: '${p['course_id']}',
          renew: true,
          brand: _brands[inst],
        );
      case 'announcement.published':
        context.push(Routes.announcement(inst, '${p['announcement_id']}'));
      case 'course.subscribed':
      case 'course.published':
        context.push(Routes.course('${p['course_id']}'));
      case 'student.joined_institute':
        context.push(Routes.threshold(inst));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    final unread = items?.where((i) => !i.read).length ?? 0;
    final now = DateTime.now();
    final today = <InboxItem>[], week = <InboxItem>[], older = <InboxItem>[];
    for (final it in items ?? <InboxItem>[]) {
      final d = it.createdAt ?? now;
      if (now.difference(d).inHours < 24 && d.day == now.day) {
        today.add(it);
      } else if (now.difference(d).inDays < 7) {
        week.add(it);
      } else {
        older.add(it);
      }
    }
    return Scaffold(
      backgroundColor: C.paper,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: C.border, width: 2)),
            ),
            padding: EdgeInsets.fromLTRB(
              16,
              MediaQuery.paddingOf(context).top + 12,
              16,
              12,
            ),
            child: Row(
              children: [
                BackSquare(
                  onTap: () => back(context, fallback: Routes.vitrine),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('صندوق پیام', style: T.of(20, FontWeight.w800)),
                      Text(
                        unread > 0
                            ? '${fa(unread)} پیام نخونده'
                            : 'همه رو خوندی',
                        style: T.of(13, FontWeight.w500, C.muted),
                      ),
                    ],
                  ),
                ),
                if (unread > 0)
                  TextButton(
                    onPressed: _readAll,
                    child: Text(
                      'همه رو خوندم',
                      style: T.of(14, FontWeight.w800, C.violet),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: _error != null
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: InlineError(body: _error!.friendly, onRetry: _load),
                  )
                : items == null
                ? ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      for (var i = 0; i < 5; i++) ...[
                        const Bone(height: 96, radius: 20),
                        const SizedBox(height: 10),
                      ],
                    ],
                  )
                : items.isEmpty
                ? const Center(
                    child: EmptyState(
                      icon: MI.bell,
                      title: 'صندوقت خالیه',
                      body: 'یادآوری‌ها و اطلاعیه‌های مؤسسه‌هات اینجا میان.',
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _load,
                    child: MasirStagger(
                      id: 'inbox',
                      layout: (c) => ListView(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                        children: c,
                      ),
                      children: [
                        if (today.isNotEmpty) ...[
                          _group('امروز'),
                          for (final it in today) _row(it),
                        ],
                        if (week.isNotEmpty) ...[
                          _group('این هفته'),
                          for (final it in week) _row(it),
                        ],
                        if (older.isNotEmpty && _showOlder) ...[
                          _group('قدیمی‌تر'),
                          for (final it in older) _row(it),
                        ],
                        if (older.isNotEmpty && !_showOlder)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Btn.secondary(
                              'پیام‌های قدیمی‌تر',
                              height: 52,
                              fontSize: 15,
                              onPressed: () =>
                                  setState(() => _showOlder = true),
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

  Widget _group(String t) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 8, 4, 10),
    child: Text(t, style: T.of(13, FontWeight.w800, C.muted)),
  );

  Widget _row(InboxItem it) {
    final p = it.payload;
    final inst = '${p['institute_id'] ?? ''}';
    final instName = '${p['institute_name'] ?? ''}';
    final brand =
        _brands[inst] ??
        (instName.isNotEmpty
            ? Brand(palette: masirPalette, name: instName)
            : null);
    late String title, body, source;
    Widget icon;
    var reminder = false;
    switch (it.type) {
      case 'subscription.reminder':
        reminder = true;
        title = '${p['title'] ?? 'یادآوری تمدید'}';
        body = '${p['body'] ?? ''}';
        source = [
          'یادآوری تمدید',
          if (instName.isNotEmpty) instName,
        ].join(' · ');
        icon = _tile(
          C.sunSoft,
          const MIcon(MI.clock, size: 22, color: Color(0xFF8A5A00)),
        );
      case 'announcement.published':
        title = '${p['title'] ?? ''}';
        body = 'اطلاعیه‌ی تازه از $instName';
        source = instName;
        icon = brand != null
            ? InstituteLogo(brand: brand, size: 44)
            : _tile(C.violetSoft, const MIcon(MI.megaphone, color: C.violet));
      case 'course.subscribed':
        title = 'شروع کردی: «${p['course_title'] ?? ''}»';
        body = 'واحدهای رایگانش بازن؛ از نقشه‌ی مسیر شروع کن.';
        source = instName.isEmpty ? 'مسیر' : instName;
        icon = brand != null
            ? InstituteLogo(brand: brand, size: 44)
            : _tile(C.violet, const MIcon(MI.book, color: Colors.white));
      case 'course.published':
        title = 'دوره‌ی تازه: «${p['course_title'] ?? ''}»';
        body = 'یه دوره‌ی تازه به مؤسسه‌ات اضافه شد.';
        source = instName.isEmpty ? 'مسیر' : instName;
        icon = brand != null
            ? InstituteLogo(brand: brand, size: 44)
            : _tile(C.violet, const MIcon(MI.book, color: Colors.white));
      default:
        title = instName.isNotEmpty ? 'عضو $instName شدی' : 'به مسیر خوش اومدی';
        body = 'از ویترین شروع کن؛ مؤسسه‌ت منتظرته.';
        source = 'مسیر';
        icon = _tile(C.violet, const MasirSmallMark(size: 22));
    }
    final unread = !it.read;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => _open(it),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: unread ? C.surface : C.paper,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 2,
              color: unread
                  ? (reminder ? const Color(0xFFFFD98A) : C.violetBorder)
                  : C.border,
            ),
            boxShadow: unread
                ? [lip(reminder ? const Color(0xFFFFF0C2) : C.violetSoft)]
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: T.of(
                              15,
                              unread ? FontWeight.w800 : FontWeight.w600,
                            ),
                          ),
                        ),
                        if (unread)
                          Semantics(
                            label: 'نخونده',
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: C.violet,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (body.isNotEmpty)
                      Text(
                        body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: T.of(
                          14,
                          FontWeight.w500,
                          unread ? C.body : C.muted,
                          1.8,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      '$source · ${ago(it.createdAt)}',
                      style: T.of(12, FontWeight.w500, C.muted),
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

  Widget _tile(Color bg, Widget child) => Container(
    width: 44,
    height: 44,
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(14),
    ),
    alignment: Alignment.center,
    child: child,
  );
}
