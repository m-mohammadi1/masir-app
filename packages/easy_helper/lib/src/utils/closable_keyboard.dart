import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ClosableKeyBoard extends StatelessWidget {
  final Widget child;

  const ClosableKeyBoard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => close(context),
      child: child,
    );
  }

  static void close(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild!.unfocus();
    }
  }
}

class HandleOpenKeyBoard extends StatefulWidget {
  final ScrollController? controller;

  const HandleOpenKeyBoard({super.key, this.controller});

  @override
  State<HandleOpenKeyBoard> createState() => _HandleOpenKeyBoardState();
}

class _HandleOpenKeyBoardState extends State<HandleOpenKeyBoard> {
  bool _scroll = true;

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isOpen) {
        if (isOpen && _scroll) {
          _scroll = false;
          Future.delayed(Durations.short2).then((value) {
            widget.controller?.animateTo(
              240,
              duration: Durations.short3,
              curve: Curves.easeIn,
            );
          });
        }
        if (!isOpen) {
          _scroll = true;
        }
        return AnimatedContainer(
          duration: Durations.short1,
          height: 1,
          margin: EdgeInsets.only(bottom: isOpen ? 300 : 0),
        );
      },
    );
  }
}
