import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../domain/entities/submit_register.dart';
import '../../data/models/request_submit_register_model.dart';
import '../repository/auth_repository.dart';


@injectable
class SubmitRegisterUseCase implements UseCase<SubmitRegisterEntity, RequestSubmitRegisterModel?> {
  final AuthRepository repository;

  const SubmitRegisterUseCase({required this.repository});

  @override
  Future<Either<Failure, SubmitRegisterEntity>> call({RequestSubmitRegisterModel? params}) {
    return repository.submitRegister(params: params);
  }
}
