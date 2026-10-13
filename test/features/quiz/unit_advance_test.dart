import 'package:dartz/dartz.dart' hide State;
import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mohammad/core/helper/custom_themes.dart';
import 'package:mohammad/features/main/data/models/outline_course_model.dart';
import 'package:mohammad/features/main/data/models/quiz_submit_model.dart';
import 'package:mohammad/features/main/data/models/request_outline_course_model.dart';
import 'package:mohammad/features/main/data/models/request_quiz_submit_model.dart';
import 'package:mohammad/features/main/data/models/request_units_model.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/main/domain/entities/outline_course.dart';
import 'package:mohammad/features/main/domain/entities/quiz_submit.dart';
import 'package:mohammad/features/main/domain/entities/units.dart';
import 'package:mohammad/features/main/domain/usecases/outline_course_usecase.dart';
import 'package:mohammad/features/main/domain/usecases/quiz_submit_usecase.dart';
import 'package:mohammad/features/main/domain/usecases/units_usecase.dart';
import 'package:mohammad/features/main/presentation/bloc/quiz_submit/quiz_submit_bloc.dart';
import 'package:mohammad/features/main/presentation/bloc/units/units_bloc.dart';
import 'package:mohammad/features/quiz/presentation/page/unit_page.dart';

// One path: lesson, quiz, quiz, lesson.
const _units = {
  'u1': UnitsModel(
    id: 'u1',
    title: 'درس اول',
    type: 'html',
    courseId: 'c1',
    payload: UnitsPayloadModel(body: '<p>متن درس</p>'),
  ),
  'u2': UnitsModel(
    id: 'u2',
    title: 'آزمون اول',
    type: 'quiz',
    courseId: 'c1',
    payload: UnitsPayloadModel(
      questions: [
        UnitsQuestionModel(id: 'q1', type: 'true_false', text: 'درسته؟'),
      ],
    ),
  ),
  'u3': UnitsModel(
    id: 'u3',
    title: 'آزمون دوم',
    type: 'quiz',
    courseId: 'c1',
    payload: UnitsPayloadModel(
      questions: [
        UnitsQuestionModel(id: 'q2', type: 'true_false', text: 'درسته؟'),
      ],
    ),
  ),
};

class _FakeUnits implements UnitsUseCase {
  @override
  get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, UnitsEntity>> call({
    RequestUnitsModel? params,
  }) async => Right(_units[params!.id]!);
}

class _FakeSubmit implements QuizSubmitUseCase {
  @override
  get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, QuizSubmitResponseEntity>> call({
    RequestQuizSubmitModel? params,
  }) async => const Right(QuizSubmitResponseModel(passed: true, score: 100));
}

class _FakeOutline implements OutlineCourseUseCase {
  @override
  get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, OutlineCourseEntity>> call({
    RequestOutlineCourseModel? params,
  }) async => const Right(
    OutlineCourseModel(
      id: 'c1',
      modules: [
        OutlineModuleModel(
          id: 'm1',
          paths: [
            OutlinePathModel(
              id: 'p1',
              units: [
                OutlineUnitModel(id: 'u1', type: 'html', locked: false),
                OutlineUnitModel(id: 'u2', type: 'quiz', locked: false),
                OutlineUnitModel(id: 'u3', type: 'quiz', locked: false),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

void main() {
  setUp(() {
    final it = GetIt.instance;
    it.registerFactory<UnitsBloc>(() => UnitsBloc(unitsUseCase: _FakeUnits()));
    it.registerFactory<QuizSubmitBloc>(
      () => QuizSubmitBloc(quizSubmitUseCase: _FakeSubmit()),
    );
    it.registerFactory<OutlineCourseUseCase>(() => _FakeOutline());
  });

  tearDown(() => GetIt.instance.reset());

  /// Pumps frame by frame through a unit switch, so a duplicate key thrown
  /// mid-transition is caught.
  Future<void> pumpThroughTransition(WidgetTester tester) async {
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 50));
      expect(tester.takeException(), isNull);
    }
  }

  testWidgets('moving from a lesson to a quiz, then to another quiz, never '
      'shows two copies of a quiz', (tester) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: light,
        locale: const Locale('fa'),
        builder: (context, c) =>
            Directionality(textDirection: TextDirection.rtl, child: c!),
        home: const UnitPage(unitId: 'u1', unitType: 'html'),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(find.text('درس اول'), findsWidgets);

    // Lesson -> quiz.
    await tester.tap(find.text('خوندم'));
    await pumpThroughTransition(tester);
    expect(find.text('آزمون اول'), findsWidgets);

    // Answer and pass the quiz, then continue to the next quiz.
    await tester.tap(find.text('درست').first);
    await tester.pump();
    await tester.tap(find.text('ارسال پاسخ'));
    await pumpThroughTransition(tester);
    await tester.tap(find.text('ادامه مسیر'));
    await pumpThroughTransition(tester);
    expect(find.text('آزمون دوم'), findsWidgets);

    // Let the "next lesson" toasts time out.
    await tester.pump(const Duration(seconds: 10));
  });
}
