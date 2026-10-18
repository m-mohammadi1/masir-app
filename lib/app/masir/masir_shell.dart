import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/app/state/session.dart';
import '/design/design.dart';

/// The Masir space: always violet, three tabs (ویترین، مؤسسات من، پروفایل).
class MasirShell extends StatefulWidget {
  final StatefulNavigationShell shell;
  const MasirShell({super.key, required this.shell});

  @override
  State<MasirShell> createState() => _MasirShellState();
}

class _MasirShellState extends State<MasirShell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => Session.exitToMasir());
  }

  @override
  Widget build(BuildContext context) => BrandScope(
    brand: Brand.masir,
    // Android back on «مؤسسات من» or «پروفایل» goes to «ویترین» first;
    // only back on «ویترین» leaves the app.
    child: PopScope(
      canPop: widget.shell.currentIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) widget.shell.goBranch(0);
      },
      child: Scaffold(
        backgroundColor: C.paper,
        body: widget.shell,
        bottomNavigationBar: SpaceTabBar(
          items: masirTabs,
          index: widget.shell.currentIndex,
          onTap: (i) => widget.shell.goBranch(
            i,
            initialLocation: i == widget.shell.currentIndex,
          ),
        ),
      ),
    ),
  );
}
