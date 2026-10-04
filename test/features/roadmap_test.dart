import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mohammad/core/helper/custom_themes.dart';
import 'package:mohammad/features/main/data/models/outline_course_model.dart';
import 'package:mohammad/features/main/data/models/request_outline_course_model.dart';
import 'package:mohammad/features/main/data/models/request_subscribe_course_model.dart';
import 'package:mohammad/features/main/data/models/subscribe_course_model.dart';
import 'package:mohammad/features/main/domain/entities/subscribe_course.dart';
import 'package:mohammad/features/main/domain/usecases/subscribe_course_usecase.dart';
import 'package:mohammad/features/main/presentation/bloc/subscribe_course/subscribe_course_bloc.dart';
import 'package:mohammad/features/main/domain/entities/outline_course.dart';
import 'package:mohammad/features/main/domain/usecases/outline_course_usecase.dart';
import 'package:mohammad/features/main/presentation/bloc/outline_course/outline_course_bloc.dart';
import 'package:mohammad/features/main/presentation/page/outline_page.dart';

class _FakeOutlineUseCase implements OutlineCourseUseCase {
  @override
  // ignore: unnecessary_overrides
  get repository => throw UnimplementedError();

  static int calls = 0;
  static OutlineCourseEntity fixture = _fixture;

  @override
  Future<Either<Failure, OutlineCourseEntity>> call({
    RequestOutlineCourseModel? params,
  }) async {
    calls++;
    return Right(fixture);
  }
}

class _FakeSubscribeUseCase implements SubscribeCourseUseCase {
  static final subscribed = <String?>[];

  @override
  get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, SubscribeCourseEntity>> call({
    RequestSubscribeCourseModel? params,
  }) async {
    subscribed.add(params?.id);
    return const Right(SubscribeCourseModel(id: 's1', courseId: 'course-1'));
  }
}

const _fixture = OutlineCourseModel(
  id: 'course-1',
  title: 'دوره',
  courseProgressPercent: 40,
  previewUnitCount: 1,
  modules: [
    OutlineModuleModel(
      id: 'm1',
      title: 'فصل اول',
      paths: [
        OutlinePathModel(
          id: 'p1',
          title: 'مسیر اول',
          pathProgressPercent: 33,
          units: [
            OutlineUnitModel(
              id: 'u1',
              title: 'درس اول',
              type: 'html',
              status: 'completed',
              locked: false,
            ),
            OutlineUnitModel(
              id: 'u2',
              title: 'ویدیو',
              type: 'video',
              status: 'not_started',
              locked: false,
              isPreview: true,
            ),
            OutlineUnitModel(
              id: 'u3',
              title: 'آزمون',
              type: 'quiz',
              status: 'not_started',
              locked: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

// Heights of the flat waypoint list, unchanged by the restyle:
// chapter 76, path 118, unit 118.
const _unitPitch = 118.0;
const _pinFaceRadius = 32.0;

Offset _faceCenter(WidgetTester tester, String unitId) {
  final rect = tester.getRect(find.byKey(ValueKey('roadmap-pin-$unitId')));
  return Offset(rect.center.dx, rect.top + _pinFaceRadius);
}

void main() {
  setUp(() {
    final getIt = GetIt.instance;
    if (getIt.isRegistered<OutlineCourseBloc>()) getIt.reset();
    getIt.registerFactory<OutlineCourseBloc>(
      () => OutlineCourseBloc(outlineCourseUseCase: _FakeOutlineUseCase()),
    );
    getIt.registerFactory<SubscribeCourseBloc>(
      () =>
          SubscribeCourseBloc(subscribeCourseUseCase: _FakeSubscribeUseCase()),
    );
    _FakeOutlineUseCase.calls = 0;
    _FakeOutlineUseCase.fixture = _fixture;
    _FakeSubscribeUseCase.subscribed.clear();
  });

  tearDown(() => GetIt.instance.reset());

  for (final mode in {'light': light, 'dark': dark}.entries) {
    for (final preset in ['violet', 'ocean']) {
      testWidgets('roadmap renders and keeps its layout '
          '(${mode.key}, $preset)', (tester) async {
        tester.view.physicalSize = const Size(390 * 3, 844 * 3);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            theme: mode.value,
            locale: const Locale('fa'),
            builder: (context, c) =>
                Directionality(textDirection: TextDirection.rtl, child: c!),
            home: OutlinePage(
              title: 'دوره',
              id: 'course-1',
              themePreset: preset,
            ),
          ),
        );
        // The current unit's ring pulses forever, so never settle.
        for (var i = 0; i < 40; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
        expect(tester.takeException(), isNull);

        final u1 = _faceCenter(tester, 'u1');
        final u2 = _faceCenter(tester, 'u2');
        final u3 = _faceCenter(tester, 'u3');

        // Same vertical pitch between consecutive waypoints as before.
        expect(u2.dy - u1.dy, closeTo(_unitPitch, 0.5));
        expect(u3.dy - u2.dy, closeTo(_unitPitch, 0.5));

        // Units alternate sides of the trail (path is left, u1 right ...).
        const canvasWidth = 390 - 2 * 12.0;
        const inset = 12.0;
        // The finish medallion sits on the trail's centre line.
        expect(
          tester.getCenter(find.byKey(const ValueKey('roadmap-finish'))).dx,
          closeTo(inset + canvasWidth / 2, 0.5),
        );

        expect(u1.dx, greaterThan(inset + canvasWidth * 0.60));
        expect(u2.dx, lessThan(inset + canvasWidth * 0.40));
        expect(u3.dx, greaterThan(inset + canvasWidth * 0.60));
        expect(u1.dx, closeTo(inset + canvasWidth * 0.70, canvasWidth * 0.06));
        expect(u2.dx, closeTo(inset + canvasWidth * 0.30, canvasWidth * 0.06));
      });
    }
  }

  testWidgets('"ثبت‌نام" joins the course and reloads the roadmap', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: light,
        locale: const Locale('fa'),
        builder: (context, c) =>
            Directionality(textDirection: TextDirection.rtl, child: c!),
        home: const OutlinePage(title: 'دوره', id: 'course-1'),
      ),
    );
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(_FakeOutlineUseCase.calls, 1);
    expect(find.text('ثبت‌نام'), findsOneWidget);

    await tester.tap(find.text('ثبت‌نام'));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(_FakeSubscribeUseCase.subscribed, ['course-1']);
    expect(_FakeOutlineUseCase.calls, 2);
    // Once joined, the free-start prompt never shows again.
    expect(find.text('ثبت‌نام'), findsNothing);

    // Let the toast's auto-dismiss timer finish.
    await tester.pump(const Duration(seconds: 6));
  });

  testWidgets('shows progress counts and a continue bar for the current unit', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    _FakeOutlineUseCase.fixture = const OutlineCourseModel(
      id: 'course-1',
      title: 'دوره',
      isSubscribed: true,
      modules: [
        OutlineModuleModel(
          id: 'm1',
          title: 'فصل اول',
          paths: [
            OutlinePathModel(
              id: 'p1',
              title: 'مسیر اول',
              units: [
                OutlineUnitModel(
                  id: 'u1',
                  title: 'درس اول',
                  type: 'html',
                  status: 'completed',
                  locked: false,
                ),
                OutlineUnitModel(
                  id: 'u2',
                  title: 'ویدیو',
                  type: 'video',
                  status: 'not_started',
                  locked: false,
                ),
                OutlineUnitModel(
                  id: 'u3',
                  title: 'آزمون',
                  type: 'quiz',
                  status: 'not_started',
                  locked: true,
                ),
              ],
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: light,
        locale: const Locale('fa'),
        builder: (context, c) =>
            Directionality(textDirection: TextDirection.rtl, child: c!),
        home: const OutlinePage(title: 'دوره', id: 'course-1'),
      ),
    );
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('۱ از ۳ واحد'), findsOneWidget);
    expect(find.text('ادامه یادگیری'), findsOneWidget);
    expect(find.text('ثبت‌نام'), findsNothing);
  });

  test('path-completed notice names the path and its size', () {
    final path = pathCompletedNotice(
      pathTitle: 'مسیر اول',
      unitCount: 3,
      chapterDone: false,
      courseDone: false,
    );
    expect(path.title, 'این مسیر کامل شد!');
    expect(path.message, 'مسیر اول · ۳ واحد تموم شد');
    expect(path.icon, Icons.workspace_premium_rounded);

    final chapter = pathCompletedNotice(
      pathTitle: '',
      unitCount: 2,
      chapterDone: true,
      courseDone: false,
    );
    expect(chapter.title, 'یک فصل کامل شد!');
    expect(chapter.message, '۲ واحد تموم شد');

    final course = pathCompletedNotice(
      pathTitle: 'x',
      unitCount: 0,
      chapterDone: true,
      courseDone: true,
    );
    expect(course.title, 'دوره رو تموم کردی!');
    expect(course.message, 'x');
    expect(course.icon, Icons.emoji_events_rounded);
  });

  testWidgets('a course with no free preview still offers "ثبت‌نام"', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    _FakeOutlineUseCase.fixture = const OutlineCourseModel(
      id: 'course-1',
      title: 'دوره',
      modules: [
        OutlineModuleModel(
          id: 'm1',
          title: 'فصل اول',
          paths: [
            OutlinePathModel(
              id: 'p1',
              title: 'مسیر اول',
              units: [
                OutlineUnitModel(
                  id: 'u1',
                  title: 'درس اول',
                  type: 'html',
                  status: 'not_started',
                  locked: true,
                ),
              ],
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: light,
        locale: const Locale('fa'),
        builder: (context, c) =>
            Directionality(textDirection: TextDirection.rtl, child: c!),
        home: const OutlinePage(title: 'دوره', id: 'course-1'),
      ),
    );
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('ثبت‌نام'), findsOneWidget);
    expect(find.text('برای شروع این دوره ثبت‌نام کن'), findsOneWidget);
  });
}
