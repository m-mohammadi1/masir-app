import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '/features/quiz/domain/entities/quiz.dart';
import '/features/quiz/domain/repository/quiz_repository.dart';
import '../../data/models/request_quiz_model.dart';

@injectable
class QuizUseCase implements UseCase<QuizEntity, RequestQuizModel?> {
  final QuizRepository repository;

  const QuizUseCase({required this.repository});

  @override
  Future<Either<Failure, QuizEntity>> call({RequestQuizModel? params}) {
    return repository(params: params);
  }
}
