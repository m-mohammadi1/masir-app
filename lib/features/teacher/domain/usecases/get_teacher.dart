import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/request_teacher_id_model.dart';
import '../entities/teacher.dart';
import '../repository/teacher_repository.dart';

@injectable
class GetTeacherUseCase
    implements UseCase<TeacherPageEntity, RequestTeacherIdModel?> {
  final TeacherRepository repository;

  const GetTeacherUseCase({required this.repository});

  @override
  Future<Either<Failure, TeacherPageEntity>> call({
    RequestTeacherIdModel? params,
  }) {
    return repository.teacher(params: params);
  }
}
