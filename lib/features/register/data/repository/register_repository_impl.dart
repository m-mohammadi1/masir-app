import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '/features/register/domain/entities/register.dart';
import '/features/register/domain/repository/register_repository.dart';
import '../datasource/register_remote_data_source.dart';
import '../models/request_register_model.dart';

@Injectable(as: RegisterRepository)
class RegisterRepositoryImpl implements RegisterRepository {
  @override
  final RegisterRemoteDataSource remoteDataSource;

  const RegisterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, RegisterEntity>> call({RequestRegisterModel? params}) async {
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
