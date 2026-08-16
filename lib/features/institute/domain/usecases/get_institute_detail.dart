import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/request_institute_id_model.dart';
import '../entities/institute_detail.dart';
import '../repository/institute_repository.dart';

@injectable
class GetInstituteDetailUseCase
    implements UseCase<InstituteDetailEntity, RequestInstituteIdModel?> {
  final InstituteRepository repository;

  const GetInstituteDetailUseCase({required this.repository});

  @override
  Future<Either<Failure, InstituteDetailEntity>> call({
    RequestInstituteIdModel? params,
  }) {
    return repository.instituteDetail(params: params);
  }
}
