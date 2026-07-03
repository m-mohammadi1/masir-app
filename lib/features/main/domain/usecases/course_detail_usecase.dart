import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../domain/entities/course_detail.dart';
import '../../data/models/request_course_detail_model.dart';
import '../repository/main_repository.dart';


@injectable
class CourseDetailUseCase implements UseCase<CourseDetailEntity, RequestCourseDetailModel?> {
  final MainRepository repository;

  const CourseDetailUseCase({required this.repository});

  @override
  Future<Either<Failure, CourseDetailEntity>> call({RequestCourseDetailModel? params}) {
    return repository.courseDetail(params: params);
  }
}
