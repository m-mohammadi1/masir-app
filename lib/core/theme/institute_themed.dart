import 'package:flutter/material.dart';

import '/core/theme/institute_presets.dart';

/// Re-skins its subtree with an institute's colours (primary, edge and tint
/// only; green, sun and coral keep their meaning).
///
/// Screens pushed on the root navigator sit outside the institute shell's
/// theme, so they wrap themselves in this with the preset they were handed,
/// or the one they load. When [preset] is null the surrounding theme is kept.
class InstituteThemed extends StatelessWidget {
  final String? preset;
  final Widget child;

  const InstituteThemed({super.key, required this.preset, required this.child});

  /// The preset key of the nearest [InstituteThemed], or null in the global
  /// layer. Use it to hand the theme on to routes pushed from here.
  static String? presetOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_PresetScope>()?.preset;

  @override
  Widget build(BuildContext context) {
    final key = preset;
    if (key == null || key.isEmpty) return child;
    final base = Theme.of(context);
    return _PresetScope(
      preset: key,
      child: Theme(
        data: base.copyWith(
          extensions: [instituteColors(key, base.brightness)],
        ),
        child: child,
      ),
    );
  }
}

class _PresetScope extends InheritedWidget {
  final String preset;

  const _PresetScope({required this.preset, required super.child});

  @override
  bool updateShouldNotify(_PresetScope old) => old.preset != preset;
}
