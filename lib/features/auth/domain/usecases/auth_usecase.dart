import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '/features/auth/domain/entities/auth.dart';
import '/features/auth/domain/repository/auth_repository.dart';
import '../../data/models/request_auth_model.dart';

@injectable
class AuthUseCase implements UseCase<AuthEntity, RequestAuthModel?> {
  final AuthRepository repository;

  const AuthUseCase({required this.repository});

  @override
  Future<Either<Failure, AuthEntity>> call({RequestAuthModel? params}) {
    return repository(params: params);
  }
}
