import 'package:flutter/material.dart';

import '/widgets/masir_page.dart';

/// Top of every unit screen: a close "X", a thick progress pill and
/// (optionally) the unit title. This is the focus header of [MasirPage].
class UnitTopBar extends StatelessWidget {
  final String title;
  final VoidCallback onClose;
  final num? progress;
  final Widget? trailing;

  const UnitTopBar({
    super.key,
    required this.title,
    required this.onClose,
    this.progress,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return MasirFocusBar(
      title: title,
      onClose: onClose,
      progress: progress,
      trailing: trailing,
    );
  }
}

/// Bottom action area shared by unit screens (the sticky bar of [MasirPage]).
class UnitBottomBar extends StatelessWidget {
  final Widget child;

  const UnitBottomBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) => MasirStickyBar(child: child);
}
