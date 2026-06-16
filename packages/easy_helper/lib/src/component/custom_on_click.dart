import 'package:flutter/material.dart';

class OnClick extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;

  const OnClick({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      // borderRadius: BorderRadius.circular(8),
      child: child,
    );
  }
}
