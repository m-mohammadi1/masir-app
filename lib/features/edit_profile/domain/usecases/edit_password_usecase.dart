import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../domain/entities/edit_password.dart';
import '../../data/models/request_edit_password_model.dart';
import '../repository/edit_profile_repository.dart';


@injectable
class EditPasswordUseCase implements UseCase<EditPasswordEntity, RequestEditPasswordModel?> {
  final EditProfileRepository repository;

  const EditPasswordUseCase({required this.repository});

  @override
  Future<Either<Failure, EditPasswordEntity>> call({RequestEditPasswordModel? params}) {
    return repository.editPassword(params: params);
  }
}
