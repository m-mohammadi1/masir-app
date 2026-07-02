import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';



import 'package:easy_helper/easy_helper.dart';
import '../../domain/entities/submit_username.dart';
import '../models/request_submit_username_model.dart';
import '../../domain/entities/submit_register.dart';
import '../models/request_submit_register_model.dart';
import '../../domain/entities/login.dart';
import '../models/request_login_model.dart';
import '/features/auth/domain/entities/auth.dart';
import '/features/auth/domain/repository/auth_repository.dart';
import '../datasource/auth_remote_data_source.dart';
import '../models/request_auth_model.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  @override
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> submitUsername({RequestSubmitUsernameModel? params}) async {
    try {
      return Right(await remoteDataSource.submitUsername(params: params));
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
  Future<Either<Failure, SubmitRegisterEntity>> submitRegister({RequestSubmitRegisterModel? params}) async {
    try {
      return Right(await remoteDataSource.submitRegister(params: params));
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
  Future<Either<Failure, LoginEntity>> login({RequestLoginModel? params}) async {
    try {
      return Right(await remoteDataSource.login(params: params));
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
  Future<Either<Failure, AuthEntity>> call({RequestAuthModel? params}) async {
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
