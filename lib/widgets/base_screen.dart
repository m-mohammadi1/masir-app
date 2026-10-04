import 'package:flutter/material.dart';

import '/core/theme/masir_style.dart';
import '/widgets/masir_page.dart';

/// Legacy wrapper kept for screens that draw their own header. It now just
/// delegates to [MasirPage] (real safe area, one gutter, keyboard handling).
/// New screens should use `MasirPage.tab/detail/focus` directly.
class BaseScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return MasirPage.plain(
      backgroundColor: backgroundColor,
      floatingActionButton: floatActionButton,
      body: padding == null
          ? body
          : Padding(
              // Cancel the page gutter, then apply the caller's padding.
              padding: padding! - MasirSpace.pageH,
              child: body,
            ),
    );
  }
}
