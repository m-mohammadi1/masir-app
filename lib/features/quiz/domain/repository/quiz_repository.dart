import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '/features/quiz/domain/entities/quiz.dart';
import '../../data/models/request_quiz_model.dart';
import '../../data/datasource/quiz_remote_data_source.dart';

abstract class QuizRepository {
  final QuizRemoteDataSource remoteDataSource;

  const QuizRepository({required this.remoteDataSource});

  @factoryMethod
  Future<Either<Failure, QuizEntity>> call({RequestQuizModel? params});
}
