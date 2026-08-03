import '/core/helper/custom_colors.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/features/main/data/models/quiz_submit_model.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/quiz/presentation/page/quiz_layout_helper.dart';
import 'package:mohammad/widgets/custom_app_bar.dart';
import 'package:mohammad/widgets/custom_button.dart';
import 'package:mohammad/widgets/custom_text.dart';

class QuizResultContent extends StatelessWidget {
  final UnitsModel data;
  final QuizSubmitResponseModel result;
  final Map<String, dynamic> userAnswers;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  const QuizResultContent({
    super.key,
    required this.data,
    required this.result,
    required this.userAnswers,
    required this.onRetry,
    required this.onBack,
  });

  List<UnitsQuestionModel> get _questions =>
      (data.payload?.questions ?? []).cast<UnitsQuestionModel>();

  int? get _passThreshold => data.payload?.passThreshold;

  bool? _isCorrect(String questionId) {
    final results = result.results ?? [];
    for (final item in results) {
      if (item.questionId == questionId) {
        return item.correct;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final title = data.title ?? '';
    final passed = result.passed ?? false;
    final score = result.score ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomAppBar(title: title),
        16.h,
        Row(children: [_QuizTypeBadge(label: data.type ?? 'quiz')]),
        12.h,
        Row(
          children: [
            _InfoChip(label: 'نمره: $score٪'),
            const Spacer(),
            if (_passThreshold != null)
              CustomText(
                'حد نصاب: $_passThreshold٪',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColor.inkMuted,
              ),
          ],
        ),
        16.h,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: AppColor.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.border),
          ),
          child: Center(
            child: CustomText(
              passed ? 'قبول شدید' : 'قبول نشدید',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.ink,
            ),
          ),
        ),
        16.h,
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: _questions.length,
            separatorBuilder: (_, __) => 12.h,
            itemBuilder: (context, index) {
              final question = _questions[index];
              final questionId = question.id ?? '';
              return _ResultQuestionCard(
                index: index + 1,
                question: question,
                isCorrect: _isCorrect(questionId),
                userAnswer: userAnswers[questionId],
              );
            },
          ),
        ),
        16.h,
        if (!passed) CustomButton(title: 'تلاش مجدد', onTap: onRetry),
        if (!passed) 12.h,
        OnClick(
          onTap: onBack,
          child: Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColor.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColor.border),
            ),
            child: CustomText(
              'بازگشت به مسیر',
              color: AppColor.ink,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        20.h,
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.borderF9,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomText(
        label,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColor.inkMuted,
      ),
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
        color: AppColor.primaryTint,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomText(
        label,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColor.primary,
      ),
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

  @override
  Widget build(BuildContext context) {
    final layoutType = quizLayoutTypeFromQuestion(question.type);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border),
        boxShadow: [
          BoxShadow(
            color: AppColor.ink.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (isCorrect != null) _ResultBadge(isCorrect: isCorrect!),
            ],
          ),
          12.h,
          CustomText(
            '$index. ${question.text ?? ''}',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColor.ink,
          ),
          16.h,
          switch (layoutType) {
            QuizLayoutType.trueFalse => _ResultTrueFalseOptions(
              selectedValue: userAnswer is bool ? userAnswer as bool : null,
            ),
            QuizLayoutType.multiChoice => _ResultMultiChoiceOptions(
              options: question.options ?? [],
              selectedIndex: userAnswer is int ? userAnswer as int : null,
            ),
            _ => const SizedBox.shrink(),
          },
        ],
      ),
    );
  }
}

class _ResultBadge extends StatelessWidget {
  final bool isCorrect;

  const _ResultBadge({required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppColor.success.withValues(alpha: 0.95)
            : AppColor.borderF9,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomText(
        isCorrect ? 'درست' : 'نادرست',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isCorrect ? AppColor.white : AppColor.inkMuted,
      ),
    );
  }
}

class _ResultTrueFalseOptions extends StatelessWidget {
  final bool? selectedValue;

  const _ResultTrueFalseOptions({required this.selectedValue});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ResultOptionButton(
            title: 'درست',
            selected: selectedValue == true,
          ),
        ),
        12.w,
        Expanded(
          child: _ResultOptionButton(
            title: 'نادرست',
            selected: selectedValue == false,
          ),
        ),
      ],
    );
  }
}

class _ResultMultiChoiceOptions extends StatelessWidget {
  final List<String> options;
  final int? selectedIndex;

  const _ResultMultiChoiceOptions({
    required this.options,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(options.length, (index) {
        final optionNumber = index + 1;
        final isSelected = selectedIndex == optionNumber;
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == options.length - 1 ? 0 : 10,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColor.primaryTint : AppColor.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColor.primary : AppColor.border,
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
                    color: AppColor.ink,
                  ),
                ),
                12.w,
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColor.primary : AppColor.inkFaint,
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
                              color: AppColor.primary,
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _ResultOptionButton extends StatelessWidget {
  final String title;
  final bool selected;

  const _ResultOptionButton({required this.title, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: selected ? AppColor.primary : AppColor.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? AppColor.primary : AppColor.border,
        ),
      ),
      child: Center(
        child: CustomText(
          title,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: selected ? AppColor.white : AppColor.ink,
        ),
      ),
    );
  }
}
