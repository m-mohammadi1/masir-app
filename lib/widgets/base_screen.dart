import 'package:easy_helper/easy_helper.dart';

import '/core/helper/paper_surface.dart';
import 'package:flutter/material.dart';
import '/core/theme/theme_context.dart';

class BaseScreen extends StatefulWidget {
  final Widget body;
  final Widget? floatActionButton;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final bool usePaperGrain;

  const BaseScreen({
    super.key,
    required this.body,
    this.floatActionButton,
    this.backgroundColor,
    this.padding,
    this.usePaperGrain = true,
  });

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClosableKeyBoard(
      child: Scaffold(
        key: _key,
        drawerScrimColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        backgroundColor: widget.backgroundColor ?? context.colors.background,
        drawerEnableOpenDragGesture: false,
        floatingActionButton: widget.floatActionButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            45.h,
            Expanded(
              child: widget.usePaperGrain
                  ? PaperBackdrop(
                      child: Padding(
                        padding:
                            widget.padding ??
                            const EdgeInsets.symmetric(horizontal: 16),
                        child: widget.body,
                      ),
                    )
                  : Padding(
                      padding:
                          widget.padding ??
                          const EdgeInsets.symmetric(horizontal: 16),
                      child: widget.body,
                    ),
            ),
            HandleOpenKeyBoard(),
          ],
        ),
      ),
    );
  }
}
