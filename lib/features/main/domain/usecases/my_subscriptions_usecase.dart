import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../domain/entities/my_subscriptions.dart';
import '../../data/models/request_my_subscriptions_model.dart';
import '../repository/main_repository.dart';


@injectable
class MySubscriptionsUseCase implements UseCaseList<List<MySubscriptionsEntity>, RequestMySubscriptionsModel?> {
  final MainRepository repository;

  const MySubscriptionsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<MySubscriptionsEntity>>> call({RequestMySubscriptionsModel? params}) {
    return repository.mySubscriptions(params: params);
  }
}
