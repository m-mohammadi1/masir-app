import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
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
