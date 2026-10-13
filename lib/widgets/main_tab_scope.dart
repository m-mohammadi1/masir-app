import 'package:flutter/widgets.dart';

/// Tells a main tab page whether it is the visible tab.
///
/// The main page keeps tabs alive once opened, so a tab coming back into view
/// can refresh its data (see [MainTabRefresh]) instead of being rebuilt from
/// scratch.
class MainTabScope extends InheritedWidget {
  final bool active;

  const MainTabScope({super.key, required this.active, required super.child});

  /// Whether the tab around [context] is visible. True outside a main page.
  static bool isActive(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MainTabScope>()?.active ??
      true;

  @override
  bool updateShouldNotify(MainTabScope oldWidget) => active != oldWidget.active;
}

/// For a tab page's `State`: call [tabBecameActive] from
/// `didChangeDependencies`; it is true when the tab is shown again after being
/// hidden (not on first build).
mixin MainTabRefresh<T extends StatefulWidget> on State<T> {
  bool? _wasActive;

  bool tabBecameActive() {
    final active = MainTabScope.isActive(context);
    final returned = _wasActive == false && active;
    _wasActive = active;
    return returned;
  }
}

/// `buildWhen` for a tab's list: a reload keeps the loaded content on screen
/// instead of flashing the skeleton; the fresh data swaps in when it arrives.
bool keepContentWhileReloading({
  required bool previousHasContent,
  required bool currentIsLoading,
}) => !(previousHasContent && currentIsLoading);
