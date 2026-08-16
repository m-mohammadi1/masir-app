import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:injectable/injectable.dart';

import '../../data/datasource/institute_remote_data_source.dart';
import '../../data/models/request_institute_id_model.dart';
import '../../data/models/request_wallet_model.dart';
import '../entities/institute_detail.dart';
import '../entities/wallet_card.dart';

abstract class InstituteRepository {
  final InstituteRemoteDataSource remoteDataSource;

  const InstituteRepository({required this.remoteDataSource});

  @factoryMethod
  Future<Either<Failure, List<WalletCardEntity>>> wallet({
    RequestWalletModel? params,
  });

  @factoryMethod
  Future<Either<Failure, InstituteDetailEntity>> instituteDetail({
    RequestInstituteIdModel? params,
  });

  @factoryMethod
  Future<Either<Failure, EmptyResult>> join({RequestInstituteIdModel? params});

  @factoryMethod
  Future<Either<Failure, EmptyResult>> enter({RequestInstituteIdModel? params});
}
