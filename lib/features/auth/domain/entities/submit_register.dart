import 'package:easy_helper/easy_helper.dart';

import '../../data/models/submit_username_model.dart';

abstract class SubmitRegisterEntity extends BaseResult {
  final String? token;
  final UserModel? user;

   const SubmitRegisterEntity({this.token , this.user});

   @override
   List<Object?> get props => [token, user];
 }
