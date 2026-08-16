import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';







import 'package:easy_helper/easy_helper.dart';
import '../../domain/entities/quiz_submit.dart';
import '../models/request_quiz_submit_model.dart';
import '../../domain/entities/units.dart';
import '../models/request_units_model.dart';
import '../../domain/entities/outline_course.dart';
import '../models/request_outline_course_model.dart';
import '../../domain/entities/subscribe_course.dart';
import '../models/request_subscribe_course_model.dart';
import '../../domain/entities/course_detail.dart';
import '../models/request_course_detail_model.dart';
import '../../domain/entities/courses.dart';
import '../models/request_courses_model.dart';
import '../../domain/entities/institutes.dart';
import '../models/request_institutes_model.dart';
import '../../domain/entities/my_subscriptions.dart';
import '../models/request_my_subscriptions_model.dart';
import '/features/main/domain/entities/main.dart';
import '/features/main/domain/repository/main_repository.dart';
import '../datasource/main_remote_data_source.dart';
import '../models/request_main_model.dart';

@Injectable(as: MainRepository)
class MainRepositoryImpl implements MainRepository {
  @override
  final MainRemoteDataSource remoteDataSource;

  const MainRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, QuizSubmitResponseEntity>> quizSubmit({RequestQuizSubmitModel? params}) async {
    try {
      return Right(await remoteDataSource.quizSubmit(params: params));
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerFailure().fromJson(e.response?.data));
      }
      return Left(DefaultFailure(message: e.message.toString()));
    } catch (e) {
      return Left(DefaultFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UnitsEntity>> units({RequestUnitsModel? params}) async {
    try {
      return Right(await remoteDataSource.units(params: params));
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerFailure().fromJson(e.response?.data));
      }
      return Left(DefaultFailure(message: e.message.toString()));
    } catch (e) {
      return Left(DefaultFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OutlineCourseEntity>> outlineCourse({RequestOutlineCourseModel? params}) async {
    try {
      return Right(await remoteDataSource.outlineCourse(params: params));
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerFailure().fromJson(e.response?.data));
      }
      return Left(DefaultFailure(message: e.message.toString()));
    } catch (e) {
      return Left(DefaultFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SubscribeCourseEntity>> subscribeCourse({RequestSubscribeCourseModel? params}) async {
    try {
      return Right(await remoteDataSource.subscribeCourse(params: params));
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerFailure().fromJson(e.response?.data));
      }
      return Left(DefaultFailure(message: e.message.toString()));
    } catch (e) {
      return Left(DefaultFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CourseDetailEntity>> courseDetail({RequestCourseDetailModel? params}) async {
    try {
      return Right(await remoteDataSource.courseDetail(params: params));
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerFailure().fromJson(e.response?.data));
      }
      return Left(DefaultFailure(message: e.message.toString()));
    } catch (e) {
      return Left(DefaultFailure(message: e.toString()));
    }
  }


  @override
  Future<Either<Failure, List<CoursesEntity>>> courses({RequestCoursesModel? params}) async {
    try {
      return Right(await remoteDataSource.courses(params: params));
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerFailure().fromJson(e.response?.data));
      }
      return Left(DefaultFailure(message: e.message.toString()));
    } catch (e) {
      return Left(DefaultFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InstitutesEntity>>> institutes({RequestInstitutesModel? params}) async {
    try {
      return Right(await remoteDataSource.institutes(params: params));
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerFailure().fromJson(e.response?.data));
      }
      return Left(DefaultFailure(message: e.message.toString()));
    } catch (e) {
      return Left(DefaultFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MySubscriptionsEntity>>> mySubscriptions({RequestMySubscriptionsModel? params}) async {
    try {
      return Right(await remoteDataSource.mySubscriptions(params: params));
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerFailure().fromJson(e.response?.data));
      }
      return Left(DefaultFailure(message: e.message.toString()));
    } catch (e) {
      return Left(DefaultFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MainEntity>> call({RequestMainModel? params}) async {
    try {
      return Right(await remoteDataSource(params: params));
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerFailure().fromJson(e.response?.data));
      }
      return Left(DefaultFailure(message: e.message.toString()));
    } catch (e) {
      return Left(DefaultFailure(message: e.toString()));
    }
  }
}
