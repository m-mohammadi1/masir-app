import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/institute_detail.dart';
import '../../domain/entities/wallet_card.dart';
import '../../domain/repository/institute_repository.dart';
import '../datasource/institute_remote_data_source.dart';
import '../models/request_institute_id_model.dart';
import '../models/request_wallet_model.dart';

@Injectable(as: InstituteRepository)
class InstituteRepositoryImpl implements InstituteRepository {
  @override
  final InstituteRemoteDataSource remoteDataSource;

  const InstituteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<WalletCardEntity>>> wallet({
    RequestWalletModel? params,
  }) async {
    try {
      return Right(await remoteDataSource.wallet(params: params));
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerFailure().fromJson(e.response?.data));
      }
      return Left(DefaultFailure(message: e.message.toString()));
    } catch (e) {
      return Left(DefaultFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, InstituteDetailEntity>> instituteDetail({
    RequestInstituteIdModel? params,
  }) async {
    try {
      return Right(await remoteDataSource.instituteDetail(params: params));
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerFailure().fromJson(e.response?.data));
      }
      return Left(DefaultFailure(message: e.message.toString()));
    } catch (e) {
      return Left(DefaultFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, EmptyResult>> join({
    RequestInstituteIdModel? params,
  }) async {
    try {
      return Right(await remoteDataSource.join(params: params));
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerFailure().fromJson(e.response?.data));
      }
      return Left(DefaultFailure(message: e.message.toString()));
    } catch (e) {
      return Left(DefaultFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, EmptyResult>> enter({
    RequestInstituteIdModel? params,
  }) async {
    try {
      return Right(await remoteDataSource.enter(params: params));
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerFailure().fromJson(e.response?.data));
      }
      return Left(DefaultFailure(message: e.message.toString()));
    } catch (e) {
      return Left(DefaultFailure(message: e.toString()));
    }
  }
}
