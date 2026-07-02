//
// mport 'package:dartz/dartz.dart';
// import 'package:injectable/injectable.dart';
// import 'package:easy_helper/easy_helper.dart';
// import '/features/otp/domain/entities/otp.dart';
// import '/features/otp/domain/repository/otp_repository.dart';
// import '../datasource/otp_remote_data_source.dart';
// import '../models/request_otp_model.dart';
//
// @Injectable(as: OtpRepository)
// class OtpRepositoryImpl implements OtpRepository {
//   @override
//   final OtpRemoteDataSource remoteDataSource;
//
//   const OtpRepositoryImpl({required this.remoteDataSource});
//
//   @override
//   Future<Either<Failure, OtpEntity>> call({RequestOtpModel? params}) async {
//     try {
//       return Right(await remoteDataSource(params: params));
//     } on DioException catch (e) {
//       if (e.response != null) {
//         return Left(ServerFailure().fromJson(e.response?.data));
//       }
//       return Left(DefaultFailure(message: e.message.toString()));
//     } catch (e) {
//       return Left(DefaultFailure(message: e.toString()));
//     }
//   }
// }
