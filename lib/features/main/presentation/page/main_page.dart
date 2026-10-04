import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/institute/presentation/page/main_feed_page.dart';
import 'package:mohammad/features/institute/presentation/page/wallet_page.dart';
import 'package:mohammad/features/main/presentation/bloc/main_bloc.dart';
import 'package:mohammad/features/profile/presentation/page/profile_page.dart';
import '/widgets/masir_bottom_bar.dart';
import '/core/theme/theme_context.dart';

class MainPage extends StatefulWidget {
  static const String routeName = "/";

  /// Leaves the app. Overridable so tests don't hit the platform channel.
  final VoidCallback? onExit;

  /// Replaces the three tab pages (ProfilePage, WalletPage, MainFeedPage in
  /// that order); only for tests.
  @visibleForTesting
  final List<Widget>? pagesOverride;

  const MainPage({super.key, this.onExit, this.pagesOverride});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  /// ویترین, the landing tab.
  static const int _vitrineIndex = 2;

  /// A second back press inside this window leaves the app.
  static const Duration _exitWindow = Duration(seconds: 2);

  int index = _vitrineIndex;
  DateTime? _lastBack;

  final bloc = inject<MainBloc>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
    });
    bloc.add(MainEvent.main());
  }

  /// Back always has one meaning: from another tab it returns to ویترین; from
  /// ویترین it needs a second press to leave, so a stray swipe never exits.
  void _onBack() {
    if (index != _vitrineIndex) {
      setState(() => index = _vitrineIndex);
      return;
    }
    final now = DateTime.now();
    final last = _lastBack;
    if (last != null && now.difference(last) < _exitWindow) {
      (widget.onExit ?? SystemNavigator.pop)();
      return;
    }
    _lastBack = now;
    CustomToast.toast(context, 'برای خروج دوباره بزن', type: Type.info);
  }

  @override
  Widget build(BuildContext context) {
    final pages =
        widget.pagesOverride ??
        const [ProfilePage(), WalletPage(), MainFeedPage()];
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _onBack();
      },
      canPop: false,
      child: Scaffold(
        backgroundColor: context.colors.background,
        body: Column(
          children: [
            Expanded(child: pages[index]),
            MasirBottomBar(
              currentIndex: index,
              onTap: (value) => setState(() => index = value),
              items: masirGlobalTabs(),
            ),
          ],
        ),
      ),
    );
  }
}
