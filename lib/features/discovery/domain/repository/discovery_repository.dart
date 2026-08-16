import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:injectable/injectable.dart';

import '../../data/datasource/discovery_remote_data_source.dart';
import '../entities/main_feed.dart';

abstract class DiscoveryRepository {
  final DiscoveryRemoteDataSource remoteDataSource;

  const DiscoveryRepository({required this.remoteDataSource});

  @factoryMethod
  Future<Either<Failure, MainFeedEntity>> mainFeed();

  @factoryMethod
  Future<Either<Failure, List<DiscoveryTopicEntity>>> topics();
}
