import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';







import 'package:easy_helper/easy_helper.dart';
import '../../data/models/request_quiz_submit_model.dart';
import '../entities/quiz_submit.dart';
import '../../data/models/request_units_model.dart';
import '../entities/units.dart';
import '../../data/models/request_outline_course_model.dart';
import '../entities/outline_course.dart';
import '../../data/models/request_subscribe_course_model.dart';
import '../entities/subscribe_course.dart';
import '../../data/models/request_course_detail_model.dart';
import '../entities/course_detail.dart';
import '../../data/models/request_courses_model.dart';
import '../entities/courses.dart';
import '../../data/models/request_institutes_model.dart';
import '../entities/institutes.dart';
import '../../data/models/request_my_subscriptions_model.dart';
import '../entities/my_subscriptions.dart';
import '/features/main/domain/entities/main.dart';
import '../../data/models/request_main_model.dart';
import '../../data/datasource/main_remote_data_source.dart';

abstract class MainRepository {
  final MainRemoteDataSource remoteDataSource;

  const MainRepository({required this.remoteDataSource});

  @factoryMethod
  Future<Either<Failure, QuizSubmitResponseEntity>> quizSubmit({RequestQuizSubmitModel? params});


  @factoryMethod
  Future<Either<Failure, UnitsEntity>> units({RequestUnitsModel? params});


  @factoryMethod
  Future<Either<Failure, OutlineCourseEntity>> outlineCourse({RequestOutlineCourseModel? params});


  @factoryMethod
  Future<Either<Failure, SubscribeCourseEntity>> subscribeCourse({RequestSubscribeCourseModel? params});


  @factoryMethod
  Future<Either<Failure, CourseDetailEntity>> courseDetail({RequestCourseDetailModel? params});

  @factoryMethod
  Future<Either<Failure, List<CoursesEntity>>> courses({RequestCoursesModel? params});


  @factoryMethod
  Future<Either<Failure, List<InstitutesEntity>>> institutes({RequestInstitutesModel? params});


  @factoryMethod
  Future<Either<Failure, List<MySubscriptionsEntity>>> mySubscriptions({RequestMySubscriptionsModel? params});


  @factoryMethod
  Future<Either<Failure, MainEntity>> call({RequestMainModel? params});
}
