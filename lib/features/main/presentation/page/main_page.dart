import 'package:flutter/material.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/institute/presentation/page/main_feed_page.dart';
import 'package:mohammad/features/institute/presentation/page/wallet_page.dart';
import 'package:mohammad/features/main/presentation/bloc/main_bloc.dart';
import 'package:mohammad/features/profile/presentation/page/profile_page.dart';
import '/widgets/masir_bottom_bar.dart';
import '/core/theme/theme_context.dart';

class MainPage extends StatefulWidget {
  static const String routeName = "/";

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 2;

  final bloc = inject<MainBloc>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
    });
    bloc.add(MainEvent.main());
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const ProfilePage(),
      const WalletPage(),
      const MainFeedPage(),
    ];
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (index == 0) {
          setState(() {
            index = 2;
          });
        } else {
          Navigator.pop(context);
        }
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
