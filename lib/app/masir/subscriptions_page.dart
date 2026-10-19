import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/app/course/plan_sheet.dart';
import '/app/routes.dart';
import '/app/state/nav.dart';
import '/app/state/session.dart';
import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/api/models.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

/// «اشتراک‌ها»: each course's subscription, reminders, payments.
class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  final api = inject<MasirApi>();
  List<Subscription>? _subs;
  List<Payment>? _payments;
  ReminderPrefs? _prefs;
  ApiError? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await Future.wait([
      api.subscriptions().then(
        (r) => r.fold(
          (e) => setState(() => _error = e),
          (s) => setState(() => _subs = s),
        ),
      ),
      api.payments().then(
        (r) => r.fold((_) {}, (p) => setState(() => _payments = p)),
      ),
      api.reminderPrefs().then(
        (r) => r.fold((_) {}, (p) => setState(() => _prefs = p)),
      ),
      // The SMS row shows the number; the profile may not be cached yet
      // when this page is opened directly.
      if (Session.student.value == null)
        api.me().then(
          (r) => r.fold(
            (_) {},
            (st) => setState(() => Session.student.value = st),
          ),
        ),
    ]);
  }

  Future<void> _setPrefs(ReminderPrefs p) async {
    setState(() => _prefs = p);
    final res = await api.setReminderPrefs(p);
    if (!mounted) return;
    res.fold(
      (e) => Toast.show(
        context,
        title: 'ذخیره نشد',
        body: e.friendly,
        tone: ToastTone.error,
      ),
      (_) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final paid =
        (_subs ?? [])
            .where((s) => s.course.access.accessEndsAt != null)
            .toList()
          ..sort((a, b) => _rank(a).compareTo(_rank(b)));
    final expiring = paid
        .where((s) => s.course.access.state == AccessState.expiring)
        .firstOrNull;
    final phone = Session.student.value?.phone ?? '';
    return Scaffold(
      backgroundColor: C.paper,
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            MediaQuery.paddingOf(context).top + 16,
            16,
            32,
          ),
          children: [
            Row(
              children: [
                BackSquare(
                  onTap: () => back(context, fallback: Routes.profile),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اشتراک‌ها',
                        style: T.of(26, FontWeight.w900, C.ink, 1.35),
                      ),
                      Text(
                        'هر دوره اشتراک جدای خودش رو داره',
                        style: T.of(13, FontWeight.w500, C.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (expiring != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: C.sunSoft,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const MIcon(MI.clock, size: 22, color: Color(0xFF8A5A00)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'اشتراک «${expiring.course.title}» ${fa(expiring.course.access.daysLeft ?? 0)} روز دیگه تموم می‌شه.',
                        style: T.of(
                          14,
                          FontWeight.w500,
                          const Color(0xFF5A3B00),
                          1.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
            ],
            if (_error != null)
              InlineError(body: _error!.friendly, onRetry: _load),
            if (_subs == null && _error == null) ...[
              for (var i = 0; i < 2; i++) ...[
                const Bone(height: 220, radius: 22),
                const SizedBox(height: 18),
              ],
            ],
            if (_subs != null && paid.isEmpty)
              const EmptyState(
                icon: MI.card,
                title: 'هنوز اشتراکی نگرفتی',
                body:
                    'واحدهای رایگان هر دوره بازن؛ هر وقت خواستی برای بقیه‌ش اشتراک بگیر.',
              ),
            for (final s in paid) ...[
              _SubCard(sub: s),
              const SizedBox(height: 18),
            ],
            if (_prefs != null) ...[
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 2),
                      child: Text(
                        'یادآوری تمدید از راه',
                        style: T.of(16, FontWeight.w900),
                      ),
                    ),
                    _Toggle(
                      title: 'اعلان اپ',
                      value: _prefs!.push,
                      onChanged: (v) =>
                          _setPrefs(ReminderPrefs(push: v, sms: _prefs!.sms)),
                    ),
                    const SandLine(),
                    _Toggle(
                      title: 'پیامک',
                      subtitle: phone.length >= 11
                          ? 'به \u2066${fa('${phone.substring(0, 4)}•••${phone.substring(7)}')}\u2069'
                          : null,
                      value: _prefs!.sms,
                      onChanged: (v) =>
                          _setPrefs(ReminderPrefs(push: _prefs!.push, sms: v)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
            ],
            if ((_payments ?? []).isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text('پرداخت‌ها', style: T.of(18, FontWeight.w900)),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: C.surface,
                  border: Border.all(color: C.border, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < _payments!.length; i++) ...[
                      if (i > 0) const SandLine(),
                      _PaymentRow(p: _payments![i]),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 18),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: C.violetSoft,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MIcon(MI.info, size: 20, color: Color(0xFF4A2580)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'تمدید خودکار نداریم و هیچ‌وقت چیزی از حسابت برداشت نمی‌شه؛ اشتراک سر موعد خودش تموم می‌شه. اگه زودتر تمدید کنی، مدت تازه از آخر اشتراک فعلی حساب می‌شه.',
                      style: T.of(
                        14,
                        FontWeight.w500,
                        const Color(0xFF4A2580),
                        1.8,
                      ),
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

  int _rank(Subscription s) => switch (s.course.access.state) {
    AccessState.expiring => 0,
    AccessState.active => 1,
    AccessState.expired => 2,
    _ => 3,
  };
}

class _SubCard extends StatelessWidget {
  final Subscription sub;
  const _SubCard({required this.sub});

  @override
  Widget build(BuildContext context) {
    final c = sub.course;
    final a = c.access;
    final brand = sub.institute?.brand ?? BrandScope.of(context);
    final pal = brand.palette;
    final ends = a.accessEndsAt!;
    final expiring = a.state == AccessState.expiring;
    final expired = a.state == AccessState.expired;
    final months = int.tryParse((a.plan ?? 'm1').substring(1)) ?? 1;
    final remaining = ((a.daysLeft ?? 0) / (months * 30)).clamp(0.0, 1.0);
    final monthly =
        c.plans.where((p) => p.period == 'm1').firstOrNull ??
        c.plans.firstOrNull;
    final (badge, badgeBg, badgeFg) = expired
        ? ('تموم شده', const Color(0xFFFFE3E4), C.coralText)
        : expiring
        ? ('${fa(a.daysLeft ?? 0)} روز مونده', C.sunSoft, C.sunText)
        : ('فعال', C.greenSoft, C.greenText);
    final now = DateTime.now();
    final sent = sub.reminders.where((d) => !d.isAfter(now)).toList();
    final next = sub.reminders.where((d) => d.isAfter(now)).toList();

    void renew() =>
        showPlanSheet(context, courseId: c.id, renew: true, brand: brand);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: expiring ? const Color(0xFFFFD98A) : C.border,
          width: 2,
        ),
        boxShadow: [lip(expiring ? const Color(0xFFF2C460) : C.lip)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox.square(
                        dimension: 56,
                        child: CoverImage(url: c.coverUrl, brand: brand),
                      ),
                    ),
                    Positioned(
                      left: -6,
                      bottom: -6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InstituteLogo(
                          brand: brand,
                          size: 24,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
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
                      style: T.of(17, FontWeight.w800, C.ink, 1.5),
                    ),
                    Text(
                      '${brand.name} • ${planNames[a.plan] ?? ''}',
                      style: T.of(13, FontWeight.w500, C.muted),
                    ),
                  ],
                ),
              ),
              Container(
                height: 28,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                alignment: Alignment.center,
                child: Text(badge, style: T.of(12, FontWeight.w800, badgeFg)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (expired)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: C.sand,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  ScoreRing(
                    percent: sub.progressPercent,
                    size: 40,
                    stroke: 5,
                    color: C.green,
                    track: C.lip,
                    fill: C.sand,
                    label: Text(
                      pct(sub.progressPercent),
                      style: T.of(10, FontWeight.w800, C.greenText),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        style: T.of(13, FontWeight.w500, C.body, 1.8),
                        children: [
                          TextSpan(text: '${jDay(ends)} تموم شد. '),
                          TextSpan(
                            text: sub.trophies > 0
                                ? 'پیشرفتت و ${fa(sub.trophies)} جام فصل سر جاشه'
                                : 'پیشرفتت سر جاشه',
                            style: T.of(13, FontWeight.w800, C.body),
                          ),
                          const TextSpan(
                            text: '؛ با تمدید از همون‌جا ادامه می‌دی.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          else ...[
            Track(
              value: expiring ? 1 - remaining : remaining,
              color: expiring ? C.sun : C.green,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    expiring
                        ? 'تا ${jDay(ends, year: true)}'
                        : '${fa(a.daysLeft ?? 0)} روز مونده',
                    style: T.of(13, FontWeight.w700),
                  ),
                ),
                Text(
                  expiring && monthly != null
                      ? 'تمدید: ${perMonth(monthly.perMonth)} تومان'
                      : 'تا ${jDay(ends, year: true)}',
                  style: T.of(13, FontWeight.w500, C.muted),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const SandLine(),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: C.sunSoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: const MIcon(
                    MI.bell,
                    size: 16,
                    color: Color(0xFF8A5A00),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    expiring
                        ? '${sent.isNotEmpty ? 'یادآوری ${sent.length == 1 ? '۷' : '۷ و ۳'} روز مونده رفت؛ ' : ''}${next.isNotEmpty ? 'آخری ${jDay(next.last)}. ' : ''}بعد از ${jDay(ends)} واحدهای اشتراکی قفل می‌شن.'
                        : 'یادآوری‌ها: ${_days(sub.reminders)}',
                    style: T.of(13, FontWeight.w500, C.body, 1.7),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              if (!expired && !expiring) ...[
                Expanded(
                  child: Btn.secondary(
                    'تمدید زودتر',
                    height: 52,
                    fontSize: 15,
                    onPressed: renew,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Btn(
                    'ادامه یادگیری',
                    palette: pal,
                    height: 52,
                    fontSize: 15,
                    onPressed: () {
                      Session.space.value = brand;
                      context.push(Routes.roadmap(c.id));
                    },
                  ),
                ),
              ] else
                Expanded(
                  child: Btn(
                    'تمدید',
                    palette: pal,
                    height: 52,
                    fontSize: 15,
                    onPressed: renew,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// «۷، ۱۱ و ۱۳ دی».
  String _days(List<DateTime> days) {
    if (days.isEmpty) return '—';
    final parts = days.map((d) => jDay(d).split(' ')).toList();
    final month = parts.last.last;
    final nums = parts.map((p) => p.first).toList();
    final head = nums.length > 1
        ? '${nums.sublist(0, nums.length - 1).join('، ')} و ${nums.last}'
        : nums.first;
    return '$head $month';
  }
}

class _PaymentRow extends StatelessWidget {
  final Payment p;
  const _PaymentRow({required this.p});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${p.courseTitle} • ${planNames[p.plan] ?? ''}',
                style: T.of(14, FontWeight.w800),
              ),
              Text(
                '${p.createdAt == null ? '' : jDay(p.createdAt!, year: true)} • ${toman(p.amount)} تومان',
                style: T.of(12, FontWeight.w500, C.muted),
              ),
              Text(
                p.paid ? 'موفق' : 'ناموفق • برگشت خورد',
                style: T.of(
                  12,
                  FontWeight.w800,
                  p.paid ? C.greenText : C.coralText,
                ),
              ),
            ],
          ),
        ),
        if (p.paid)
          TextButton(
            onPressed: () => _receipt(context),
            child: Text('رسید', style: T.of(13, FontWeight.w800, C.violet)),
          ),
      ],
    ),
  );

  void _receipt(BuildContext context) => showMasirSheet(
    context,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('رسید پرداخت', style: T.of(19, FontWeight.w800)),
          const SizedBox(height: 14),
          ReceiptRow('دوره', p.courseTitle),
          ReceiptRow('اشتراک', planNames[p.plan] ?? ''),
          ReceiptRow('مبلغ', '${toman(p.amount)} تومان'),
          if (p.createdAt != null)
            ReceiptRow('تاریخ', jDay(p.createdAt!, year: true)),
          ReceiptRow('کد پیگیری', fa(p.trackingCode), ltr: true),
        ],
      ),
    ),
  );
}

class ReceiptRow extends StatelessWidget {
  final String label;
  final String value;
  final bool ltr;
  final Color? valueColor;
  const ReceiptRow(
    this.label,
    this.value, {
    super.key,
    this.ltr = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(child: Text(label, style: T.of(14, FontWeight.w500, C.muted))),
        Text(
          value,
          textDirection: ltr ? TextDirection.ltr : null,
          style: T.of(14, FontWeight.w800, valueColor ?? C.ink),
        ),
      ],
    ),
  );
}

class _Toggle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _Toggle({
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(minHeight: 52),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: T.of(15, FontWeight.w700)),
              if (subtitle != null)
                Text(
                  subtitle!,
                  textDirection: TextDirection.ltr,
                  style: T.of(12, FontWeight.w500, C.muted),
                ),
            ],
          ),
        ),
        MSwitch(value: value, onChanged: onChanged, label: title),
      ],
    ),
  );
}
