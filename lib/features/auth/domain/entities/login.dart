import 'package:easy_helper/easy_helper.dart';
import 'package:mohammad/features/auth/data/models/submit_username_model.dart';

abstract class LoginEntity extends BaseResult {
   final String? token;
   final UserModel? user;

   const LoginEntity({this.token , this.user});

   @override
   List<Object?> get props => [token , user];
 }
