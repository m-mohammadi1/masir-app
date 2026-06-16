import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '../models/edit_profile_model.dart';
import '../models/request_edit_profile_model.dart';
import '../../domain/entities/edit_profile.dart';

sealed class EditProfileRemoteDataSource {
  final IRestfulApi restfulApi;
  const EditProfileRemoteDataSource({required this.restfulApi});
  @factoryMethod
  Future<EditProfileEntity> call({RequestEditProfileModel? params});
}

@Injectable(as: EditProfileRemoteDataSource)
class EditProfileRemoteDataSourceImpl implements EditProfileRemoteDataSource {
  @override
  final IRestfulApi restfulApi;

  const EditProfileRemoteDataSourceImpl({required this.restfulApi});

  @override
  Future<EditProfileEntity> call({RequestEditProfileModel? params}) async {
    var response = await restfulApi.post(
      path: '/',
      result: const EditProfileModel().toResult,
      request: params,
    );
    return response.result as EditProfileModel;
  }
}
