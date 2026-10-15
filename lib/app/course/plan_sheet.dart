import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '/app/state/nav.dart';
import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/api/models.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

/// Opens «اشتراک دوره» / «تمدید اشتراک» for [courseId].
Future<void> showPlanSheet(
  BuildContext context, {
  required String courseId,
  bool renew = false,
  Brand? brand,
  String? returnUnitId,
}) => Navigator.of(context, rootNavigator: true).push(
  MaterialPageRoute(
    fullscreenDialog: true,
    builder: (_) => BrandScope(
      brand: brand ?? BrandScope.of(context),
      child: PlanPage(
        courseId: courseId,
        renew: renew,
        returnUnitId: returnUnitId,
      ),
    ),
  ),
);

/// Where the bank page sends the student back: the web app's payment route,
/// or the app's deep link on phones.
String paymentReturnUrl() =>
    kIsWeb ? '${Uri.base.origin}/#/payment' : 'masir://payment';

class PlanPage extends StatefulWidget {
  final String courseId;
  final bool renew;
  final String? returnUnitId;
  const PlanPage({
    super.key,
    required this.courseId,
    this.renew = false,
    this.returnUnitId,
  });

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  final api = inject<MasirApi>();
  CourseDetail? _course;
  ApiError? _error;
  String? _plan;
  final Map<String, Quote> _quotes = {};
  bool _codeOpen = false;
  final _code = TextEditingController();
  String _appliedCode = '';
  String? _codeError;
  bool _paying = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final res = await api.course(widget.courseId);
    if (!mounted) return;
    res.fold((e) => setState(() => _error = e), (c) {
      final plans = c.card.plans;
      setState(() {
        _course = c;
        _plan = plans.any((p) => p.period == 'm3')
            ? 'm3'
            : plans.firstOrNull?.period;
      });
      for (final p in plans) {
        _quote(p.period);
      }
    });
  }

  Future<void> _quote(String plan, {String? code}) async {
    final res = await api.quote(
      widget.courseId,
      plan,
      code: code ?? _appliedCode,
    );
    if (!mounted) return;
    res.fold((e) {
      if (code != null) {
        setState(
          () => _codeError = e.fields['discount_code'] == 'unusable'
              ? 'این کد دیگه کار نمی‌کنه.'
              : 'این کد پیدا نشد.',
        );
      }
    }, (q) => setState(() => _quotes[plan] = q));
  }

  Future<void> _applyCode() async {
    final code = _code.text.trim();
    if (code.isEmpty || _plan == null) return;
    setState(() => _codeError = null);
    final res = await api.quote(widget.courseId, _plan!, code: code);
    if (!mounted) return;
    res.fold(
      (e) => setState(
        () => _codeError = e.fields['discount_code'] == 'unusable'
            ? 'این کد دیگه کار نمی‌کنه.'
            : 'این کد پیدا نشد.',
      ),
      (q) {
        setState(() {
          _appliedCode = code;
          _quotes[_plan!] = q;
        });
        for (final p in _course!.card.plans) {
          if (p.period != _plan) _quote(p.period);
        }
      },
    );
  }

  Future<void> _pay() async {
    setState(() => _paying = true);
    final res = await api.checkout(
      widget.courseId,
      _plan!,
      code: _appliedCode,
      returnUnitId: widget.returnUnitId,
      returnUrl: paymentReturnUrl(),
    );
    if (!mounted) return;
    setState(() => _paying = false);
    await res.fold(
      (e) async => Toast.show(
        context,
        title: 'به درگاه نرسیدیم',
        body: e.friendly,
        tone: ToastTone.error,
      ),
      (p) async {
        final uri = Uri.parse(p.gatewayUrl);
        if (kIsWeb) {
          await launchUrl(uri, webOnlyWindowName: '_self');
        } else {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          if (mounted) context.pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final c = _course;
    return Scaffold(
      backgroundColor: C.paper,
      body: c == null
          ? SafeArea(
              child: _error != null
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: InlineError(
                        body: _error!.friendly,
                        onRetry: () {
                          setState(() => _error = null);
                          _load();
                        },
                      ),
                    )
                  : const _PlanSkeleton(),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      MediaQuery.paddingOf(context).top + 12,
                      16,
                      24,
                    ),
                    children: [
                      Row(
                        children: [
                          BackSquare(onTap: () => back(context)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.renew ? 'تمدید اشتراک' : 'اشتراک دوره',
                                  style: T.of(22, FontWeight.w900, C.ink, 1.4),
                                ),
                                Text(
                                  '${c.card.title} · ${c.instituteBrand.name}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: T.of(13, FontWeight.w500, C.muted),
                                ),
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: SizedBox.square(
                              dimension: 56,
                              child: CoverImage(
                                url: c.card.coverUrl,
                                brand: c.instituteBrand,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (widget.renew ||
                          c.card.access.state == AccessState.expired) ...[
                        const SizedBox(height: 18),
                        _KeptProgress(card: c.card),
                      ],
                      const SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          'مدت اشتراک',
                          style: T.of(17, FontWeight.w800),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Semantics(
                        label: 'مدت اشتراک',
                        child: Column(
                          children: [
                            for (final p in c.card.plans) ...[
                              _PlanOption(
                                plan: p,
                                quote: _quotes[p.period],
                                selected: p.period == _plan,
                                popular:
                                    p.period == 'm3' && c.card.plans.length > 2,
                                onTap: () => setState(() => _plan = p.period),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      _Perk(
                        'همه‌ی ${fa(c.card.unitCount)} واحد، آزمون‌ها و جام‌های فصل',
                      ),
                      const SizedBox(height: 8),
                      const _Perk('پیشرفتت حتی بعد از پایان اشتراک می‌مونه'),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: C.surface,
                          border: Border.all(color: C.border, width: 2),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: C.sunSoft,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: const MIcon(
                                MI.bell,
                                size: 20,
                                color: Color(0xFF8A5A00),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'یادآوری تمدید',
                                    style: T.of(15, FontWeight.w800),
                                  ),
                                  Text(
                                    '۷، ۳ و ۱ روز مونده به ${_until ?? '…'} با اعلان و پیامک خبرت می‌کنیم. هیچ برداشت خودکاری از حسابت انجام نمی‌شه.',
                                    style: T.of(
                                      13,
                                      FontWeight.w500,
                                      C.body,
                                      1.8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      if (_codeOpen)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Field(
                                label: '',
                                controller: _code,
                                hint: 'کد تخفیف',
                                height: 48,
                                direction: TextDirection.ltr,
                                error: _codeError,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Btn.secondary(
                              'اعمال',
                              expand: false,
                              height: 52,
                              fontSize: 14,
                              onPressed: _applyCode,
                            ),
                          ],
                        )
                      else
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: TextButton(
                            onPressed: () => setState(() => _codeOpen = true),
                            child: Text(
                              'کد تخفیف داری؟',
                              style: T.of(
                                15,
                                FontWeight.w800,
                                pal == masirPalette ? C.violet : pal.ink,
                              ),
                            ),
                          ),
                        ),
                      if (_appliedCode.isNotEmpty && _codeError == null) ...[
                        const SizedBox(height: 6),
                        Text(
                          'کد «$_appliedCode» اعمال شد.',
                          style: T.of(13, FontWeight.w700, C.greenText),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          'قیمت رو ${c.instituteBrand.name} تعیین کرده. اشتراک ${_until == null ? '' : 'تا $_until'} خودش تموم می‌شه و لازم نیست لغوش کنی؛ بعدش هم پیشرفتت پاک نمی‌شه.',
                          style: T.of(13, FontWeight.w500, C.muted, 1.9),
                        ),
                      ),
                    ],
                  ),
                ),
                _PayBar(
                  plan: c.card.plans
                      .where((p) => p.period == _plan)
                      .firstOrNull,
                  quote: _quotes[_plan],
                  until: _until,
                  busy: _paying,
                  onPay: _plan == null ? null : _pay,
                ),
              ],
            ),
    );
  }

  String? get _until {
    final q = _quotes[_plan];
    return q == null ? null : jDay(q.periodEndsAt, year: true);
  }
}

class _KeptProgress extends StatelessWidget {
  final CourseCard card;
  const _KeptProgress({required this.card});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: C.greenSoft,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        ScoreRing(
          percent: card.progressPercent,
          size: 44,
          stroke: 6,
          color: C.green,
          track: const Color(0xFFC9EBD5),
          fill: C.greenSoft,
          label: Text(
            pct(card.progressPercent),
            style: T.of(11, FontWeight.w800, C.greenText),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: T.of(14, FontWeight.w500, const Color(0xFF1E5E38), 1.8),
              children: [
                TextSpan(
                  text: 'پیشرفتت سر جاشه. ',
                  style: T.of(14, FontWeight.w800, const Color(0xFF1E5E38)),
                ),
                if (card.currentUnit != null)
                  TextSpan(
                    text:
                        'بعد از تمدید، از «${card.currentUnit!.title}» ادامه می‌دی. ',
                  ),
                const TextSpan(
                  text: 'اگه زودتر تمدید کنی، روزهای باقی‌مونده نمی‌سوزه.',
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _PlanOption extends StatelessWidget {
  final CoursePlan plan;
  final Quote? quote;
  final bool selected;
  final bool popular;
  final VoidCallback onTap;
  const _PlanOption({
    required this.plan,
    this.quote,
    required this.selected,
    required this.popular,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final total = quote?.amount ?? plan.price;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          constraints: const BoxConstraints(minHeight: 76),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: C.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: selected ? pal.p : C.border, width: 2),
            boxShadow: [
              selected
                  ? BoxShadow(color: pal.soft, spreadRadius: 3)
                  : lip(C.lip, 3),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? pal.p : const Color(0xFFCFC4AE),
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: selected
                    ? Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: pal.p,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          planNames[plan.period] ?? plan.period,
                          style: T.of(16, FontWeight.w800),
                        ),
                        if (popular) ...[
                          const SizedBox(width: 8),
                          Container(
                            height: 22,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: pal.p,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'محبوب',
                              style: T.of(11, FontWeight.w800, pal.on, 1),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '${toman(total)} تومان · ${planEvery[plan.period]}',
                      style: T.of(13, FontWeight.w500, C.muted),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    perMonth(plan.perMonth),
                    style: T.of(15, FontWeight.w800),
                  ),
                  if (plan.savePercent > 0) ...[
                    const SizedBox(height: 4),
                    Tag.success('${fa(plan.savePercent)}٪ کمتر'),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Perk extends StatelessWidget {
  final String text;
  const _Perk(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Row(
      children: [
        const MIcon(MI.check, size: 20, color: C.green, strokeWidth: 3),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: T.of(15, FontWeight.w500, C.ink, 1.7)),
        ),
      ],
    ),
  );
}

class _PayBar extends StatelessWidget {
  final CoursePlan? plan;
  final Quote? quote;
  final String? until;
  final bool busy;
  final VoidCallback? onPay;
  const _PayBar({
    this.plan,
    this.quote,
    this.until,
    required this.busy,
    this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    final total = quote?.amount ?? plan?.price ?? 0;
    final save = (quote?.discountPercent ?? 0) > 0
        ? '${fa(quote!.discountPercent)}٪ تخفیف'
        : (plan?.savePercent ?? 0) > 0
        ? '${fa(plan!.savePercent)}٪ کمتر'
        : '';
    return Container(
      decoration: const BoxDecoration(
        color: C.surface,
        border: Border(top: BorderSide(color: C.border, width: 2)),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        14,
        16,
        14 + MediaQuery.paddingOf(context).bottom.clamp(6, 30),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اشتراک ${planNames[plan?.period] ?? ''}${until == null ? '' : ' · تا $until'}',
                      style: T.of(13, FontWeight.w500, C.muted),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: toman(total),
                            style: T.of(22, FontWeight.w800),
                          ),
                          TextSpan(
                            text: ' تومان',
                            style: T.of(14, FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (save.isNotEmpty)
                Text(save, style: T.of(13, FontWeight.w800, C.greenText)),
            ],
          ),
          const SizedBox(height: 10),
          Btn('پرداخت و فعال‌سازی', loading: busy, onPressed: onPay),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const MIcon(MI.lock, size: 14, color: C.muted),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'به صفحه‌ی امن بانک می‌ری و بعد از پرداخت، خودکار برمی‌گردی همین‌جا.',
                  textAlign: TextAlign.center,
                  style: T.of(12, FontWeight.w500, C.muted, 1.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlanSkeleton extends StatelessWidget {
  const _PlanSkeleton();
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        const Row(
          children: [
            Bone(width: 44, height: 44, radius: 14),
            SizedBox(width: 12),
            Expanded(child: Bone(height: 22)),
          ],
        ),
        const SizedBox(height: 24),
        for (var i = 0; i < 4; i++) ...[
          const Bone(height: 76, radius: 18),
          const SizedBox(height: 10),
        ],
      ],
    ),
  );
}
