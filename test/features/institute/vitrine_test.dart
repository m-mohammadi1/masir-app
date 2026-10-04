import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mohammad/core/helper/custom_themes.dart';
import 'package:mohammad/core/services/hive_service.dart';
import 'package:mohammad/features/institute/data/models/request_wallet_model.dart';
import 'package:mohammad/features/institute/data/models/wallet_card_model.dart';
import 'package:mohammad/features/institute/domain/entities/wallet_card.dart';
import 'package:mohammad/features/institute/domain/usecases/get_wallet.dart';
import 'package:mohammad/features/institute/presentation/bloc/wallet/wallet_bloc.dart';
import 'package:mohammad/features/institute/presentation/widgets/current_institute_card.dart';
import 'package:mohammad/features/institute/presentation/widgets/membership_card_strip.dart';
import 'package:mohammad/features/main/data/models/main_model.dart';
import 'package:mohammad/features/main/data/models/request_main_model.dart';
import 'package:mohammad/features/main/domain/entities/main.dart';
import 'package:mohammad/features/main/domain/usecases/main_usecase.dart';
import 'package:mohammad/features/main/presentation/bloc/main_bloc.dart';
import 'package:mohammad/features/main/presentation/page/main_page.dart';
import 'package:mohammad/widgets/masir_bottom_bar.dart';

class _FakeWallet implements GetWalletUseCase {
  List<WalletCardModel> cards = const [];

  @override
  get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, List<WalletCardEntity>>> call({
    RequestWalletModel? params,
  }) async => Right(cards);
}

class _FakeMain implements MainUseCase {
  @override
  get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, MainEntity>> call({RequestMainModel? params}) async =>
      const Right(MainModel());
}

const _algebra = WalletCardModel(
  instituteId: 'a',
  name: 'مؤسسه‌ی الف',
  themePreset: 'ocean',
  nextAction: WalletNextAction(
    courseId: 'c1',
    courseTitle: 'جبر',
    unitTitle: 'درس سوم',
    progressPercent: 40,
  ),
);
const _physics = WalletCardModel(instituteId: 'b', name: 'مؤسسه‌ی ب');

Widget _host(Widget child) => MaterialApp(
  theme: light,
  locale: const Locale('fa'),
  builder: (context, c) =>
      Directionality(textDirection: TextDirection.rtl, child: c!),
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

Future<WalletBloc> _walletWith(
  List<WalletCardModel> cards, {
  bool load = true,
}) async {
  final fake = _FakeWallet()..cards = cards;
  final bloc = WalletBloc(getWalletUseCase: fake);
  if (load) {
    bloc.add(const WalletEvent.wallet());
    await bloc.stream.firstWhere(
      (s) => s.maybeWhen(success: (_, _) => true, orElse: () => false),
    );
  }
  return bloc;
}

void main() {
  late Directory dir;

  setUpAll(() async {
    dir = await Directory.systemTemp.createTemp('masir_hive');
    await HiveService.initForTest(dir.path);
  });

  tearDownAll(() async {
    await dir.delete(recursive: true);
  });

  // Hive does real file IO, which needs the real (non-fake) async zone.
  Future<void> storeCurrent(WidgetTester tester, {String id = 'a'}) =>
      tester.runAsync(
        () => HiveService.setCurrentInstitute(
          id: id,
          name: id.isEmpty ? null : 'مؤسسه‌ی الف',
          themePreset: id.isEmpty ? null : 'ocean',
        ),
      );

  testWidgets('pinned card paints from stored data before the wallet loads', (
    tester,
  ) async {
    await storeCurrent(tester);
    final bloc = await _walletWith(const [], load: false);
    await tester.pumpWidget(_host(CurrentInstituteCard(bloc: bloc)));
    expect(find.text('مؤسسه‌ی الف'), findsOneWidget);
    expect(find.text('ورود به مؤسسه'), findsOneWidget);
    expect(find.text('ادامه یادگیری'), findsNothing);
    unawaited(bloc.close());
  });

  testWidgets('pinned card upgrades with wallet progress', (tester) async {
    final bloc = await _walletWith(const [_algebra, _physics]);
    await tester.pumpWidget(_host(CurrentInstituteCard(bloc: bloc)));
    expect(find.text('مؤسسه‌ی الف'), findsOneWidget);
    expect(find.text('درس سوم'), findsOneWidget);
    expect(find.text('ادامه یادگیری'), findsOneWidget);
    expect(find.text('ورود به مؤسسه'), findsOneWidget);
    unawaited(bloc.close());
  });

  testWidgets('pinned card falls back to the first card with progress', (
    tester,
  ) async {
    await storeCurrent(tester, id: '');
    final bloc = await _walletWith(const [_physics, _algebra]);
    await tester.pumpWidget(_host(CurrentInstituteCard(bloc: bloc)));
    expect(find.text('مؤسسه‌ی الف'), findsOneWidget);
    unawaited(bloc.close());
  });

  testWidgets('strip leaves out the pinned institute', (tester) async {
    final bloc = await _walletWith(const [_algebra, _physics]);
    await tester.pumpWidget(
      _host(
        MembershipCardStrip(bloc: bloc, currentInstituteId: 'a', onTap: (_) {}),
      ),
    );
    expect(find.text('مؤسسه‌های دیگر'), findsOneWidget);
    expect(find.text('مؤسسه‌ی ب'), findsWidgets);
    expect(find.text('مؤسسه‌ی الف'), findsNothing);
    unawaited(bloc.close());
  });

  testWidgets('strip is hidden when the current institute is the only one', (
    tester,
  ) async {
    await storeCurrent(tester);
    final bloc = await _walletWith(const [_algebra]);
    await tester.pumpWidget(
      _host(
        MembershipCardStrip(bloc: bloc, currentInstituteId: 'a', onTap: (_) {}),
      ),
    );
    expect(find.text('مؤسسه‌های دیگر'), findsNothing);
    unawaited(bloc.close());
  });

  test('global tab is named ویترین', () {
    expect(masirGlobalTabs().map((t) => t.label), contains('ویترین'));
    expect(masirGlobalTabs().map((t) => t.label), isNot(contains('خانه')));
  });

  group('MainPage back', () {
    setUp(() {
      final it = GetIt.instance;
      if (it.isRegistered<MainBloc>()) it.unregister<MainBloc>();
      it.registerFactory<MainBloc>(() => MainBloc(mainUseCase: _FakeMain()));
    });

    Widget page(VoidCallback onExit) => MaterialApp(
      theme: light,
      locale: const Locale('fa'),
      builder: (context, c) =>
          Directionality(textDirection: TextDirection.rtl, child: c!),
      home: MainPage(
        onExit: onExit,
        pagesOverride: const [
          Text('page-profile'),
          Text('page-wallet'),
          Text('page-vitrine'),
        ],
      ),
    );

    testWidgets('back from another tab returns to ویترین', (tester) async {
      var exited = false;
      await tester.pumpWidget(page(() => exited = true));
      expect(find.text('page-vitrine'), findsOneWidget);

      await tester.tap(find.text('پروفایل'));
      await tester.pump();
      expect(find.text('page-profile'), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(find.text('page-vitrine'), findsOneWidget);
      expect(exited, isFalse);
    });

    testWidgets('a single back on ویترین does not exit; a second one does', (
      tester,
    ) async {
      var exited = false;
      await tester.pumpWidget(page(() => exited = true));

      await tester.binding.handlePopRoute();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(
        find.text('برای خروج دوباره بزن', skipOffstage: false),
        findsOneWidget,
      );
      expect(exited, isFalse);

      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(exited, isTrue);

      await tester.pump(const Duration(seconds: 10));
    });
  });
}
