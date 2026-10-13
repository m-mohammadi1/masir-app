import 'package:flutter/widgets.dart';

/// Where on screen the unit page opens from: the roadmap pin the student
/// tapped. The unit route grows out of that point and shrinks back into it.
///
/// The roadmap sets the point just before pushing; the route claims it for
/// its page the first time it builds. go_router rebuilds pages, so the point
/// is kept per page key and the closing animation still finds it.
class UnitOrigin {
  UnitOrigin._();

  static Offset? _pending;
  static final Map<LocalKey, Offset?> _byPage = {};

  /// Called by the roadmap before opening a unit (null: no known point).
  static void set(Offset? origin) => _pending = origin;

  /// The origin for the page with [key], claiming the pending one on first
  /// use. Null when the page wasn't opened from a pin (refresh, deep link).
  static Offset? forPage(LocalKey key) {
    if (!_byPage.containsKey(key)) {
      _byPage[key] = _pending;
      _pending = null;
      if (_byPage.length > 16) _byPage.remove(_byPage.keys.first);
    }
    return _byPage[key];
  }
}
