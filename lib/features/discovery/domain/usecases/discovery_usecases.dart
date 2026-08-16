import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:injectable/injectable.dart';

import '../entities/main_feed.dart';
import '../repository/discovery_repository.dart';

@injectable
class GetMainFeedUseCase implements UseCase<MainFeedEntity, NoParams?> {
  final DiscoveryRepository repository;

  const GetMainFeedUseCase({required this.repository});

  @override
  Future<Either<Failure, MainFeedEntity>> call({NoParams? params}) {
    return repository.mainFeed();
  }
}

@injectable
class GetTopicsUseCase
    implements UseCaseList<List<DiscoveryTopicEntity>, NoParams?> {
  final DiscoveryRepository repository;

  const GetTopicsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<DiscoveryTopicEntity>>> call({NoParams? params}) {
    return repository.topics();
  }
}
