import 'package:easy_helper/easy_helper.dart';

abstract class CoursesEntity extends BaseResult {
   final String? id;

   const CoursesEntity({this.id});

   @override
   List<Object?> get props => [id];
 }
