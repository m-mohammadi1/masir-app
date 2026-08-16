import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/request_announcements_model.dart';
import '../entities/announcement.dart';
import '../repository/institute_repository.dart';

@injectable
class GetAnnouncementUseCase
    implements UseCase<AnnouncementEntity, RequestAnnouncementIdModel?> {
  final InstituteRepository repository;

  const GetAnnouncementUseCase({required this.repository});

  @override
  Future<Either<Failure, AnnouncementEntity>> call({
    RequestAnnouncementIdModel? params,
  }) {
    return repository.announcementDetail(params: params);
  }
}
