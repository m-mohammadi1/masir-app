class UnitPageArgs {
  final String unitId;
  final String unitType;
  final String unitTitle;
  final String status;
  final String? themePreset;

  const UnitPageArgs({
    required this.unitId,
    required this.unitType,
    this.unitTitle = '',
    this.status = '',
    this.themePreset,
  });

  bool get isCompleted => status == 'completed';

  Map<String, String> toMap() => {
    'id': unitId,
    'type': unitType,
    'title': unitTitle,
    'status': status,
    if (themePreset != null && themePreset!.isNotEmpty)
      'themePreset': themePreset!,
  };

  factory UnitPageArgs.fromMap(Map<String, String> map) {
    return UnitPageArgs(
      unitId: map['id'] ?? '',
      unitType: map['type'] ?? '',
      unitTitle: map['title'] ?? '',
      status: map['status'] ?? '',
      themePreset: map['themePreset'],
    );
  }
}

/// What the unit page hands back to the roadmap when it closes.
class UnitPageResult {
  /// The last unit completed during the visit, if any.
  final String? lastCompletedId;

  /// The student asked to join the course (from the end of the free preview).
  final bool join;

  const UnitPageResult({this.lastCompletedId, this.join = false});
}
