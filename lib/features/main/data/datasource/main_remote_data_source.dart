import 'package:injectable/injectable.dart';




import 'package:easy_helper/easy_helper.dart';
import '../../domain/entities/my_institutes.dart';
import '../models/my_institutes_model.dart';
import '../models/request_my_institutes_model.dart';
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
  Future<List<MyInstitutesEntity>> myInstitutes({RequestMyInstitutesModel? params});

  @factoryMethod
  Future<List<CoursesEntity>> courses({RequestCoursesModel? params});

  @factoryMethod
  Future<List<InstitutesEntity>> institutes({RequestInstitutesModel? params});

  @factoryMethod
  Future<List<MySubscriptionsEntity>> mySubscriptions({RequestMySubscriptionsModel? params});
  @factoryMethod
  Future<MainEntity> call({RequestMainModel? params});
}

@Injectable(as: MainRemoteDataSource)
class MainRemoteDataSourceImpl implements MainRemoteDataSource {
  @override
  final IRestfulApi restfulApi;

  const MainRemoteDataSourceImpl({required this.restfulApi});

@override
Future<List<MyInstitutesEntity>> myInstitutes({RequestMyInstitutesModel? params}) async {
  var response = await restfulApi.get(
    path: 'me',
    result: const MyInstitutesModel().setResults(['data','institutes']),
    // request: params,
  );
  return response.results!.cast<MyInstitutesModel>();
}

@override
Future<List<CoursesEntity>> courses({RequestCoursesModel? params}) async {
  var response = await restfulApi.post(
    path: '/',
    result: const CoursesModel().toResults,
    request: params,
  );
  return response.results!.cast<CoursesModel>();
}

@override
Future<List<InstitutesEntity>> institutes({RequestInstitutesModel? params}) async {
  var response = await restfulApi.get(
    path: 'institutes?page=1&per_page=200',
    result: const InstitutesModel().setResults(['data','items']),
    // request: params,
  );
  return response.results!.cast<InstitutesModel>();
}

@override
Future<List<MySubscriptionsEntity>> mySubscriptions({RequestMySubscriptionsModel? params}) async {
  var response = await restfulApi.get(
    path: 'me/subscriptions?page=1&per_page=200',
    result: const MySubscriptionsModel().setResults(['data' , 'items']),
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
