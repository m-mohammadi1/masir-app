import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';

import '../../domain/entities/institute_detail.dart';
import '../../domain/entities/wallet_card.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/entities/app_notification.dart';
import '../models/institute_detail_model.dart';
import '../models/request_institute_id_model.dart';
import '../models/request_wallet_model.dart';
import '../models/request_announcements_model.dart';
import '../models/wallet_card_model.dart';
import '../models/announcement_model.dart';
import '../models/app_notification_model.dart';

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

  @factoryMethod
  Future<List<AnnouncementEntity>> announcements({
    RequestAnnouncementsModel? params,
  });

  @factoryMethod
  Future<AnnouncementEntity> announcementDetail({
    RequestAnnouncementIdModel? params,
  });

  @factoryMethod
  Future<List<AppNotificationEntity>> notifications({
    RequestNotificationsModel? params,
  });

  @factoryMethod
  Future<EmptyResult> markNotificationRead({RequestNotificationIdModel? params});
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

  @override
  Future<List<AnnouncementEntity>> announcements({
    RequestAnnouncementsModel? params,
  }) async {
    var response = await restfulApi.get(
      path:
          'institutes/${params?.instituteId}/announcements?page=${params?.page ?? 1}&per_page=${params?.perPage ?? 20}',
      result: const AnnouncementModel().setResults(['data', 'items']),
    );
    return response.results!.cast<AnnouncementModel>();
  }

  @override
  Future<AnnouncementEntity> announcementDetail({
    RequestAnnouncementIdModel? params,
  }) async {
    var response = await restfulApi.get(
      path:
          'institutes/${params?.instituteId}/announcements/${params?.announcementId}',
      result: const AnnouncementModel().toResult,
    );
    return response.result as AnnouncementModel;
  }

  @override
  Future<List<AppNotificationEntity>> notifications({
    RequestNotificationsModel? params,
  }) async {
    var response = await restfulApi.get(
      path:
          'notifications?page=${params?.page ?? 1}&per_page=${params?.perPage ?? 20}',
      result: const AppNotificationModel().setResults(['data', 'items']),
    );
    return response.results!.cast<AppNotificationModel>();
  }

  @override
  Future<EmptyResult> markNotificationRead({
    RequestNotificationIdModel? params,
  }) async {
    await restfulApi.post(
      path: 'notifications/${params?.id}/read',
      result: const EmptyResult().toResult,
    );
    return const EmptyResult();
  }
}
