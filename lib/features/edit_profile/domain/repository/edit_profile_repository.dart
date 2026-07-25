import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:easy_helper/easy_helper.dart';
import '../../data/models/request_edit_password_model.dart';
import '../entities/edit_password.dart';
import '/features/edit_profile/domain/entities/edit_profile.dart';
import '../../data/models/request_edit_profile_model.dart';
import '../../data/datasource/edit_profile_remote_data_source.dart';

abstract class EditProfileRepository {
  final EditProfileRemoteDataSource remoteDataSource;

  const EditProfileRepository({required this.remoteDataSource});

  @factoryMethod
  Future<Either<Failure, EditPasswordEntity>> editPassword({RequestEditPasswordModel? params});


  @factoryMethod
  Future<Either<Failure, EditProfileEntity>> call({RequestEditProfileModel? params});
}
