/// Route arguments that carry an institute theme preset along with the usual
/// payload, so screens opened from inside an institute keep its colours.
const String kThemePresetArg = 'themePreset';

/// Arguments for the course detail route. Stays a plain `String` when there is
/// no preset, so older call sites keep working.
Object courseDetailArgs(String id, {String? themePreset}) =>
    (themePreset == null || themePreset.isEmpty)
    ? id
    : <String, String>{'id': id, kThemePresetArg: themePreset};

/// Adds [themePreset] to a map of route arguments when it is set.
Map<String, String> withThemePreset(
  Map<String, String> args,
  String? themePreset,
) {
  if (themePreset == null || themePreset.isEmpty) return args;
  return {...args, kThemePresetArg: themePreset};
}
