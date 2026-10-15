import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '/app/course/plan_sheet.dart';
import '/app/institute/institute_shell.dart';
import '/app/routes.dart';
import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/api/models.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

/// Where the bank sends the student back: «اشتراکت فعال شد!» with the
/// receipt, or «پرداخت انجام نشد» with what to do next.
class PaymentResultPage extends StatefulWidget {
  final String paymentId;
  const PaymentResultPage({super.key, required this.paymentId});

  @override
  State<PaymentResultPage> createState() => _PaymentResultPageState();
}

class _PaymentResultPageState extends State<PaymentResultPage> {
  final api = inject<MasirApi>();
  Payment? _p;
  InstituteDetail? _inst;
  ApiError? _error;
  int _tries = 0;
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    if (widget.paymentId.isEmpty) {
      setState(() => _error = const ApiError('پرداختی پیدا نشد.', status: 404));
      return;
    }
    final r = await api.payment(widget.paymentId);
    if (!mounted) return;
    r.fold((e) => setState(() => _error = e), (p) {
      setState(() {
        _p = p;
        _error = null;
      });
      if (_inst == null && p.instituteId.isNotEmpty) {
        InstituteCache.load(p.instituteId).then((r) => r.fold((_) {}, (d) {
          if (mounted) setState(() => _inst = d);
        }));
      }
      // The bank callback may land a moment after the redirect.
      if (p.status == 'pending' && _tries < 5) {
        _tries++;
        _poll = Timer(const Duration(seconds: 2), _load);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = _p;
    final brand = _inst?.brand ?? context.brand;
    return BrandScope(
      brand: brand,
      child: Scaffold(
        backgroundColor: C.paper,
        body: SafeArea(
          child: p == null
              ? (_error != null
                  ? Padding(padding: const EdgeInsets.all(16), child: InlineError(body: _error!.friendly, onRetry: _load))
                  : const Center(child: SizedBox(width: 32, height: 32, child: CircularProgressIndicator(strokeWidth: 3))))
              : p.paid
                  ? _Success(p: p)
                  : p.status == 'pending'
                      ? _Pending(onRetry: () {
                          _tries = 0;
                          _load();
                        })
                      : _Failed(p: p, institute: _inst),
        ),
      ),
    );
  }
}

class _Receipt extends StatelessWidget {
  final List<(String, String)> rows;
  const _Receipt({required this.rows});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    decoration: BoxDecoration(color: C.surface, border: Border.all(color: C.border, width: 2), borderRadius: BorderRadius.circular(20)),
    child: Column(children: [
      for (var i = 0; i < rows.length; i++)
        Container(
          constraints: const BoxConstraints(minHeight: 40),
          decoration: BoxDecoration(border: i == rows.length - 1 ? null : const Border(bottom: BorderSide(color: C.sand, width: 2))),
          child: Row(children: [
            Text(rows[i].$1, style: T.of(14, FontWeight.w500, C.muted)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                rows[i].$2,
                textAlign: TextAlign.left,
                textDirection: i == rows.length - 1 && rows[i].$1 == 'کد پیگیری' ? TextDirection.ltr : null,
                style: T.of(14, FontWeight.w800),
              ),
            ),
          ]),
        ),
    ]),
  );
}

/// «۱۶، ۲۰ و ۲۲ دی»
String _reminderDays(List<DateTime> days) {
  if (days.isEmpty) return '';
  final parts = days.map((d) => jDay(d)).toList();
  if (parts.length == 1) return parts.first;
  // Same month: write the month once at the end.
  final months = parts.map((s) => s.split(' ').skip(1).join(' ')).toSet();
  if (months.length == 1) {
    final nums = parts.map((s) => s.split(' ').first).toList();
    return '${nums.sublist(0, nums.length - 1).join('، ')} و ${nums.last} ${months.first}';
  }
  return '${parts.sublist(0, parts.length - 1).join('، ')} و ${parts.last}';
}

class _Success extends StatelessWidget {
  final Payment p;
  const _Success({required this.p});

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final unlocked = (p.totalUnits - p.previewUnits).clamp(0, p.totalUnits);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  width: 112,
                  height: 112,
                  child: Stack(clipBehavior: Clip.none, children: [
                    Positioned(top: -6, right: -12, child: Transform.rotate(angle: .35, child: Container(width: 12, height: 12, decoration: BoxDecoration(color: C.sun, borderRadius: BorderRadius.circular(3))))),
                    Positioned(bottom: 6, left: -16, child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: C.green, shape: BoxShape.circle))),
                    Positioned(top: 12, left: -10, child: Transform.rotate(angle: -.52, child: Container(width: 14, height: 6, decoration: BoxDecoration(color: pal.p, borderRadius: BorderRadius.circular(3))))),
                    Positioned(bottom: -8, right: 4, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: C.coral, shape: BoxShape.circle))),
                    Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(color: C.green, shape: BoxShape.circle, boxShadow: [lip(C.greenDark, 6)]),
                      alignment: Alignment.center,
                      child: const MIcon(MI.check, size: 54, color: Colors.white, strokeWidth: 3),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 14),
              Text('اشتراکت فعال شد!', textAlign: TextAlign.center, style: T.of(27, FontWeight.w900, C.ink, 1.4)),
              const SizedBox(height: 14),
              Text(
                [
                  if (p.accessEndsAt != null) '«${p.courseTitle}» تا ${jDay(p.accessEndsAt!, year: true)} کامل برات بازه.' else '«${p.courseTitle}» کامل برات بازه.',
                  if (unlocked > 0) '${fa(unlocked)} واحد تازه و همه‌ی جام‌ها منتظرتن.',
                ].join(' '),
                textAlign: TextAlign.center,
                style: T.of(15, FontWeight.w500, C.body, 1.9),
              ),
              const SizedBox(height: 20),
              _Receipt(rows: [
                ('اشتراک', planNames[p.plan] ?? p.plan),
                ('مبلغ', '${toman(p.amount)} تومان'),
                if (p.reminders.isNotEmpty) ('یادآوری تمدید', _reminderDays(p.reminders)),
                if (p.trackingCode.isNotEmpty) ('کد پیگیری', fa(p.trackingCode)),
              ]),
              const SizedBox(height: 20),
              Text('رسید این پرداخت توی «پروفایل › اشتراک‌ها» می‌مونه.', textAlign: TextAlign.center, style: T.of(13, FontWeight.w500, C.muted, 1.8)),
            ]),
          ),
        ),
        Btn('ادامه یادگیری', height: 56, fontSize: 17, onPressed: () {
          final u = p.returnUnitId;
          context.pushReplacement(u != null && u.isNotEmpty ? Routes.unit(u) : Routes.roadmap(p.courseId), extra: {'course_id': p.courseId});
        }),
        const SizedBox(height: 8),
        Btn('دیدن اشتراک‌هام', kind: BtnKind.ghost, height: 44, fontSize: 15, onPressed: () => context.pushReplacement(Routes.subscriptions)),
      ]),
    );
  }
}

class _Failed extends StatelessWidget {
  final Payment p;
  final InstituteDetail? institute;
  const _Failed({required this.p, required this.institute});

  @override
  Widget build(BuildContext context) {
    final links = institute?.links ?? const [];
    final contact = links.where((l) => l.kind == 'telegram').firstOrNull ?? links.firstOrNull;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const SizedBox(height: 24),
              Center(
                child: Container(
                  width: 112,
                  height: 112,
                  decoration: const BoxDecoration(color: Color(0xFFFFE3E4), shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: const MIcon(MI.alert, size: 50, color: C.coralDark, strokeWidth: 2.6),
                ),
              ),
              const SizedBox(height: 14),
              Text('پرداخت انجام نشد', textAlign: TextAlign.center, style: T.of(27, FontWeight.w900, C.ink, 1.4)),
              const SizedBox(height: 14),
              Text('اشتراک فعال نشد و پیشرفتت دست‌نخورده‌ست. می‌تونی دوباره امتحان کنی.',
                  textAlign: TextAlign.center, style: T.of(15, FontWeight.w500, C.body, 1.9)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(color: C.sunSoft, borderRadius: BorderRadius.circular(18)),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Padding(padding: EdgeInsets.only(top: 2), child: MIcon(MI.undo, size: 22, color: Color(0xFF8A5A00))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text.rich(TextSpan(style: T.of(14, FontWeight.w500, const Color(0xFF5A3B00), 1.9), children: const [
                      TextSpan(text: 'اگه پولی از حسابت کم شده،', style: TextStyle(fontWeight: FontWeight.w800)),
                      TextSpan(text: ' تا ۷۲ ساعت خودکار برمی‌گرده. لازم نیست کاری بکنی.'),
                    ])),
                  ),
                ]),
              ),
              const SizedBox(height: 20),
              _Receipt(rows: [
                ('اشتراک', '${planNames[p.plan] ?? p.plan} · ${toman(p.amount)} تومان'),
                if (p.bankMessage.isNotEmpty) ('پیام بانک', p.bankMessage),
                if (p.trackingCode.isNotEmpty) ('کد پیگیری', fa(p.trackingCode)),
              ]),
            ]),
          ),
        ),
        Btn('دوباره امتحان کن', height: 56, fontSize: 17, onPressed: () async {
          await showPlanSheet(context, courseId: p.courseId, returnUnitId: p.returnUnitId, brand: context.brand);
        }),
        if (contact != null) ...[
          const SizedBox(height: 8),
          Btn('با پشتیبانی حرف بزن', kind: BtnKind.ghost, height: 44, fontSize: 15,
              onPressed: () => launchUrl(Uri.parse(contact.url), mode: LaunchMode.externalApplication)),
        ] else ...[
          const SizedBox(height: 8),
          Btn('برگشت به دوره', kind: BtnKind.ghost, height: 44, fontSize: 15, onPressed: () => context.pushReplacement(Routes.course(p.courseId))),
        ],
      ]),
    );
  }
}

class _Pending extends StatelessWidget {
  final VoidCallback onRetry;
  const _Pending({required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(width: 40, height: 40, child: CircularProgressIndicator(strokeWidth: 3)),
        const SizedBox(height: 20),
        Text('داریم نتیجه رو از بانک می‌گیریم…', textAlign: TextAlign.center, style: T.of(18, FontWeight.w800)),
        const SizedBox(height: 8),
        Text('اگه طول کشید، چند لحظه دیگه دوباره نگاه کن.', textAlign: TextAlign.center, style: T.of(14, FontWeight.w500, C.muted, 1.8)),
        const SizedBox(height: 16),
        Btn('دوباره نگاه کن', kind: BtnKind.secondary, expand: false, height: 48, fontSize: 15, onPressed: onRetry),
      ]),
    ),
  );
}
