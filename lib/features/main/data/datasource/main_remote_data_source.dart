import 'package:injectable/injectable.dart';

import 'package:easy_helper/easy_helper.dart';
import '../../domain/entities/quiz_submit.dart';
import '../models/quiz_submit_model.dart';
import '../models/request_quiz_submit_model.dart';
import '../../domain/entities/units.dart';
import '../models/units_model.dart';
import '../models/request_units_model.dart';
import '../../domain/entities/outline_course.dart';
import '../models/outline_course_model.dart';
import '../models/request_outline_course_model.dart';
import '../../domain/entities/subscribe_course.dart';
import '../models/subscribe_course_model.dart';
import '../models/request_subscribe_course_model.dart';
import '../../domain/entities/course_detail.dart';
import '../models/course_detail_model.dart';
import '../models/request_course_detail_model.dart';
import '../../domain/entities/courses.dart';
import '../models/courses_model.dart';
import '../models/request_courses_model.dart';
import '../../domain/entities/institutes.dart';
import '../models/institutes_model.dart';
import '../models/request_institutes_model.dart';
import '../../domain/entities/my_subscriptions.dart';
import '../models/my_subscriptions_model.dart';
import '../models/request_my_subscriptions_model.dart';
import '../models/main_model.dart';
import '../models/request_main_model.dart';
import '../../domain/entities/main.dart';

sealed class MainRemoteDataSource {
  final IRestfulApi restfulApi;
  const MainRemoteDataSource({required this.restfulApi});

  @factoryMethod
  Future<QuizSubmitResponseEntity> quizSubmit({RequestQuizSubmitModel? params});

  @factoryMethod
  Future<UnitsEntity> units({RequestUnitsModel? params});

  @factoryMethod
  Future<OutlineCourseEntity> outlineCourse({
    RequestOutlineCourseModel? params,
  });

  @factoryMethod
  Future<SubscribeCourseEntity> subscribeCourse({
    RequestSubscribeCourseModel? params,
  });

  @factoryMethod
  Future<CourseDetailEntity> courseDetail({RequestCourseDetailModel? params});

  @factoryMethod
  Future<List<CoursesEntity>> courses({RequestCoursesModel? params});

  @factoryMethod
  Future<List<InstitutesEntity>> institutes({RequestInstitutesModel? params});

  @factoryMethod
  Future<List<MySubscriptionsEntity>> mySubscriptions({
    RequestMySubscriptionsModel? params,
  });
  @factoryMethod
  Future<MainEntity> call({RequestMainModel? params});
}

@Injectable(as: MainRemoteDataSource)
class MainRemoteDataSourceImpl implements MainRemoteDataSource {
  @override
  final IRestfulApi restfulApi;

  const MainRemoteDataSourceImpl({required this.restfulApi});

  @override
  Future<QuizSubmitResponseEntity> quizSubmit({
    RequestQuizSubmitModel? params,
  }) async {
    final hasAnswers = params?.answers.isNotEmpty == true;
    var response = await restfulApi.post(
      path: hasAnswers
          ? 'units/${params?.id}/quiz-submit'
          : 'units/${params?.id}/complete',
      result: const QuizSubmitResponseModel().toResult,
      request: params,
    );
    return response.result as QuizSubmitResponseModel;
  }

  @override
  Future<UnitsEntity> units({RequestUnitsModel? params}) async {
    var response = await restfulApi.get(
      path: 'units/${params?.id}',
      result: const UnitsModel().toResult,
    );
    return response.result as UnitsModel;
  }

  @override
  Future<OutlineCourseEntity> outlineCourse({
    RequestOutlineCourseModel? params,
  }) async {
    var response = await restfulApi.get(
      path: 'courses/${params?.id}/outline',
      result: const OutlineCourseModel().toResult,
      // request: params,
    );
    return response.result as OutlineCourseModel;
  }

  @override
  Future<SubscribeCourseEntity> subscribeCourse({
    RequestSubscribeCourseModel? params,
  }) async {
    var response = await restfulApi.post(
      path: 'courses/${params?.id}/subscribe',
      result: const SubscribeCourseModel().toResult,
      // request: params,
    );
    return response.result as SubscribeCourseModel;
  }

  @override
  Future<CourseDetailEntity> courseDetail({
    RequestCourseDetailModel? params,
  }) async {
    var response = await restfulApi.get(
      path: 'courses/${params?.id}',
      result: const CourseDetailModel().toResult,
      // request: params,
    );
    return response.result as CourseDetailModel;
  }

  @override
  Future<List<CoursesEntity>> courses({RequestCoursesModel? params}) async {
    final instituteId = params?.instituteId;
    final topic = params?.topic;
    final topicQ = (topic != null && topic.isNotEmpty) ? '&topic=$topic' : '';
    final path = (instituteId != null && instituteId.isNotEmpty)
        ? 'institutes/$instituteId/courses?page=1&per_page=200$topicQ'
        : 'courses?page=1&per_page=200$topicQ';
    var response = await restfulApi.get(
      path: path,
      result: const CoursesModel().setResults(['data', 'items']),
      // request: params,
    );
    return response.results!.cast<CoursesModel>();
  }

  @override
  Future<List<InstitutesEntity>> institutes({
    RequestInstitutesModel? params,
  }) async {
    final topic = params?.topic;
    final topicQ = (topic != null && topic.isNotEmpty) ? '&topic=$topic' : '';
    var response = await restfulApi.get(
      path: 'institutes?page=1&per_page=200$topicQ',
      result: const InstitutesModel().setResults(['data', 'items']),
      // request: params,
    );
    return response.results!.cast<InstitutesModel>();
  }

  @override
  Future<List<MySubscriptionsEntity>> mySubscriptions({
    RequestMySubscriptionsModel? params,
  }) async {
    var response = await restfulApi.get(
      path: 'me/subscriptions?page=1&per_page=200',
      result: const MySubscriptionsModel().setResults(['data', 'items']),
      // request: params,
    );
    return response.results!.cast<MySubscriptionsModel>();
  }

  @override
  Future<MainEntity> call({RequestMainModel? params}) async {
    var response = await restfulApi.get(
      path: 'me',
      result: const MainModel().toResult,
      // request: params,
    );
    return response.result as MainModel;
  }
}
