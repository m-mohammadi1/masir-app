import 'package:easy_helper/easy_helper.dart';

abstract class RegisterEntity extends BaseResult {
   final String? id;

   const RegisterEntity({this.id});

   @override
   List<Object?> get props => [id];
 }
