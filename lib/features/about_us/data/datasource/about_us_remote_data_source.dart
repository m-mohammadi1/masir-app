import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '../models/about_us_model.dart';
import '../models/request_about_us_model.dart';
import '../../domain/entities/about_us.dart';

sealed class AboutUsRemoteDataSource {
  final IRestfulApi restfulApi;
  const AboutUsRemoteDataSource({required this.restfulApi});
  @factoryMethod
  Future<AboutUsEntity> call({RequestAboutUsModel? params});
}

@Injectable(as: AboutUsRemoteDataSource)
class AboutUsRemoteDataSourceImpl implements AboutUsRemoteDataSource {
  @override
  final IRestfulApi restfulApi;

  const AboutUsRemoteDataSourceImpl({required this.restfulApi});

  @override
  Future<AboutUsEntity> call({RequestAboutUsModel? params}) async {
    var response = await restfulApi.post(
      path: '/',
      result: const AboutUsModel().toResult,
      request: params,
    );
    return response.result as AboutUsModel;
  }
}
