import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:injectable/injectable.dart';

import '../../../institute/data/models/request_institute_id_model.dart';
import '../../data/datasource/teacher_remote_data_source.dart';
import '../../data/models/request_teacher_id_model.dart';
import '../entities/teacher.dart';

abstract class TeacherRepository {
  final TeacherRemoteDataSource remoteDataSource;

  const TeacherRepository({required this.remoteDataSource});

  @factoryMethod
  Future<Either<Failure, List<TeacherEntity>>> instituteTeachers({
    RequestInstituteIdModel? params,
  });

  @factoryMethod
  Future<Either<Failure, TeacherPageEntity>> teacher({
    RequestTeacherIdModel? params,
  });
}
