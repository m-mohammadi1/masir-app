import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';

import '../../../institute/data/models/request_institute_id_model.dart';
import '../../domain/entities/teacher.dart';
import '../models/request_teacher_id_model.dart';
import '../models/teacher_model.dart';

sealed class TeacherRemoteDataSource {
  final IRestfulApi restfulApi;
  const TeacherRemoteDataSource({required this.restfulApi});

  @factoryMethod
  Future<List<TeacherEntity>> instituteTeachers({
    RequestInstituteIdModel? params,
  });

  @factoryMethod
  Future<TeacherPageEntity> teacher({RequestTeacherIdModel? params});
}

@Injectable(as: TeacherRemoteDataSource)
class TeacherRemoteDataSourceImpl implements TeacherRemoteDataSource {
  @override
  final IRestfulApi restfulApi;

  const TeacherRemoteDataSourceImpl({required this.restfulApi});

  @override
  Future<List<TeacherEntity>> instituteTeachers({
    RequestInstituteIdModel? params,
  }) async {
    var response = await restfulApi.get(
      path: 'institutes/${params?.id}/teachers',
      result: const TeacherModel().setResults(['data']),
    );
    return response.results!.cast<TeacherModel>();
  }

  @override
  Future<TeacherPageEntity> teacher({RequestTeacherIdModel? params}) async {
    var response = await restfulApi.get(
      path: 'teachers/${params?.userId}',
      result: const TeacherPageModel().toResult,
    );
    return response.result as TeacherPageModel;
  }
}
