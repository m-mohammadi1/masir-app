/// Route arguments that carry an institute theme preset along with the usual
/// payload, so screens opened from inside an institute keep its colours.
const String kThemePresetArg = 'themePreset';

/// Arguments for the course detail route. Stays a plain `String` when there is
/// no preset, so older call sites keep working.
Object courseDetailArgs(String id, {String? themePreset}) =>
    (themePreset == null || themePreset.isEmpty)
    ? id
    : <String, String>{'id': id, kThemePresetArg: themePreset};

/// Reads route `extra` as string arguments, whatever shape it arrives in.
///
/// In memory `extra` is the `Map<String, String>` a page was pushed with, but
/// when go_router restores a page from browser history it decodes `extra` from
/// JSON as `Map<String, dynamic>`, and it can be `null` (refresh, deep link).
/// A bare `String` is read as `{'id': value}`, the course detail shorthand.
Map<String, String> routeArgs(Object? extra) {
  if (extra is String) return {'id': extra};
  if (extra is! Map) return const {};
  return {
    for (final entry in extra.entries)
      if (entry.key != null && entry.value != null)
        entry.key.toString(): entry.value.toString(),
  };
}

/// Adds [themePreset] to a map of route arguments when it is set.
Map<String, String> withThemePreset(
  Map<String, String> args,
  String? themePreset,
) {
  if (themePreset == null || themePreset.isEmpty) return args;
  return {...args, kThemePresetArg: themePreset};
}
