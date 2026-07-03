import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../domain/entities/subscribe_course.dart';
import '../../data/models/request_subscribe_course_model.dart';
import '../repository/main_repository.dart';


@injectable
class SubscribeCourseUseCase implements UseCase<SubscribeCourseEntity, RequestSubscribeCourseModel?> {
  final MainRepository repository;

  const SubscribeCourseUseCase({required this.repository});

  @override
  Future<Either<Failure, SubscribeCourseEntity>> call({RequestSubscribeCourseModel? params}) {
    return repository.subscribeCourse(params: params);
  }
}
