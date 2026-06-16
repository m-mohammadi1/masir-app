import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '/features/auth/domain/entities/auth.dart';
import '../../data/models/request_auth_model.dart';
import '../../data/datasource/auth_remote_data_source.dart';

abstract class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepository({required this.remoteDataSource});

  @factoryMethod
  Future<Either<Failure, AuthEntity>> call({RequestAuthModel? params});
}
