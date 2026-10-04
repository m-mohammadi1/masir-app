import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/features/main/data/models/quiz_submit_model.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/quiz/presentation/page/quiz_layout_helper.dart';
import 'package:mohammad/widgets/chunky_box.dart';
import 'package:mohammad/widgets/custom_button.dart';
import 'package:mohammad/widgets/custom_text.dart';
import 'package:mohammad/widgets/pill_chip.dart';
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
  final Widget? banner;
  final Widget? footer;

  const QuizResultContent({
    super.key,
    required this.data,
    required this.result,
    required this.userAnswers,
    required this.onRetry,
    required this.onBack,
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
          children: [
            if (widget.banner != null) ...[
              widget.banner!,
              const SizedBox(height: MasirSpace.md),
            ],
            const SizedBox(height: MasirSpace.lg),
            _ScoreHero(score: score, passed: passed, threshold: _passThreshold),
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
          stickyBottom: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (passed)
                CustomButton(
                  title: 'ادامه مسیر',
                  variant: ButtonVariant.success,
                  height: 54,
                  onTap: widget.onBack,
                )
              else ...[
                CustomButton(
                  title: 'تلاش مجدد',
                  height: 54,
                  onTap: widget.onRetry,
                ),
                const SizedBox(height: MasirSpace.xs),
                OnClick(
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

  const _ScoreHero({
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
          CustomText.title(
            passed ? 'آفرین! قبول شدی' : 'این بار نشد، ولی نزدیکی',
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

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final layoutType = quizLayoutTypeFromQuestion(question.type);

    return ChunkyBox(
      fill: c.surface,
      edge: c.lip,
      borderColor: c.border,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isCorrect != null)
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
          if (isCorrect != null) 12.h,
          CustomText.headline(
            '${faDigits(index)}. ${question.text ?? ''}',
            color: c.ink,
          ),
          12.h,
          switch (layoutType) {
            QuizLayoutType.trueFalse => Row(
              children: [
                Expanded(
                  child: _ResultTile(
                    title: 'درست',
                    selected: userAnswer == true,
                    isCorrect: isCorrect,
                  ),
                ),
                12.w,
                Expanded(
                  child: _ResultTile(
                    title: 'نادرست',
                    selected: userAnswer == false,
                    isCorrect: isCorrect,
                  ),
                ),
              ],
            ),
            QuizLayoutType.multiChoice => Column(
              children: [
                for (var i = 0; i < (question.options ?? []).length; i++)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: i == question.options!.length - 1 ? 0 : 10,
                    ),
                    child: _ResultTile(
                      title: question.options![i],
                      selected: userAnswer is int && userAnswer == i + 1,
                      isCorrect: isCorrect,
                      left: true,
                    ),
                  ),
              ],
            ),
            _ => const SizedBox.shrink(),
          },
        ],
      ),
    );
  }
}

/// Read-only answer tile. The user's pick turns green when the question was
/// correct and coral when it was not; other options stay neutral.
class _ResultTile extends StatelessWidget {
  final String title;
  final bool selected;
  final bool? isCorrect;
  final bool left;

  const _ResultTile({
    required this.title,
    required this.selected,
    required this.isCorrect,
    this.left = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Color fill = c.surface, edge = c.lip, border = c.border, text = c.inkMuted;
    IconData? icon;
    if (selected) {
      if (isCorrect == true) {
        fill = c.green100;
        edge = c.greenEdge;
        border = c.green;
        text = c.greenEdge;
        icon = Icons.check_rounded;
      } else if (isCorrect == false) {
        fill = c.coralSoft;
        edge = c.coralEdge;
        border = c.coral;
        text = c.coralEdge;
        icon = Icons.close_rounded;
      } else {
        fill = c.primaryTint;
        edge = c.primaryEdge;
        border = c.primary;
        text = c.primary;
      }
    }
    return ChunkyBox(
      fill: fill,
      edge: edge,
      borderColor: border,
      radius: MasirRadius.row,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: left ? 14 : 0),
      height: left ? null : 54,
      alignment: left ? null : Alignment.center,
      child: Row(
        mainAxisAlignment: left
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          if (left)
            Expanded(
              child: CustomText.bodyStrong(
                title,
                color: selected ? text : c.ink,
              ),
            )
          else
            CustomText.headline(title, color: selected ? text : c.ink),
          if (icon != null) ...[8.w, Icon(icon, size: 20, color: text)],
        ],
      ),
    );
  }
}
