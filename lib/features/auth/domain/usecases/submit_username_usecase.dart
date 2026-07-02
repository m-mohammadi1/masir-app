import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../domain/entities/submit_username.dart';
import '../../data/models/request_submit_username_model.dart';
import '../repository/auth_repository.dart';


@injectable
class SubmitUsernameUseCase implements UseCase<UserEntity, RequestSubmitUsernameModel?> {
  final AuthRepository repository;

  const SubmitUsernameUseCase({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call({RequestSubmitUsernameModel? params}) {
    return repository.submitUsername(params: params);
  }
}
