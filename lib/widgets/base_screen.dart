import 'package:easy_helper/easy_helper.dart';

import '/core/helper/custom_colors.dart';
import 'package:flutter/material.dart';

class BaseScreen extends StatefulWidget {
  final Widget body;
  final Widget? floatActionButton;
  final Color? backgroundColor;
  final EdgeInsets? padding;

  const BaseScreen({
    super.key,
    required this.body,
    this.floatActionButton,
    this.backgroundColor,
    this.padding,
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
        backgroundColor: widget.backgroundColor ?? AppColor.background,
        drawerEnableOpenDragGesture: false,
        floatingActionButton: widget.floatActionButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            45.h,
            Expanded(
              child: Padding(
                padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 16),
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
