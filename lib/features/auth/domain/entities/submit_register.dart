import 'package:easy_helper/easy_helper.dart';

abstract class SubmitRegisterEntity extends BaseResult {
   final String? id;

   const SubmitRegisterEntity({this.id});

   @override
   List<Object?> get props => [id];
 }
