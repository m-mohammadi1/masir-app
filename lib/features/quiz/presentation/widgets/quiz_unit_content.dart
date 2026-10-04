import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/features/main/data/models/request_quiz_submit_model.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/quiz/presentation/page/quiz_layout_helper.dart';
import 'package:mohammad/features/quiz/presentation/widgets/unit_action_buttons.dart';
import 'package:mohammad/widgets/chunky_box.dart';
import 'package:mohammad/widgets/pill_chip.dart';
import '/features/quiz/presentation/widgets/unit_top_bar.dart';
import '/features/main/presentation/page/outline/roadmap/paper_theme.dart' show persianDigits;
import 'package:mohammad/widgets/custom_text.dart';
import '/core/theme/theme_context.dart';
import '/features/teacher/presentation/widgets/course_teacher_row.dart';

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

  List<UnitsQuestionModel> get _questions =>
      (widget.data.payload?.questions ?? []).cast<UnitsQuestionModel>();

  int? get _passThreshold => widget.data.payload?.passThreshold;

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

  bool get _allAnswered {
    for (final question in _questions) {
      final questionId = question.id ?? '';
      final layoutType = quizLayoutTypeFromQuestion(question.type);

      if (layoutType == QuizLayoutType.trueFalse &&
          _trueFalseAnswers[questionId] == null) {
        return false;
      }
      if (layoutType == QuizLayoutType.multiChoice &&
          !_multiChoiceAnswers.containsKey(questionId)) {
        return false;
      }
    }
    return _questions.isNotEmpty;
  }

  int get _answeredCount {
    var n = 0;
    for (final question in _questions) {
      final id = question.id ?? '';
      if (_trueFalseAnswers[id] != null || _multiChoiceAnswers.containsKey(id)) {
        n++;
      }
    }
    return n;
  }

  void _handleSubmit() {
    if (!_allAnswered) {
      CustomToast.toast(context, 'لطفاً به همه سوالات پاسخ دهید');
      return;
    }
    widget.onSubmit?.call(buildAnswers());
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.data.title ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UnitTopBar(
          title: title,
          onClose: widget.onBack,
          progress: widget.isCompleted || _questions.isEmpty
              ? (widget.isCompleted ? 100 : 0)
              : _answeredCount / _questions.length * 100,
          trailing: unitTeacherHeaderIcon(widget.data.teachers),
        ),
        14.h,
        Row(
          children: [
            PillChip(unitTypeLabel(widget.data.type ?? 'quiz')),
            if (widget.isCompleted) ...[
              8.w,
              const PillChip(
                'تکمیل شده',
                icon: Icons.check_circle_rounded,
                tone: PillTone.success,
              ),
            ] else if (_questions.isNotEmpty) ...[
              8.w,
              PillChip(
                '${persianDigits(_answeredCount)} از ${persianDigits(_questions.length)}',
                tone: PillTone.neutral,
              ),
            ],
          ],
        ),
        if (widget.banner != null) ...[12.h, widget.banner!],
        if (_passThreshold != null) ...[
          12.h,
          CustomText(
            'حد نصاب: $_passThreshold٪',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: context.colors.inkMuted,
          ),
        ],
        16.h,
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: _questions.length,
            separatorBuilder: (_, __) => 12.h,
            itemBuilder: (context, index) {
              final question = _questions[index];
              return _QuizQuestionCard(
                index: index + 1,
                question: question,
                readOnly: widget.isCompleted,
                trueFalseValue: _trueFalseAnswers[question.id ?? ''],
                multiChoiceValue: _multiChoiceAnswers[question.id ?? ''],
                onTrueFalseChanged: (value) =>
                    _setTrueFalseAnswer(question.id ?? '', value),
                onMultiChoiceChanged: (value) =>
                    _setMultiChoiceAnswer(question.id ?? '', value),
              );
            },
          ),
        ),
        if (widget.footer != null) ...[12.h, widget.footer!],
        UnitActionButtons(
          showPrimary: !widget.isCompleted,
          primaryTitle: 'ارسال پاسخ',
          isSubmitting: widget.isSubmitting,
          onPrimary: _handleSubmit,
          onBack: widget.onBack,
        ),
      ],
    );
  }
}

class _QuizQuestionCard extends StatelessWidget {
  final int index;
  final UnitsQuestionModel question;
  final bool readOnly;
  final bool? trueFalseValue;
  final int? multiChoiceValue;
  final ValueChanged<bool> onTrueFalseChanged;
  final ValueChanged<int> onMultiChoiceChanged;

  const _QuizQuestionCard({
    required this.index,
    required this.question,
    required this.readOnly,
    required this.trueFalseValue,
    required this.multiChoiceValue,
    required this.onTrueFalseChanged,
    required this.onMultiChoiceChanged,
  });

  @override
  Widget build(BuildContext context) {
    final layoutType = quizLayoutTypeFromQuestion(question.type);

    final c = context.colors;
    return ChunkyBox(
      fill: c.surface,
      edge: c.lip,
      borderColor: c.border,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText(
            '${persianDigits(index)}. ${question.text ?? ''}',
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: context.colors.ink,
          ),
          16.h,
          switch (layoutType) {
            QuizLayoutType.trueFalse => _TrueFalseOptions(
              readOnly: readOnly,
              selectedValue: trueFalseValue,
              onChanged: onTrueFalseChanged,
            ),
            QuizLayoutType.multiChoice => _MultiChoiceOptions(
              readOnly: readOnly,
              options: question.options ?? [],
              selectedIndex: multiChoiceValue,
              onChanged: onMultiChoiceChanged,
            ),
            _ => const SizedBox.shrink(),
          },
        ],
      ),
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuizOutlineButton(
            title: 'درست',
            selected: selectedValue == true,
            readOnly: readOnly,
            onTap: () => onChanged(true),
          ),
        ),
        12.w,
        Expanded(
          child: _QuizOutlineButton(
            title: 'نادرست',
            selected: selectedValue == false,
            readOnly: readOnly,
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
        // API expects 1-based answers (1..n), not list indices (0..n-1).
        final optionNumber = index + 1;
        final isSelected = selectedIndex == optionNumber;
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == options.length - 1 ? 0 : 10,
          ),
          child: OnClick(
            onTap: readOnly ? null : () => onChanged(optionNumber),
            child: ChunkyBox(
              fill: isSelected ? context.colors.primaryTint : context.colors.surface,
              edge: isSelected ? context.colors.primaryEdge : context.colors.lip,
              borderColor:
                  isSelected ? context.colors.primary : context.colors.border,
              radius: 16,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: CustomText(
                      options[index],
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? context.colors.primary
                          : context.colors.ink,
                    ),
                  ),
                  12.w,
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? context.colors.primary : null,
                      border: Border.all(
                        color: isSelected
                            ? context.colors.primary
                            : context.colors.inkFaint,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: context.colors.onPrimary,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _QuizOutlineButton extends StatelessWidget {
  final String title;
  final bool selected;
  final bool readOnly;
  final VoidCallback onTap;

  const _QuizOutlineButton({
    required this.title,
    required this.selected,
    required this.readOnly,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Opacity(
      opacity: readOnly ? 0.6 : 1,
      child: ChunkyBox(
        fill: selected ? c.primaryTint : c.surface,
        edge: selected ? c.primaryEdge : c.lip,
        borderColor: selected ? c.primary : c.border,
        height: 56,
        alignment: Alignment.center,
        onTap: readOnly ? null : onTap,
        child: CustomText(
          title,
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: selected ? c.primary : c.ink,
        ),
      ),
    );
  }
}
