import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '/features/otp/domain/entities/otp.dart';
import '/features/otp/domain/repository/otp_repository.dart';
import '../../data/models/request_otp_model.dart';

@injectable
class OtpUseCase implements UseCase<OtpEntity, RequestOtpModel?> {
  final OtpRepository repository;

  const OtpUseCase({required this.repository});

  @override
  Future<Either<Failure, OtpEntity>> call({RequestOtpModel? params}) {
    return repository(params: params);
  }
}
