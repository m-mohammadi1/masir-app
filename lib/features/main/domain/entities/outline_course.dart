import 'package:easy_helper/easy_helper.dart';

abstract class OutlineCourseEntity extends BaseResult {
  final String? id;
  final String? title;
  final int? courseProgressPercent;
  final List<OutlineModuleEntity>? modules;

  const OutlineCourseEntity({
    this.id,
    this.title,
    this.courseProgressPercent,
    this.modules,
  });

  @override
  List<Object?> get props => [id, title, courseProgressPercent, modules];
}

abstract class OutlineModuleEntity extends BaseResult {
  final String? id;
  final String? title;
  final int? order;
  final bool? locked;
  final List<OutlinePathEntity>? paths;

  const OutlineModuleEntity({
    this.id,
    this.title,
    this.order,
    this.locked,
    this.paths,
  });

  @override
  List<Object?> get props => [id, title, order, locked, paths];
}

abstract class OutlinePathEntity extends BaseResult {
  final String? id;
  final String? title;
  final int? order;
  final bool? locked;
  final int? pathProgressPercent;
  final List<OutlineUnitEntity>? units;

  const OutlinePathEntity({
    this.id,
    this.title,
    this.order,
    this.locked,
    this.pathProgressPercent,
    this.units,
  });

  @override
  List<Object?> get props => [id, title, order, locked, pathProgressPercent, units];
}

abstract class OutlineUnitEntity extends BaseResult {
  final String? id;
  final String? title;
  final String? type;
  final int? order;
  final String? status;
  final bool? locked;

  const OutlineUnitEntity({
    this.id,
    this.title,
    this.type,
    this.order,
    this.status,
    this.locked,
  });

  @override
  List<Object?> get props => [id, title, type, order, status, locked];
}
