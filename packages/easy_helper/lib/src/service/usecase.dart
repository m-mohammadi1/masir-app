import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';

abstract class UseCase<R extends BaseResult, Params extends BaseRequest?> {
  Future<Either<Failure, R>> call({required Params params});
}

abstract class UseCaseList<
  R extends List<BaseResult>,
  Params extends BaseRequest?
> {
  Future<Either<Failure, List<BaseResult>>> call({required Params params});
}

class NoParams extends BaseRequest {
  const NoParams();
}
