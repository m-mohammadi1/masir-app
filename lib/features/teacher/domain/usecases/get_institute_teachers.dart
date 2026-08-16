import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:injectable/injectable.dart';

import '../../../institute/data/models/request_institute_id_model.dart';
import '../entities/teacher.dart';
import '../repository/teacher_repository.dart';

@injectable
class GetInstituteTeachersUseCase
    implements UseCaseList<List<TeacherEntity>, RequestInstituteIdModel?> {
  final TeacherRepository repository;

  const GetInstituteTeachersUseCase({required this.repository});

  @override
  Future<Either<Failure, List<TeacherEntity>>> call({
    RequestInstituteIdModel? params,
  }) {
    return repository.instituteTeachers(params: params);
  }
}
