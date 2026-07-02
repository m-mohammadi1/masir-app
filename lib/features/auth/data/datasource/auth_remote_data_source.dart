import 'package:injectable/injectable.dart';



import 'package:easy_helper/easy_helper.dart';
import '../../domain/entities/submit_username.dart';
import '../models/submit_username_model.dart';
import '../models/request_submit_username_model.dart';
import '../../domain/entities/submit_register.dart';
import '../models/submit_register_model.dart';
import '../models/request_submit_register_model.dart';
import '../../domain/entities/login.dart';
import '../models/login_model.dart';
import '../models/request_login_model.dart';
import '../models/auth_model.dart';
import '../models/request_auth_model.dart';
import '../../domain/entities/auth.dart';

sealed class AuthRemoteDataSource {
  final IRestfulApi restfulApi;
  const AuthRemoteDataSource({required this.restfulApi});

  @factoryMethod
  Future<User> submitUsername({RequestSubmitUsernameModel? params});

  @factoryMethod
  Future<SubmitRegisterEntity> submitRegister({RequestSubmitRegisterModel? params});

  @factoryMethod
  Future<LoginEntity> login({RequestLoginModel? params});
  @factoryMethod
  Future<AuthEntity> call({RequestAuthModel? params});
}

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  final IRestfulApi restfulApi;

  const AuthRemoteDataSourceImpl({required this.restfulApi});

@override
Future<User> submitUsername({RequestSubmitUsernameModel? params}) async {
  var response = await restfulApi.post(
    path: 'auth/username',
    result: const UserModel().toResult,
    request: params,
  );
  return response.result as UserModel;
}

@override
Future<SubmitRegisterEntity> submitRegister({RequestSubmitRegisterModel? params}) async {
  var response = await restfulApi.post(
    path: 'auth/register',
    result: const SubmitRegisterModel().toResult,
    request: params,
  );
  return response.result as SubmitRegisterModel;
}

@override
Future<LoginEntity> login({RequestLoginModel? params}) async {
  var response = await restfulApi.post(
    path: 'auth/login',
    result: const LoginModel().toResult,
    request: params,
  );
  return response.result as LoginModel;
}

  @override
  Future<AuthEntity> call({RequestAuthModel? params}) async {
    var response = await restfulApi.post(
      path: 'auth/register/send-code',
      result: AuthModel().toResult,
      request: params,
    );
    return response.result as AuthModel;
  }
}
