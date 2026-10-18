import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/app/course/course_brand.dart';
import '/app/routes.dart';
import '/app/unit/quiz_view.dart';
import '/app/state/load_cubit.dart';
import '/app/state/nav.dart';
import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/api/models.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

/// «مرور پاسخ‌ها»: the last attempt, question by question, wrong ones with
/// the right answer and the lesson to look at again.
class QuizReviewPage extends StatefulWidget {
  final String unitId;
  const QuizReviewPage({super.key, required this.unitId});

  @override
  State<QuizReviewPage> createState() => _QuizReviewPageState();
}

class _QuizReviewPageState extends State<QuizReviewPage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) => CourseBrand(
    courseId: '${extraOf(GoRouterState.of(context))['course_id'] ?? ''}',
    child: Scaffold(
      backgroundColor: C.paper,
      body: BlocProvider(
        create: (_) => LoadCubit<QuizReview>(
          () => inject<MasirApi>().quizReview(widget.unitId),
        )..load(),
        child: BlocBuilder<LoadCubit<QuizReview>, Load<QuizReview>>(
          builder: (context, s) {
            final r = s.data;
            final wrong =
                r?.questions.where((q) => !q.correct).toList() ??
                const <ReviewQuestion>[];
            final shown = _tab == 0
                ? (r?.questions ?? const <ReviewQuestion>[])
                : wrong;
            final bottom = MediaQuery.paddingOf(context).bottom;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: C.border, width: 2),
                    ),
                  ),
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PaperHeader(
                        title: 'مرور پاسخ‌ها',
                        subtitle: r == null
                            ? null
                            : '${r.unitTitle} • آخرین تلاش • ${fa(r.correct)} از ${fa(r.total)} درست',
                        onBack: () => back(context),
                      ),
                      if (r != null)
                        ChipRow(
                          soft: true,
                          labels: [
                            'همه • ${fa(r.questions.length)}',
                            'اشتباه‌ها • ${fa(wrong.length)}',
                          ],
                          index: _tab,
                          onChanged: (i) => setState(() => _tab = i),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: r == null
                      ? LoadView<QuizReview>(
                          builder: (_, _) => const SizedBox(),
                        )
                      : shown.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 40),
                            EmptyState(
                              icon: MI.check,
                              title: 'هیچ اشتباهی نداشتی!',
                              body: 'همه‌ی سؤال‌های آخرین تلاشت درست بود.',
                            ),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: shown.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 14),
                          itemBuilder: (_, i) => _QuestionCard(
                            q: shown[i],
                            number: r.questions.indexOf(shown[i]) + 1,
                            reviewUnit: r.reviewUnit,
                          ),
                        ),
                ),
                if (r != null)
                  Container(
                    decoration: const BoxDecoration(
                      color: C.surface,
                      border: Border(
                        top: BorderSide(color: C.border, width: 2),
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 20 + bottom),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 144,
                          child: Btn(
                            'دوباره بده',
                            kind: BtnKind.secondary,
                            icon: MI.retry,
                            height: 56,
                            fontSize: 15,
                            onPressed: () async {
                              if (!await confirmRetake(context)) return;
                              if (!context.mounted) return;
                              // Back to the quiz page under this one, which starts a fresh attempt.
                              if (context.canPop()) {
                                context.pop('retry');
                              } else {
                                context.pushReplacement(
                                  Routes.unit(widget.unitId),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Btn(
                            'ادامه مسیر',
                            height: 56,
                            fontSize: 18,
                            onPressed: () {
                              final cid =
                                  '${extraOf(GoRouterState.of(context))['course_id'] ?? ''}';
                              if (cid.isNotEmpty) {
                                context.go(Routes.roadmap(cid));
                              } else {
                                back(context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    ),
  );
}

class _QuestionCard extends StatelessWidget {
  final ReviewQuestion q;
  final int number;
  final UnitRef? reviewUnit;
  const _QuestionCard({required this.q, required this.number, this.reviewUnit});

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final ok = q.correct;
    Widget answer(String label, String text, bool good) {
      final latin = RegExp(r'^[\x00-\x7F]+$').hasMatch(text);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: good ? C.greenSoft : const Color(0xFFFFF0F0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: T.of(
                14,
                FontWeight.w800,
                good ? C.greenText : C.coralText,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                textDirection: latin ? TextDirection.ltr : null,
                style: T.of(14, FontWeight.w500),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: C.surface,
        border: Border.all(color: ok ? C.border : C.coralBorder, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: ok ? C.green : C.coral,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: MIcon(
                  ok ? MI.check : MI.close,
                  size: ok ? 14 : 12,
                  color: Colors.white,
                  strokeWidth: 3.4,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'سؤال ${fa(number)} • ${ok ? 'درست' : 'نادرست'}',
                style: T.of(
                  13,
                  FontWeight.w800,
                  ok ? C.greenText : C.coralText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(q.text, style: T.of(15, FontWeight.w800, C.ink, 1.8)),
          const SizedBox(height: 10),
          answer('جواب تو:', q.answerText(q.answerBool, q.answerIndex), ok),
          if (!ok) ...[
            const SizedBox(height: 10),
            answer(
              'جواب درست:',
              q.answerText(q.correctBool, q.correctIndex),
              true,
            ),
            if (reviewUnit != null)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: GestureDetector(
                  onTap: () => context.push(Routes.unit(reviewUnit!.id)),
                  child: SizedBox(
                    height: 40,
                    child: Center(
                      widthFactor: 1,
                      child: Text(
                        'مرور ${unitTypeNames[reviewUnit!.type] ?? 'درس'} «${reviewUnit!.title}»',
                        style: T.of(14, FontWeight.w800, pal.ink),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
