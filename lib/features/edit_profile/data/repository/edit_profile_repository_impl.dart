import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:easy_helper/easy_helper.dart';
import '../../domain/entities/edit_password.dart';
import '../models/request_edit_password_model.dart';
import '/features/edit_profile/domain/entities/edit_profile.dart';
import '/features/edit_profile/domain/repository/edit_profile_repository.dart';
import '../datasource/edit_profile_remote_data_source.dart';
import '../models/request_edit_profile_model.dart';

@Injectable(as: EditProfileRepository)
class EditProfileRepositoryImpl implements EditProfileRepository {
  @override
  final EditProfileRemoteDataSource remoteDataSource;

  const EditProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, EditPasswordEntity>> editPassword({RequestEditPasswordModel? params}) async {
    try {
      return Right(await remoteDataSource.editPassword(params: params));
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
  Future<Either<Failure, EditProfileEntity>> call({RequestEditProfileModel? params}) async {
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
