class UnitPageArgs {
  final String unitId;
  final String unitType;
  final String unitTitle;
  final String status;

  const UnitPageArgs({
    required this.unitId,
    required this.unitType,
    this.unitTitle = '',
    this.status = '',
  });

  bool get isCompleted => status == 'completed';

  Map<String, String> toMap() => {
        'id': unitId,
        'type': unitType,
        'title': unitTitle,
        'status': status,
      };

  factory UnitPageArgs.fromMap(Map<String, String> map) {
    return UnitPageArgs(
      unitId: map['id'] ?? '',
      unitType: map['type'] ?? '',
      unitTitle: map['title'] ?? '',
      status: map['status'] ?? '',
    );
  }
}
