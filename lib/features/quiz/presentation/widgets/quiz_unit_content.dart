import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/features/main/data/models/request_quiz_submit_model.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/quiz/presentation/page/quiz_layout_helper.dart';
import 'package:mohammad/features/quiz/presentation/widgets/unit_action_buttons.dart';
import 'package:mohammad/widgets/custom_app_bar.dart';
import 'package:mohammad/widgets/custom_text.dart';
import '/core/theme/theme_context.dart';
import '/features/teacher/presentation/widgets/course_teacher_row.dart';

class QuizUnitContent extends StatefulWidget {
  final UnitsModel data;
  final bool isCompleted;
  final bool isSubmitting;
  final void Function(List<QuizSubmitAnswerModel> answers)? onSubmit;
  final VoidCallback onBack;

  const QuizUnitContent({
    super.key,
    required this.data,
    required this.isCompleted,
    this.isSubmitting = false,
    this.onSubmit,
    required this.onBack,
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
        CustomAppBar(
          title: title,
          icon: unitTeacherHeaderIcon(widget.data.teachers),
        ),
        16.h,
        Row(
          children: [
            _QuizTypeBadge(label: widget.data.type ?? 'quiz'),
            if (widget.isCompleted) ...[8.w, const _CompletedBadge()],
          ],
        ),
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
        16.h,
        UnitActionButtons(
          showPrimary: !widget.isCompleted,
          primaryTitle: 'ارسال پاسخ',
          isSubmitting: widget.isSubmitting,
          onPrimary: _handleSubmit,
          onBack: widget.onBack,
        ),
        20.h,
      ],
    );
  }
}

class _QuizTypeBadge extends StatelessWidget {
  final String label;

  const _QuizTypeBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.colors.primaryTint,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomText(
        label,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: context.colors.primary,
      ),
    );
  }
}

class _CompletedBadge extends StatelessWidget {
  const _CompletedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.colors.green100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colors.success.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, size: 16, color: context.colors.success),
          6.w,
          CustomText(
            'تکمیل شده',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: context.colors.success,
          ),
        ],
      ),
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border),
        boxShadow: [
          BoxShadow(
            color: context.colors.ink.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText(
            '$index. ${question.text ?? ''}',
            fontSize: 15,
            fontWeight: FontWeight.w600,
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? context.colors.primary : context.colors.border,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomText(
                      options[index],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: context.colors.ink,
                    ),
                  ),
                  12.w,
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? context.colors.primary
                            : context.colors.inkFaint,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: context.colors.primary,
                              ),
                            ),
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
    return OnClick(
      onTap: readOnly ? null : onTap,
      child: Opacity(
        opacity: readOnly ? 0.6 : 1,
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: selected ? context.colors.primaryTint : context.colors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? context.colors.primary : context.colors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: CustomText(
              title,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? context.colors.primary : context.colors.ink,
            ),
          ),
        ),
      ),
    );
  }
}
