import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../domain/entities/courses.dart';
import '../../data/models/request_courses_model.dart';
import '../repository/main_repository.dart';


@injectable
class CoursesUseCase implements UseCaseList<List<CoursesEntity>, RequestCoursesModel?> {
  final MainRepository repository;

  const CoursesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<CoursesEntity>>> call({RequestCoursesModel? params}) {
    return repository.courses(params: params);
  }
}
