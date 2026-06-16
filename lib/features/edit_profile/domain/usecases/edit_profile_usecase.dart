import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '/features/edit_profile/domain/entities/edit_profile.dart';
import '/features/edit_profile/domain/repository/edit_profile_repository.dart';
import '../../data/models/request_edit_profile_model.dart';

@injectable
class EditProfileUseCase implements UseCase<EditProfileEntity, RequestEditProfileModel?> {
  final EditProfileRepository repository;

  const EditProfileUseCase({required this.repository});

  @override
  Future<Either<Failure, EditProfileEntity>> call({RequestEditProfileModel? params}) {
    return repository(params: params);
  }
}
