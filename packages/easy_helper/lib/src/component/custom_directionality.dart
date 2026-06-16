import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart' as intl;

class CustomDirectionality extends StatelessWidget {
  final bool isPersian;
  final Widget child;

  const CustomDirectionality({
    super.key,
    required this.child,
    required this.isPersian,
  });

  bool _isRTL(String? text) {
    return intl.Bidi.detectRtlDirectionality(text ?? "");
  }

  ui.TextDirection direction(String? text) {
    return _isRTL(text) ? ui.TextDirection.rtl : ui.TextDirection.ltr;
  }

  TextAlign get textAlign {
    return isPersian ? TextAlign.right : TextAlign.left;
  }

  ui.TextDirection get _direction =>
      isPersian ? ui.TextDirection.ltr : ui.TextDirection.rtl;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _direction,
      child: child,
    );
  }
}
