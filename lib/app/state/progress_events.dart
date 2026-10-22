import 'package:flutter/widgets.dart';

import '/app/state/route_settle.dart';

/// Fired when a unit counts (completed, quiz sent, offline completions sent).
/// Pages that stay alive underneath the unit (roadmap, course, Vitrine,
/// institute home) reload on it, so they're current when the student comes
/// back, however the unit page was left (back, next unit, replaced).
class ProgressEvents {
  ProgressEvents._();

  static final changed = ValueNotifier<int>(0);

  static void notify() => changed.value++;
}

/// Calls [onChange] whenever progress changes while this page is alive.
class ReloadOnProgress extends StatefulWidget {
  final VoidCallback onChange;
  final Widget child;
  const ReloadOnProgress({
    super.key,
    required this.onChange,
    required this.child,
  });

  @override
  State<ReloadOnProgress> createState() => _ReloadOnProgressState();
}

class _ReloadOnProgressState extends State<ReloadOnProgress> {
  @override
  void initState() {
    super.initState();
    ProgressEvents.changed.addListener(_changed);
  }

  @override
  void dispose() {
    ProgressEvents.changed.removeListener(_changed);
    super.dispose();
  }

  /// The event fires as the next unit slides in; reload once it has, so
  /// the requests and rebuilds stay out of the slide.
  Future<void> _changed() async {
    if (!mounted) return;
    await afterTransitions(context);
    if (mounted) widget.onChange();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
