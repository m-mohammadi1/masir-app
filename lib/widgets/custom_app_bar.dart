import 'package:flutter/material.dart';

import '/widgets/masir_page.dart';

/// Compact detail header. Prefer `MasirPage.detail`, which includes it; this
/// stays for screens that compose their own body.
class CustomAppBar extends StatelessWidget {
  final String title;
  final Widget? icon;
  final Function? backAction;

  const CustomAppBar({
    super.key,
    required this.title,
    this.icon,
    this.backAction,
    @Deprecated('Spacing is handled by MasirPage') double topSpacing = 0,
  });

  @override
  Widget build(BuildContext context) {
    return MasirDetailBar(
      title: title,
      trailing: icon,
      onBack: backAction == null ? null : () => backAction!(),
    );
  }
}
