import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/request_announcements_model.dart';
import '../entities/announcement.dart';
import '../repository/institute_repository.dart';

@injectable
class GetAnnouncementsUseCase
    implements UseCaseList<List<AnnouncementEntity>, RequestAnnouncementsModel?> {
  final InstituteRepository repository;

  const GetAnnouncementsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<AnnouncementEntity>>> call({
    RequestAnnouncementsModel? params,
  }) {
    return repository.announcements(params: params);
  }
}
