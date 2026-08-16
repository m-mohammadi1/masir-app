import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/request_announcements_model.dart';
import '../repository/institute_repository.dart';

@injectable
class MarkNotificationReadUseCase
    implements UseCase<EmptyResult, RequestNotificationIdModel?> {
  final InstituteRepository repository;

  const MarkNotificationReadUseCase({required this.repository});

  @override
  Future<Either<Failure, EmptyResult>> call({
    RequestNotificationIdModel? params,
  }) {
    return repository.markNotificationRead(params: params);
  }
}
