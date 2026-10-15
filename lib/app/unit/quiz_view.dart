import 'package:flutter/material.dart';

import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/api/models.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

class QuizQuestion {
  final String id;
  final String type; // four_choice | true_false
  final String text;
  final List<String> options;
  const QuizQuestion({
    required this.id,
    required this.type,
    required this.text,
    required this.options,
  });

  bool get trueFalse => type == 'true_false';

  static List<QuizQuestion> fromPayload(Map<String, dynamic> p) => [
    for (final q in (p['questions'] as List? ?? const []))
      if (q is Map)
        QuizQuestion(
          id: '${q['id']}',
          type: '${q['type']}',
          text: '${q['text'] ?? ''}',
          options: (q['options'] as List? ?? const [])
              .map((e) => '$e')
              .toList(),
        ),
  ];
}

const _keys = ['الف', 'ب', 'ج', 'د', 'ه', 'و'];

/// «آزمون»: one question at a time with step dots; the last one sends.
class QuizRunner extends StatefulWidget {
  final String unitId;
  final String title;
  final List<QuizQuestion> questions;
  final VoidCallback onExit;
  final ValueChanged<QuizResult> onResult;
  const QuizRunner({
    super.key,
    required this.unitId,
    required this.title,
    required this.questions,
    required this.onExit,
    required this.onResult,
  });

  @override
  State<QuizRunner> createState() => _QuizRunnerState();
}

class _QuizRunnerState extends State<QuizRunner> {
  int _idx = 0;
  final Map<int, Object> _answers = {};
  bool _sending = false;

  List<QuizQuestion> get qs => widget.questions;

  Future<void> _submit() async {
    setState(() => _sending = true);
    final r = await inject<MasirApi>().submitQuiz(widget.unitId, [
      for (var i = 0; i < qs.length; i++)
        (questionId: qs[i].id, answer: _answers[i]!),
    ]);
    if (!mounted) return;
    setState(() => _sending = false);
    r.fold(
      (e) => Toast.show(
        context,
        title: 'ارسال نشد',
        body: e.friendly,
        tone: ToastTone.error,
      ),
      widget.onResult,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final q = qs[_idx];
    final answered = _answers[_idx];
    final allAnswered = _answers.length == qs.length;
    final last = _idx == qs.length - 1;
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, top + 12, 16, 8),
          child: Row(
            children: [
              CloseCircle(label: 'خروج از آزمون', onTap: widget.onExit),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: T.of(13, FontWeight.w700),
                          ),
                        ),
                        Text(
                          'سؤال ${fa(_idx + 1)} از ${fa(qs.length)}',
                          style: T.of(13, FontWeight.w700, C.muted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        for (var i = 0; i < qs.length; i++) ...[
                          if (i > 0) const SizedBox(width: 6),
                          Expanded(
                            child: Semantics(
                              button: true,
                              label:
                                  'سؤال ${fa(i + 1)}${_answers.containsKey(i) ? '، جواب داده شده' : ''}',
                              child: GestureDetector(
                                onTap: () => setState(() => _idx = i),
                                child: Container(
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: _answers.containsKey(i)
                                        ? pal.p
                                        : (i == _idx ? pal.soft : C.border),
                                    borderRadius: BorderRadius.circular(999),
                                    boxShadow: i == _idx
                                        ? [
                                            BoxShadow(
                                              color: pal.soft,
                                              spreadRadius: 3,
                                            ),
                                          ]
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  height: 28,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: pal.soft,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Center(
                    widthFactor: 1,
                    child: Text(
                      q.trueFalse ? 'درست یا نادرست' : 'چهارگزینه‌ای',
                      style: T.of(13, FontWeight.w800, pal.ink),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(q.text, style: T.of(22, FontWeight.w800, C.ink, 1.7)),
              const SizedBox(height: 22),
              if (q.trueFalse)
                Row(
                  children: [
                    for (final v in [true, false]) ...[
                      if (!v) const SizedBox(width: 14),
                      Expanded(
                        child: _TfOption(
                          value: v,
                          selected: answered == v,
                          onTap: () => setState(() => _answers[_idx] = v),
                        ),
                      ),
                    ],
                  ],
                )
              else
                for (var i = 0; i < q.options.length; i++) ...[
                  if (i > 0) const SizedBox(height: 12),
                  _ChoiceOption(
                    keyLabel: i < _keys.length ? _keys[i] : fa(i + 1),
                    text: q.options[i],
                    selected: answered == i,
                    onTap: () => setState(() => _answers[_idx] = i),
                  ),
                ],
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: C.surface,
            border: Border(top: BorderSide(color: C.border, width: 2)),
          ),
          padding: EdgeInsets.fromLTRB(16, 12, 16, 20 + bottom),
          child: Row(
            children: [
              SizedBox(
                width: 110,
                child: Btn(
                  'قبلی',
                  kind: BtnKind.secondary,
                  height: 56,
                  fontSize: 16,
                  onPressed: _idx == 0 ? null : () => setState(() => _idx--),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: last
                    ? Btn(
                        'ارسال پاسخ',
                        height: 56,
                        fontSize: 17,
                        loading: _sending,
                        onPressed: allAnswered ? _submit : null,
                      )
                    : Btn(
                        'بعدی',
                        height: 56,
                        fontSize: 17,
                        onPressed: answered == null
                            ? null
                            : () => setState(() => _idx++),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChoiceOption extends StatelessWidget {
  final String keyLabel;
  final String text;
  final bool selected;
  final VoidCallback onTap;
  const _ChoiceOption({
    required this.keyLabel,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final latin = RegExp(r'^[\x00-\x7F]+$').hasMatch(text);
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          constraints: const BoxConstraints(minHeight: 60),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? pal.soft : C.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: selected ? pal.p : C.border, width: 2),
            boxShadow: [lip(selected ? pal.e : C.lip)],
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: selected ? pal.p : C.sand,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  keyLabel,
                  style: T.of(13, FontWeight.w800, selected ? pal.on : C.body),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  textDirection: latin ? TextDirection.ltr : null,
                  textAlign: TextAlign.right,
                  style: T.of(16, FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TfOption extends StatelessWidget {
  final bool value;
  final bool selected;
  final VoidCallback onTap;
  const _TfOption({
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          height: 150,
          decoration: BoxDecoration(
            color: selected ? pal.soft : C.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: selected ? pal.p : C.border, width: 2),
            boxShadow: [lip(selected ? pal.e : C.lip, 5)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: selected
                      ? pal.p
                      : (value ? C.greenSoft : const Color(0xFFFFE9EA)),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: MIcon(
                  value ? MI.check : MI.close,
                  size: value ? 28 : 26,
                  strokeWidth: 3.2,
                  color: selected
                      ? pal.on
                      : (value ? C.greenText : C.coralText),
                ),
              ),
              const SizedBox(height: 12),
              Text(value ? 'درست' : 'نادرست', style: T.of(18, FontWeight.w800)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Round 44px close button with a sand border (units and quizzes).
class CloseCircle extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const CloseCircle({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: C.surface,
          shape: BoxShape.circle,
          border: Border.all(color: C.border, width: 2),
        ),
        alignment: Alignment.center,
        child: const MIcon(MI.close, size: 18, strokeWidth: 2.6),
      ),
    ),
  );
}

/// «نتیجه‌ی آزمون»: score ring, a line about it, every attempt (the last
/// one counts), then continue, review or retake.
class QuizResultView extends StatelessWidget {
  final QuizResult result;
  final String unitTitle;
  final VoidCallback onClose;
  final VoidCallback onContinue;
  final VoidCallback onReview;
  final VoidCallback onRetry;
  const QuizResultView({
    super.key,
    required this.result,
    required this.unitTitle,
    required this.onClose,
    required this.onContinue,
    required this.onReview,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final r = result;
    final good = r.score >= 70;
    final attempts = r.attempts.isEmpty
        ? [
            QuizAttempt(
              number: 1,
              percent: r.score,
              correct: r.correct,
              total: r.total,
              current: true,
            ),
          ]
        : r.attempts;
    final prev = attempts.length > 1 ? attempts[attempts.length - 2] : null;
    final better = prev != null && r.score > prev.percent;
    final String title;
    final String body;
    final p = r.progress;
    if (better) {
      title = 'این بار بهتر شد!';
      body =
          'نتیجه‌ی تلاش ${fa(attempts.length)}م جای قبلی نشست. همین‌طوری ادامه بده.';
    } else if (good) {
      title = 'آزمون تموم شد!';
      body = p != null && p.moduleOrder > 0 && !p.moduleCompleted
          ? 'داری می‌ترکونی. «$unitTitle» تموم شد و جام فصل ${fa(p.moduleOrder)} یه قدم نزدیک‌تر شد.'
          : 'داری می‌ترکونی. «$unitTitle» تموم شد.';
    } else {
      title = 'تموم شد، ثبت شد';
      body =
          'واحد بعد باز شد و می‌تونی ادامه بدی. اگه خواستی پاسخ‌ها رو مرور کن و یه بار دیگه بده.';
    }
    final ring = good || better ? C.green : C.sun;
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.paddingOf(context).top + 12,
        20,
        24 + bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: CloseCircle(label: 'بستن', onTap: onClose),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        if (good || better) ...[
                          Positioned(
                            top: 20,
                            right: 40,
                            child: Transform.rotate(
                              angle: .52,
                              child: _bit(14, 6, C.sun, 3),
                            ),
                          ),
                          Positioned(
                            top: 70,
                            left: 30,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: pal.p,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            left: 120,
                            child: Transform.rotate(
                              angle: -.7,
                              child: _bit(12, 5, C.green, 3),
                            ),
                          ),
                          Positioned(
                            top: 130,
                            right: 18,
                            child: Transform.rotate(
                              angle: .35,
                              child: _bit(9, 9, C.coral, 2),
                            ),
                          ),
                        ],
                        Semantics(
                          label:
                              'امتیاز ${fa(r.score)} درصد، ${fa(r.correct)} از ${fa(r.total)} درست',
                          child: ScoreRing(
                            percent: r.score,
                            size: 168,
                            stroke: 16,
                            color: ring,
                            fill: C.paper,
                            label: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  pct(r.score),
                                  style: T.of(42, FontWeight.w900, C.ink, 1.1),
                                ),
                                Text(
                                  '${fa(r.correct)} از ${fa(r.total)} درست',
                                  style: T.of(13, FontWeight.w500, C.muted),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: T.of(
                      26,
                      FontWeight.w900,
                      good || better ? C.greenText : C.sunText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    body,
                    textAlign: TextAlign.center,
                    style: T.of(15, FontWeight.w500, C.body, 1.9),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: C.surface,
                      border: Border.all(color: C.border, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'تلاش‌های این آزمون',
                          style: T.of(12, FontWeight.w700, C.muted),
                        ),
                        const SizedBox(height: 4),
                        for (final a in attempts)
                          Container(
                            constraints: const BoxConstraints(minHeight: 40),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: C.sand, width: 2),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'تلاش ${fa(a.number)}',
                                  style: T.of(
                                    14,
                                    FontWeight.w700,
                                    a.current ? C.ink : C.muted,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  pct(a.percent),
                                  style: T
                                      .of(
                                        14,
                                        FontWeight.w800,
                                        a.current ? C.ink : C.muted,
                                      )
                                      .copyWith(
                                        decoration: a.current
                                            ? null
                                            : TextDecoration.lineThrough,
                                      ),
                                ),
                                const Spacer(),
                                if (a.current)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: C.greenSoft,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const MIcon(
                                          MI.check,
                                          size: 12,
                                          color: C.greenText,
                                          strokeWidth: 3.4,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'ثبت شد',
                                          style: T.of(
                                            12,
                                            FontWeight.w800,
                                            C.greenText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  Text(
                                    'جایگزین شد',
                                    style: T.of(12, FontWeight.w700, C.muted),
                                  ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          'هر بار دوباره بدی، نتیجه‌ی آخرین تلاش ثبت می‌شه.',
                          style: T.of(12, FontWeight.w500, C.muted, 1.8),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Btn('ادامه مسیر', height: 56, fontSize: 18, onPressed: onContinue),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Btn(
                  'مرور پاسخ‌ها',
                  kind: BtnKind.secondary,
                  height: 52,
                  fontSize: 15,
                  onPressed: onReview,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Btn(
                  'دوباره بده',
                  kind: BtnKind.secondary,
                  icon: MI.retry,
                  height: 52,
                  fontSize: 15,
                  onPressed: onRetry,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _bit(double w, double h, Color c, double r) => Container(
    width: w,
    height: h,
    decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(r)),
  );
}
