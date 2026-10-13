import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mohammad/core/helper/open_institute.dart';

// Mirrors the app's institute shell: one ShellRoute (one nested navigator
// GlobalKey) whose page key is the same for every institute.
GoRouter _router() => GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (c, s) => const Text('main')),
    GoRoute(path: '/teachers/:id', builder: (c, s) => const Text('teacher')),
    ShellRoute(
      pageBuilder: (c, s, child) => CustomTransitionPage<void>(
        key: const ValueKey('institute-shell'),
        child: child,
        transitionsBuilder: (c, a, b, w) => w,
      ),
      routes: [
        GoRoute(path: '/i/:instituteId/home', builder: (c, s) => Text('home ${s.pathParameters['instituteId']}')),
      ],
    ),
  ],
);

void main() {
  testWidgets('reopening an institute on the stack does not crash', (tester) async {
    final router = _router();
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    openInstitute('A', router: router);
    await tester.pumpAndSettle();
    router.push('/teachers/1');
    await tester.pumpAndSettle();
    expect(isInstituteOnStack(router, 'A'), isTrue);
    expect(isInstituteOnStack(router, 'B'), isFalse);
    expect(isInstituteOnStack(router), isTrue);
    openInstitute('A', router: router);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('home A'), findsOneWidget);
  });

  testWidgets('another institute over an open one replaces it', (tester) async {
    final router = _router();
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    openInstitute('A', router: router);
    await tester.pumpAndSettle();
    router.push('/teachers/1');
    await tester.pumpAndSettle();
    openInstitute('B', router: router);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('home B'), findsOneWidget);
  });

  testWidgets('with no institute open it pushes, so back returns', (tester) async {
    final router = _router();
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    router.push('/teachers/1');
    await tester.pumpAndSettle();
    openInstitute('B', router: router);
    await tester.pumpAndSettle();
    expect(find.text('home B'), findsOneWidget);
    router.pop();
    await tester.pumpAndSettle();
    expect(find.text('teacher'), findsOneWidget);
  });

  testWidgets('go between institutes swaps without crashing', (tester) async {
    final router = _router();
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    router.go('/i/A/home');
    await tester.pumpAndSettle();
    router.go('/i/B/home');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('home B'), findsOneWidget);
  });
}
