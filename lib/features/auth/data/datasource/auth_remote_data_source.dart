import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '../models/auth_model.dart';
import '../models/request_auth_model.dart';
import '../../domain/entities/auth.dart';

sealed class AuthRemoteDataSource {
  final IRestfulApi restfulApi;
  const AuthRemoteDataSource({required this.restfulApi});
  @factoryMethod
  Future<AuthEntity> call({RequestAuthModel? params});
}

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  final IRestfulApi restfulApi;

  const AuthRemoteDataSourceImpl({required this.restfulApi});

  @override
  Future<AuthEntity> call({RequestAuthModel? params}) async {
    var response = await restfulApi.post(
      path: 'auth/request-code',
      result: AuthModel().toResult,
      request: params,
    );
    return response.result as AuthModel;
  }
}
