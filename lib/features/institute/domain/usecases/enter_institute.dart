import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/request_institute_id_model.dart';
import '../repository/institute_repository.dart';

@injectable
class EnterInstituteUseCase
    implements UseCase<EmptyResult, RequestInstituteIdModel?> {
  final InstituteRepository repository;

  const EnterInstituteUseCase({required this.repository});

  @override
  Future<Either<Failure, EmptyResult>> call({
    RequestInstituteIdModel? params,
  }) {
    return repository.enter(params: params);
  }
}
