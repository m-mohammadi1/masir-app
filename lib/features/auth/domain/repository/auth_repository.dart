import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';



import 'package:easy_helper/easy_helper.dart';
import '../../data/models/request_submit_username_model.dart';
import '../entities/submit_username.dart';
import '../../data/models/request_submit_register_model.dart';
import '../entities/submit_register.dart';
import '../../data/models/request_login_model.dart';
import '../entities/login.dart';
import '/features/auth/domain/entities/auth.dart';
import '../../data/models/request_auth_model.dart';
import '../../data/datasource/auth_remote_data_source.dart';

abstract class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepository({required this.remoteDataSource});

  @factoryMethod
  Future<Either<Failure, UserEntity>> submitUsername({RequestSubmitUsernameModel? params});


  @factoryMethod
  Future<Either<Failure, SubmitRegisterEntity>> submitRegister({RequestSubmitRegisterModel? params});


  @factoryMethod
  Future<Either<Failure, LoginEntity>> login({RequestLoginModel? params});


  @factoryMethod
  Future<Either<Failure, AuthEntity>> call({RequestAuthModel? params});
}
