import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../domain/entities/quiz_submit.dart';
import '../../data/models/request_quiz_submit_model.dart';
import '../repository/main_repository.dart';

@injectable
class QuizSubmitUseCase
    implements UseCase<QuizSubmitResponseEntity, RequestQuizSubmitModel?> {
  final MainRepository repository;

  const QuizSubmitUseCase({required this.repository});

  @override
  Future<Either<Failure, QuizSubmitResponseEntity>> call({
    RequestQuizSubmitModel? params,
  }) {
    return repository.quizSubmit(params: params);
  }
}
