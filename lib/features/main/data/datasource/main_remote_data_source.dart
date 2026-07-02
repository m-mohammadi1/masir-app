import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '../models/main_model.dart';
import '../models/request_main_model.dart';
import '../../domain/entities/main.dart';

sealed class MainRemoteDataSource {
  final IRestfulApi restfulApi;
  const MainRemoteDataSource({required this.restfulApi});
  @factoryMethod
  Future<MainEntity> call({RequestMainModel? params});
}

@Injectable(as: MainRemoteDataSource)
class MainRemoteDataSourceImpl implements MainRemoteDataSource {
  @override
  final IRestfulApi restfulApi;

  const MainRemoteDataSourceImpl({required this.restfulApi});

  @override
  Future<MainEntity> call({RequestMainModel? params}) async {
    var response = await restfulApi.get(
      path: 'me',
      result: const MainModel().toResult,
      // request: params,
    );
    return response.result as MainModel;
  }
}
