import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:injectable/injectable.dart';

import '../../../institute/data/models/request_institute_id_model.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/repository/teacher_repository.dart';
import '../datasource/teacher_remote_data_source.dart';
import '../models/request_teacher_id_model.dart';

@Injectable(as: TeacherRepository)
class TeacherRepositoryImpl implements TeacherRepository {
  @override
  final TeacherRemoteDataSource remoteDataSource;

  const TeacherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TeacherEntity>>> instituteTeachers({
    RequestInstituteIdModel? params,
  }) async {
    try {
      return Right(await remoteDataSource.instituteTeachers(params: params));
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
  Future<Either<Failure, TeacherPageEntity>> teacher({
    RequestTeacherIdModel? params,
  }) async {
    try {
      return Right(await remoteDataSource.teacher(params: params));
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
