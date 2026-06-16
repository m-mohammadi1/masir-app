import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '/features/quiz/domain/entities/quiz.dart';
import '/features/quiz/domain/repository/quiz_repository.dart';
import '../datasource/quiz_remote_data_source.dart';
import '../models/request_quiz_model.dart';

@Injectable(as: QuizRepository)
class QuizRepositoryImpl implements QuizRepository {
  @override
  final QuizRemoteDataSource remoteDataSource;

  const QuizRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, QuizEntity>> call({RequestQuizModel? params}) async {
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
