import 'package:easy_helper/easy_helper.dart';

abstract class SubscribeCourseEntity extends BaseResult {
   final String? id;
   final String? courseId;
   final int? courseProgressPercent;

   const SubscribeCourseEntity({this.id, this.courseId, this.courseProgressPercent});

   @override
   List<Object?> get props => [id,courseId,courseProgressPercent];
 }
