import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';

import '../../domain/entities/institute_detail.dart';
import '../../domain/entities/wallet_card.dart';
import '../models/institute_detail_model.dart';
import '../models/request_institute_id_model.dart';
import '../models/request_wallet_model.dart';
import '../models/wallet_card_model.dart';

sealed class InstituteRemoteDataSource {
  final IRestfulApi restfulApi;
  const InstituteRemoteDataSource({required this.restfulApi});

  @factoryMethod
  Future<List<WalletCardEntity>> wallet({RequestWalletModel? params});

  @factoryMethod
  Future<InstituteDetailEntity> instituteDetail({
    RequestInstituteIdModel? params,
  });

  @factoryMethod
  Future<EmptyResult> join({RequestInstituteIdModel? params});

  @factoryMethod
  Future<EmptyResult> enter({RequestInstituteIdModel? params});
}

@Injectable(as: InstituteRemoteDataSource)
class InstituteRemoteDataSourceImpl implements InstituteRemoteDataSource {
  @override
  final IRestfulApi restfulApi;

  const InstituteRemoteDataSourceImpl({required this.restfulApi});

  @override
  Future<List<WalletCardEntity>> wallet({RequestWalletModel? params}) async {
    var response = await restfulApi.get(
      path: 'me/institutes',
      result: const WalletCardModel().setResults(['data']),
    );
    return response.results!.cast<WalletCardModel>();
  }

  @override
  Future<InstituteDetailEntity> instituteDetail({
    RequestInstituteIdModel? params,
  }) async {
    var response = await restfulApi.get(
      path: 'institutes/${params?.id}',
      result: const InstituteDetailModel().toResult,
    );
    return response.result as InstituteDetailModel;
  }

  @override
  Future<EmptyResult> join({RequestInstituteIdModel? params}) async {
    await restfulApi.post(
      path: 'institutes/${params?.id}/join',
      result: const EmptyResult().toResult,
    );
    return const EmptyResult();
  }

  @override
  Future<EmptyResult> enter({RequestInstituteIdModel? params}) async {
    await restfulApi.post(
      path: 'institutes/${params?.id}/enter',
      result: const EmptyResult().toResult,
    );
    return const EmptyResult();
  }
}
