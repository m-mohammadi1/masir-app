import '/widgets/pressable.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/features/main/data/models/request_quiz_submit_model.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/quiz/presentation/page/quiz_layout_helper.dart';
import 'package:mohammad/widgets/chunky_box.dart';
import 'package:mohammad/widgets/custom_button.dart';
import 'package:mohammad/widgets/custom_text.dart';
import 'package:mohammad/widgets/pill_chip.dart';
import 'package:mohammad/widgets/unit_kit/answer_tile.dart';
import 'package:mohammad/widgets/unit_kit/unit_shell.dart';
import '/core/helper/jalali_format.dart';
import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/features/teacher/presentation/widgets/course_teacher_row.dart';

/// A quiz as a stepper: one question per page. The student moves on with
/// "بعدی" and sends the answers from the last question.
class QuizUnitContent extends StatefulWidget {
  final UnitsModel data;
  final bool isCompleted;
  final bool isSubmitting;
  final void Function(List<QuizSubmitAnswerModel> answers)? onSubmit;
  final VoidCallback onBack;
  final Widget? banner;
  final Widget? footer;

  const QuizUnitContent({
    super.key,
    required this.data,
    required this.isCompleted,
    this.isSubmitting = false,
    this.onSubmit,
    required this.onBack,
    this.banner,
    this.footer,
  });

  @override
  State<QuizUnitContent> createState() => QuizUnitContentState();
}

class QuizUnitContentState extends State<QuizUnitContent> {
  final Map<String, bool?> _trueFalseAnswers = {};
  final Map<String, int> _multiChoiceAnswers = {};

  int _page = 0;
  bool _forward = true;

  List<UnitsQuestionModel> get _questions =>
      (widget.data.payload?.questions ?? []).cast<UnitsQuestionModel>();

  int? get _passThreshold => widget.data.payload?.passThreshold;

  bool get _onLastQuestion => _page == _questions.length - 1;

  bool _isAnswered(UnitsQuestionModel question) {
    final id = question.id ?? '';
    return switch (quizLayoutTypeFromQuestion(question.type)) {
      QuizLayoutType.trueFalse => _trueFalseAnswers[id] != null,
      QuizLayoutType.multiChoice => _multiChoiceAnswers.containsKey(id),
      _ => true,
    };
  }

  void _goTo(int page) {
    final target = page.clamp(0, _questions.length - 1);
    if (target == _page) return;
    setState(() {
      _forward = target > _page;
      _page = target;
    });
  }

  void _setTrueFalseAnswer(String questionId, bool value) {
    if (widget.isCompleted) return;
    setState(() => _trueFalseAnswers[questionId] = value);
  }

  void _setMultiChoiceAnswer(String questionId, int index) {
    if (widget.isCompleted) return;
    setState(() => _multiChoiceAnswers[questionId] = index);
  }

  void reset() {
    setState(() {
      _trueFalseAnswers.clear();
      _multiChoiceAnswers.clear();
      _page = 0;
      _forward = true;
    });
  }

  List<QuizSubmitAnswerModel> buildAnswers() {
    return _questions.map((question) {
      final questionId = question.id ?? '';
      final layoutType = quizLayoutTypeFromQuestion(question.type);

      return QuizSubmitAnswerModel(
        questionId: questionId,
        answer: switch (layoutType) {
          QuizLayoutType.trueFalse => _trueFalseAnswers[questionId],
          QuizLayoutType.multiChoice => _multiChoiceAnswers[questionId],
          _ => null,
        },
      );
    }).toList();
  }

  bool get _allAnswered =>
      _questions.isNotEmpty && _questions.every(_isAnswered);

  int get _answeredCount => _questions.where(_isAnswered).length;

  void _handleSubmit() {
    if (!_allAnswered) {
      CustomToast.toast(context, 'همه‌ی سؤال‌ها رو جواب بده');
      return;
    }
    widget.onSubmit?.call(buildAnswers());
  }

  void _next() {
    if (_onLastQuestion) return;
    if (!widget.isCompleted && !_isAnswered(_questions[_page])) return;
    _goTo(_page + 1);
  }

  @override
  Widget build(BuildContext context) {
    final questions = _questions;
    final progress = widget.isCompleted
        ? 100
        : questions.isEmpty
        ? 0
        : _answeredCount / questions.length * 100;

    return UnitShell(
      type: widget.data.type ?? 'quiz',
      title: widget.data.title ?? '',
      isCompleted: widget.isCompleted,
      meta: questions.isEmpty ? null : '${faDigits(questions.length)} سؤال',
      headerIcon: unitTeacherHeaderIcon(widget.data.teachers),
      banner: widget.banner,
      footer: widget.footer,
      onBack: widget.onBack,
      progress: progress,
      actions: _buildActions(),
      children: [
        if (questions.isEmpty)
          CustomText.body(
            'این آزمون هنوز سؤالی نداره.',
            color: context.colors.inkMuted,
          )
        else
          AnimatedSwitcher(
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              final rtl = Directionality.of(context) == TextDirection.rtl;
              // The page entering is the one keyed with the current index.
              final entering = child.key == ValueKey<int>(_page);
              final sign = (rtl ? -1.0 : 1.0) * (_forward ? 1.0 : -1.0);
              final begin = Offset(sign * (entering ? 0.12 : -0.12), 0);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: begin,
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            layoutBuilder: (current, previous) => Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                ...previous.map(
                  (w) => Positioned(top: 0, left: 0, right: 0, child: w),
                ),
                ?current,
              ],
            ),
            child: KeyedSubtree(
              key: ValueKey<int>(_page),
              child: _buildQuestion(_page),
            ),
          ),
      ],
    );
  }

  Widget _buildActions() {
    final c = context.colors;
    final questions = _questions;

    Widget primary;
    if (questions.isEmpty || (widget.isCompleted && _onLastQuestion)) {
      primary = CustomButton(
        title: 'بازگشت به مسیر',
        onTap: widget.onBack,
        height: 54,
      );
    } else if (_onLastQuestion) {
      primary = CustomButton(
        title: 'ارسال پاسخ',
        loading: widget.isSubmitting,
        onTap: _handleSubmit,
        enable: _isAnswered(questions[_page]),
        variant: ButtonVariant.success,
        height: 54,
      );
    } else {
      final answered = widget.isCompleted || _isAnswered(questions[_page]);
      primary = CustomButton(
        title: 'بعدی',
        onTap: answered ? _next : null,
        enable: answered,
        height: 54,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        primary,
        const SizedBox(height: MasirSpace.xs),
        Row(
          children: [
            if (_page > 0 && questions.isNotEmpty)
              Expanded(
                child: Pressable(
                  onTap: () => _goTo(_page - 1),
                  child: SizedBox(
                    height: 40,
                    child: Center(
                      child: CustomText.bodyStrong('قبلی', color: c.primary),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: Pressable(
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
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuestion(int index) {
    final question = _questions[index];
    final id = question.id ?? '';
    final c = context.colors;
    final layoutType = quizLayoutTypeFromQuestion(question.type);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            CustomText.bodyStrong(
              'سؤال ${faDigits(index + 1)} از ${faDigits(_questions.length)}',
              color: c.primary,
            ),
            const Spacer(),
            if (_passThreshold != null)
              PillChip(
                'حد نصاب ${faDigits(_passThreshold)}٪',
                tone: PillTone.neutral,
              ),
          ],
        ),
        const SizedBox(height: MasirSpace.md),
        ChunkyBox(
          fill: c.surface,
          edge: c.lip,
          borderColor: c.border,
          radius: MasirRadius.card,
          padding: const EdgeInsets.all(MasirSpace.lg),
          child: CustomText.headline(question.text ?? '', color: c.ink),
        ),
        const SizedBox(height: MasirSpace.lg),
        switch (layoutType) {
          QuizLayoutType.trueFalse => _TrueFalseOptions(
            readOnly: widget.isCompleted,
            selectedValue: _trueFalseAnswers[id],
            onChanged: (v) => _setTrueFalseAnswer(id, v),
          ),
          QuizLayoutType.multiChoice => _MultiChoiceOptions(
            readOnly: widget.isCompleted,
            options: question.options ?? [],
            selectedIndex: _multiChoiceAnswers[id],
            onChanged: (i) => _setMultiChoiceAnswer(id, i),
          ),
          _ => const SizedBox.shrink(),
        },
      ],
    );
  }
}

class _TrueFalseOptions extends StatelessWidget {
  final bool readOnly;
  final bool? selectedValue;
  final ValueChanged<bool> onChanged;

  const _TrueFalseOptions({
    required this.readOnly,
    required this.selectedValue,
    required this.onChanged,
  });

  AnswerState _stateFor(bool value) {
    if (readOnly) return AnswerState.disabled;
    return selectedValue == value ? AnswerState.selected : AnswerState.idle;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AnswerTile(
            label: 'درست',
            badgeIcon: Icons.check_rounded,
            vertical: true,
            state: _stateFor(true),
            onTap: () => onChanged(true),
          ),
        ),
        const SizedBox(width: MasirSpace.md),
        Expanded(
          child: AnswerTile(
            label: 'نادرست',
            badgeIcon: Icons.close_rounded,
            vertical: true,
            state: _stateFor(false),
            onTap: () => onChanged(false),
          ),
        ),
      ],
    );
  }
}

class _MultiChoiceOptions extends StatelessWidget {
  final bool readOnly;
  final List<String> options;
  final int? selectedIndex;
  final ValueChanged<int> onChanged;

  const _MultiChoiceOptions({
    required this.readOnly,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(options.length, (index) {
        // The API grades four-choice answers by 0-based option index (0..3),
        // exactly the position in the options list.
        final state = readOnly
            ? AnswerState.disabled
            : selectedIndex == index
            ? AnswerState.selected
            : AnswerState.idle;
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == options.length - 1 ? 0 : MasirSpace.sm + 2,
          ),
          child: AnswerTile(
            label: options[index],
            badge: index < kOptionLetters.length
                ? kOptionLetters[index]
                : faDigits(index + 1),
            state: state,
            onTap: () => onChanged(index),
          ),
        );
      }),
    );
  }
}
