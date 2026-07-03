import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../domain/entities/outline_course.dart';
import '../../data/models/request_outline_course_model.dart';
import '../repository/main_repository.dart';


@injectable
class OutlineCourseUseCase implements UseCase<OutlineCourseEntity, RequestOutlineCourseModel?> {
  final MainRepository repository;

  const OutlineCourseUseCase({required this.repository});

  @override
  Future<Either<Failure, OutlineCourseEntity>> call({RequestOutlineCourseModel? params}) {
    return repository.outlineCourse(params: params);
  }
}
