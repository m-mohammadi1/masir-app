import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '/features/otp/domain/entities/otp.dart';
import '../../data/models/request_otp_model.dart';
import '../../data/datasource/otp_remote_data_source.dart';

abstract class OtpRepository {
  final OtpRemoteDataSource remoteDataSource;

  const OtpRepository({required this.remoteDataSource});

  @factoryMethod
  Future<Either<Failure, OtpEntity>> call({RequestOtpModel? params});
}
