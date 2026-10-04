import '/widgets/pressable.dart';
import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/features/main/data/models/quiz_submit_model.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/quiz/presentation/page/quiz_layout_helper.dart';
import 'package:mohammad/widgets/chunky_box.dart';
import '/core/copy/masir_copy.dart';
import 'package:mohammad/widgets/custom_button.dart';
import 'package:mohammad/widgets/custom_text.dart';
import 'package:mohammad/widgets/pill_chip.dart';
import 'package:mohammad/widgets/unit_kit/answer_tile.dart';
import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/core/helper/jalali_format.dart';
import '/widgets/masir_page.dart';
import '/widgets/section_header.dart';
import '/features/teacher/presentation/widgets/course_teacher_row.dart';

class QuizResultContent extends StatefulWidget {
  final UnitsModel data;
  final QuizSubmitResponseModel result;
  final Map<String, dynamic> userAnswers;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  /// Primary action once the quiz is passed; defaults to [onBack].
  final VoidCallback? onContinue;
  final Widget? banner;
  final Widget? footer;

  const QuizResultContent({
    super.key,
    required this.data,
    required this.result,
    required this.userAnswers,
    required this.onRetry,
    required this.onBack,
    this.onContinue,
    this.banner,
    this.footer,
  });

  @override
  State<QuizResultContent> createState() => _QuizResultContentState();
}

class _QuizResultContentState extends State<QuizResultContent> {
  final ConfettiController _confetti = ConfettiController(
    duration: const Duration(seconds: 2),
  );
  bool _fired = false;

  /// Picked once so the line does not change when the screen rebuilds.
  late final String _headline = _passed
      ? MasirCopy.cheer()
      : MasirCopy.nearMiss();

  List<UnitsQuestionModel> get _questions =>
      (widget.data.payload?.questions ?? []).cast<UnitsQuestionModel>();

  int? get _passThreshold => widget.data.payload?.passThreshold;

  bool get _passed => widget.result.passed ?? false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_fired || !_passed) return;
    _fired = true;
    if (!MediaQuery.of(context).disableAnimations) _confetti.play();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  int get _correctCount =>
      (widget.result.results ?? []).where((r) => r.correct == true).length;

  int get _wrongCount =>
      (widget.result.results ?? []).where((r) => r.correct == false).length;

  bool? _isCorrect(String questionId) {
    final results = widget.result.results ?? [];
    for (final item in results) {
      if (item.questionId == questionId) {
        return item.correct;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final title = widget.data.title ?? '';
    final passed = _passed;
    final score = (widget.result.score ?? 0).toInt();

    return Stack(
      children: [
        MasirPage.focus(
          title: title,
          onClose: widget.onBack,
          trailing: unitTeacherHeaderIcon(widget.data.teachers),
          stickyBottom: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (passed)
                CustomButton(
                  title: 'ادامه مسیر',
                  variant: ButtonVariant.success,
                  height: 54,
                  onTap: widget.onContinue ?? widget.onBack,
                )
              else ...[
                CustomButton(
                  title: 'تلاش مجدد',
                  height: 54,
                  onTap: widget.onRetry,
                ),
                const SizedBox(height: MasirSpace.xs),
                Pressable(
                  onTap: widget.onBack,
                  child: SizedBox(
                    height: 40,
                    child: Center(
                      child: CustomText.bodyStrong(
                        'بازگشت به مسیر',
                        color: c.inkMuted,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          children: [
            if (widget.banner != null) ...[
              widget.banner!,
              const SizedBox(height: MasirSpace.md),
            ],
            const SizedBox(height: MasirSpace.lg),
            _ScoreHero(
              score: score,
              passed: passed,
              threshold: _passThreshold,
              headline: _headline,
            ),
            if (_questions.isNotEmpty) ...[
              const SizedBox(height: MasirSpace.md),
              _StatsRow(correct: _correctCount, wrong: _wrongCount),
            ],
            if (_questions.isNotEmpty) ...[
              const SizedBox(height: MasirSpace.section),
              const SectionHeader('مرور پاسخ‌ها'),
            ],
            for (var i = 0; i < _questions.length; i++) ...[
              _ResultQuestionCard(
                index: i + 1,
                question: _questions[i],
                isCorrect: _isCorrect(_questions[i].id ?? ''),
                userAnswer: widget.userAnswers[_questions[i].id ?? ''],
              ),
              const SizedBox(height: MasirSpace.md),
            ],
            if (widget.footer != null) widget.footer!,
          ],
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirection: math.pi / 2,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.06,
              numberOfParticles: 14,
              gravity: 0.25,
              colors: [c.primary, c.green, c.sun, c.coral],
            ),
          ),
        ),
      ],
    );
  }
}

class _ScoreHero extends StatelessWidget {
  final int score;
  final bool passed;
  final int? threshold;
  final String headline;

  const _ScoreHero({
    required this.headline,
    required this.score,
    required this.passed,
    required this.threshold,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final accent = passed ? c.green : c.sun;
    final edge = passed ? c.greenEdge : c.sunEdge;
    final soft = passed ? c.green100 : c.sunSoft;
    final reduce = MediaQuery.of(context).disableAnimations;

    return ChunkyBox(
      fill: soft,
      edge: edge,
      borderColor: accent,
      radius: MasirRadius.card,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(
              begin: reduce ? score.toDouble() : 0,
              end: score.toDouble(),
            ),
            duration: reduce
                ? Duration.zero
                : const Duration(milliseconds: 1100),
            curve: Curves.easeOutCubic,
            builder: (context, v, _) {
              return SizedBox(
                width: 150,
                height: 150,
                child: CustomPaint(
                  painter: _RingPainter(
                    progress: v / 100,
                    color: accent,
                    track: c.surface,
                  ),
                  child: Center(
                    child: CustomText.display(
                      '${faDigits(v.round())}٪',
                      color: edge,
                    ),
                  ),
                ),
              );
            },
          ),
          16.h,
          // The headline bounces in once the ring has mostly filled.
          TweenAnimationBuilder<double>(
            tween: Tween(begin: reduce ? 1 : 0.5, end: 1),
            duration: reduce
                ? Duration.zero
                : const Duration(milliseconds: 900),
            curve: Curves.elasticOut,
            builder: (context, scale, child) => Transform.scale(
              scale: scale,
              child: Opacity(opacity: scale.clamp(0.0, 1.0), child: child),
            ),
            child: CustomText.title(
              headline,
              color: edge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: MasirSpace.xs),
          CustomText.body(
            passed ? 'آزمون رو قبول شدی' : 'می‌تونی دوباره امتحانش کنی',
            color: edge,
            textAlign: TextAlign.center,
          ),
          if (threshold != null) ...[
            8.h,
            PillChip(
              'حد نصاب ${faDigits(threshold!)}٪',
              tone: passed ? PillTone.success : PillTone.sun,
            ),
          ],
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color track;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.track,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 16.0;
    final rect = Offset.zero & size;
    final arc = rect.deflate(stroke / 2);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = track;
    canvas.drawArc(arc, 0, math.pi * 2, false, base);
    final fg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = color;
    // RTL-friendly: start at top, sweep clockwise.
    canvas.drawArc(
      arc,
      -math.pi / 2,
      math.pi * 2 * progress.clamp(0.0, 1.0),
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color || old.track != track;
}

class _StatsRow extends StatelessWidget {
  final int correct;
  final int wrong;

  const _StatsRow({required this.correct, required this.wrong});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PillChip(
          '${faDigits(correct)} درست',
          icon: Icons.check_circle_rounded,
          tone: PillTone.success,
        ),
        const SizedBox(width: MasirSpace.sm),
        PillChip(
          '${faDigits(wrong)} نادرست',
          icon: Icons.cancel_rounded,
          tone: PillTone.coral,
        ),
      ],
    );
  }
}

class _ResultQuestionCard extends StatelessWidget {
  final int index;
  final UnitsQuestionModel question;
  final bool? isCorrect;
  final dynamic userAnswer;

  const _ResultQuestionCard({
    required this.index,
    required this.question,
    required this.isCorrect,
    required this.userAnswer,
  });

  /// The user's pick turns green when the question was right and coral when
  /// it was not; other options stay neutral.
  AnswerState _stateFor(bool picked) {
    if (!picked) return AnswerState.idle;
    return switch (isCorrect) {
      true => AnswerState.correct,
      false => AnswerState.wrong,
      null => AnswerState.selected,
    };
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final layoutType = quizLayoutTypeFromQuestion(question.type);
    final stripe = switch (isCorrect) {
      true => c.green,
      false => c.coral,
      null => c.border,
    };

    return ChunkyBox(
      fill: c.surface,
      edge: c.lip,
      borderColor: c.border,
      radius: MasirRadius.card,
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 5, color: stripe),
          Padding(
            padding: const EdgeInsets.all(MasirSpace.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isCorrect != null) ...[
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: PillChip(
                      isCorrect! ? 'درست' : 'نادرست',
                      icon: isCorrect!
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      tone: isCorrect! ? PillTone.success : PillTone.coral,
                    ),
                  ),
                  const SizedBox(height: MasirSpace.md),
                ],
                CustomText.headline(
                  '${faDigits(index)}. ${question.text ?? ''}',
                  color: c.ink,
                ),
                const SizedBox(height: MasirSpace.md),
                switch (layoutType) {
                  QuizLayoutType.trueFalse => Row(
                    children: [
                      Expanded(
                        child: AnswerTile(
                          label: 'درست',
                          badgeIcon: Icons.check_rounded,
                          vertical: true,
                          state: _stateFor(userAnswer == true),
                        ),
                      ),
                      const SizedBox(width: MasirSpace.md),
                      Expanded(
                        child: AnswerTile(
                          label: 'نادرست',
                          badgeIcon: Icons.close_rounded,
                          vertical: true,
                          state: _stateFor(userAnswer == false),
                        ),
                      ),
                    ],
                  ),
                  QuizLayoutType.multiChoice => Column(
                    children: [
                      for (var i = 0; i < (question.options ?? []).length; i++)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: i == question.options!.length - 1
                                ? 0
                                : MasirSpace.sm + 2,
                          ),
                          child: AnswerTile(
                            label: question.options![i],
                            badge: i < kOptionLetters.length
                                ? kOptionLetters[i]
                                : faDigits(i + 1),
                            state: _stateFor(
                              userAnswer is int && userAnswer == i,
                            ),
                          ),
                        ),
                    ],
                  ),
                  _ => const SizedBox.shrink(),
                },
              ],
            ),
          ),
        ],
      ),
    );
  }
}
