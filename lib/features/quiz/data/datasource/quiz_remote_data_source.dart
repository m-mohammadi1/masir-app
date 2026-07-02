import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '../models/quiz_model.dart';
import '../models/request_quiz_model.dart';
import '../../domain/entities/quiz.dart';

sealed class QuizRemoteDataSource {
  final IRestfulApi restfulApi;
  const QuizRemoteDataSource({required this.restfulApi});

  @factoryMethod
  Future<QuizEntity> call({RequestQuizModel? params});
}

@Injectable(as: QuizRemoteDataSource)
class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  @override
  final IRestfulApi restfulApi;

  const QuizRemoteDataSourceImpl({required this.restfulApi});

  @override
  Future<QuizEntity> call({RequestQuizModel? params}) async {
    var response = await restfulApi.post(
      path: '/',
      result: const QuizModel().toResult,
      request: params,
    );
    return response.result as QuizModel;
  }
}
