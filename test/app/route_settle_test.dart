import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/app/state/load_cubit.dart';
import 'package:mohammad/app/state/route_settle.dart';
import 'package:mohammad/core/api/masir_api.dart';

void main() {
  testWidgets('settled straight away when nothing is moving', (tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (c) {
            ctx = c;
            return const SizedBox();
          },
        ),
      ),
    );
    var done = false;
    routeSettled(ctx).then((_) => done = true);
    await tester.pump();
    expect(done, isTrue);
  });

  testWidgets('waits for the page to finish sliding in', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    late BuildContext ctx;
    tester
        .state<NavigatorState>(find.byType(Navigator))
        .push(
          MaterialPageRoute<void>(
            builder: (c) {
              ctx = c;
              return const SizedBox();
            },
          ),
        );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    var done = false;
    routeSettled(ctx).then((_) => done = true);
    await tester.pump(const Duration(milliseconds: 50));
    expect(done, isFalse, reason: 'the push is still running');

    await tester.pumpAndSettle();
    expect(done, isTrue);
  });

  testWidgets('LoadView keeps the skeleton until the push is over', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    tester
        .state<NavigatorState>(find.byType(Navigator))
        .push(
          MaterialPageRoute<void>(
            builder: (_) => Scaffold(
              body: BlocProvider(
                create: (_) => LoadCubit<String>(
                  () async => const Right<ApiError, String>('درس'),
                )..load(),
                child: LoadView<String>(
                  skeleton: const Text('اسکلت'),
                  builder: (_, d) => Text(d),
                ),
              ),
            ),
          ),
        );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    expect(find.text('اسکلت'), findsOneWidget);
    expect(find.text('درس'), findsNothing, reason: 'data waits for the slide');

    await tester.pumpAndSettle();
    expect(find.text('درس'), findsOneWidget);
    expect(find.text('اسکلت'), findsNothing);
  });
}
