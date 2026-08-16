import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/main_feed.dart';
import '../../domain/repository/discovery_repository.dart';
import '../datasource/discovery_remote_data_source.dart';

@Injectable(as: DiscoveryRepository)
class DiscoveryRepositoryImpl implements DiscoveryRepository {
  @override
  final DiscoveryRemoteDataSource remoteDataSource;

  const DiscoveryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, MainFeedEntity>> mainFeed() async {
    try {
      return Right(await remoteDataSource.mainFeed());
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
  Future<Either<Failure, List<DiscoveryTopicEntity>>> topics() async {
    try {
      return Right(await remoteDataSource.topics());
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
