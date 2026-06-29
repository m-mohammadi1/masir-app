import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../domain/entities/login.dart';
import '../../data/models/request_login_model.dart';
import '../repository/auth_repository.dart';


@injectable
class LoginUseCase implements UseCase<LoginEntity, RequestLoginModel?> {
  final AuthRepository repository;

  const LoginUseCase({required this.repository});

  @override
  Future<Either<Failure, LoginEntity>> call({RequestLoginModel? params}) {
    return repository.login(params: params);
  }
}
