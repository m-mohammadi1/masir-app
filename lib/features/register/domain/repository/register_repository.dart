import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '/features/register/domain/entities/register.dart';
import '../../data/models/request_register_model.dart';
import '../../data/datasource/register_remote_data_source.dart';

abstract class RegisterRepository {
  final RegisterRemoteDataSource remoteDataSource;

  const RegisterRepository({required this.remoteDataSource});

  @factoryMethod
  Future<Either<Failure, RegisterEntity>> call({RequestRegisterModel? params});
}
