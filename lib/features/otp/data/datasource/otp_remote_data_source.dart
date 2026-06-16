import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '../models/otp_model.dart';
import '../models/request_otp_model.dart';
import '../../domain/entities/otp.dart';

sealed class OtpRemoteDataSource {
  final IRestfulApi restfulApi;
  const OtpRemoteDataSource({required this.restfulApi});
  @factoryMethod
  Future<OtpEntity> call({RequestOtpModel? params});
}

@Injectable(as: OtpRemoteDataSource)
class OtpRemoteDataSourceImpl implements OtpRemoteDataSource {
  @override
  final IRestfulApi restfulApi;

  const OtpRemoteDataSourceImpl({required this.restfulApi});

  @override
  Future<OtpEntity> call({RequestOtpModel? params}) async {
    var response = await restfulApi.post(
      path: 'auth/verify-code',
      result: const OtpModel().toResult,
      request: params,
    );
    return OtpModel.fromJson(response.data['result']);
  }
}
