import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '../models/register_model.dart';
import '../models/request_register_model.dart';
import '../../domain/entities/register.dart';

sealed class RegisterRemoteDataSource {
  final IRestfulApi restfulApi;
  const RegisterRemoteDataSource({required this.restfulApi});
  @factoryMethod
  Future<RegisterEntity> call({RequestRegisterModel? params});
}

@Injectable(as: RegisterRemoteDataSource)
class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  @override
  final IRestfulApi restfulApi;

  const RegisterRemoteDataSourceImpl({required this.restfulApi});

  @override
  Future<RegisterEntity> call({RequestRegisterModel? params}) async {
    var response = await restfulApi.post(
      path: '/',
      result: const RegisterModel().toResult,
      request: params,
    );
    return response.result as RegisterModel;
  }
}
