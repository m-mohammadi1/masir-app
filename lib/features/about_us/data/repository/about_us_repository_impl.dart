import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '/features/about_us/domain/entities/about_us.dart';
import '/features/about_us/domain/repository/about_us_repository.dart';
import '../datasource/about_us_remote_data_source.dart';
import '../models/request_about_us_model.dart';

@Injectable(as: AboutUsRepository)
class AboutUsRepositoryImpl implements AboutUsRepository {
  @override
  final AboutUsRemoteDataSource remoteDataSource;

  const AboutUsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AboutUsEntity>> call({RequestAboutUsModel? params}) async {
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
