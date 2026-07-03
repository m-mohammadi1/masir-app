import 'package:easy_helper/easy_helper.dart';

abstract class OutlineCourseEntity extends BaseResult {
   final String? id;

   const OutlineCourseEntity({this.id});

   @override
   List<Object?> get props => [id];
 }
