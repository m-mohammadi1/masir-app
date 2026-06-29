import 'package:easy_helper/easy_helper.dart';

abstract class LoginEntity extends BaseResult {
   final String? id;

   const LoginEntity({this.id});

   @override
   List<Object?> get props => [id];
 }
