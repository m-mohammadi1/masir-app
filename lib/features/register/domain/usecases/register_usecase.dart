import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '/features/register/domain/entities/register.dart';
import '/features/register/domain/repository/register_repository.dart';
import '../../data/models/request_register_model.dart';

@injectable
class RegisterUseCase implements UseCase<RegisterEntity, RequestRegisterModel?> {
  final RegisterRepository repository;

  const RegisterUseCase({required this.repository});

  @override
  Future<Either<Failure, RegisterEntity>> call({RequestRegisterModel? params}) {
    return repository(params: params);
  }
}
