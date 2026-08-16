import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';

import '../../domain/entities/main_feed.dart';
import '../models/main_feed_model.dart';

sealed class DiscoveryRemoteDataSource {
  final IRestfulApi restfulApi;
  const DiscoveryRemoteDataSource({required this.restfulApi});

  @factoryMethod
  Future<MainFeedEntity> mainFeed();

  @factoryMethod
  Future<List<DiscoveryTopicEntity>> topics();
}

@Injectable(as: DiscoveryRemoteDataSource)
class DiscoveryRemoteDataSourceImpl implements DiscoveryRemoteDataSource {
  @override
  final IRestfulApi restfulApi;

  const DiscoveryRemoteDataSourceImpl({required this.restfulApi});

  @override
  Future<MainFeedEntity> mainFeed() async {
    final response = await restfulApi.get(
      path: 'main',
      result: const MainFeedModel().toResult,
    );
    return response.result as MainFeedModel;
  }

  @override
  Future<List<DiscoveryTopicEntity>> topics() async {
    final response = await restfulApi.get(
      path: 'topics',
      result: const DiscoveryTopicModel().setResults(['data']),
    );
    return response.results!.cast<DiscoveryTopicModel>();
  }
}
