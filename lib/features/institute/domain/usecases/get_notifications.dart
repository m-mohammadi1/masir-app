import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/request_announcements_model.dart';
import '../entities/app_notification.dart';
import '../repository/institute_repository.dart';

@injectable
class GetNotificationsUseCase
    implements UseCaseList<List<AppNotificationEntity>, RequestNotificationsModel?> {
  final InstituteRepository repository;

  const GetNotificationsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<AppNotificationEntity>>> call({
    RequestNotificationsModel? params,
  }) {
    return repository.notifications(params: params);
  }
}
