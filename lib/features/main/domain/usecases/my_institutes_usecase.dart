import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../domain/entities/my_institutes.dart';
import '../../data/models/request_my_institutes_model.dart';
import '../repository/main_repository.dart';


@injectable
class MyInstitutesUseCase implements UseCaseList<List<MyInstitutesEntity>, RequestMyInstitutesModel?> {
  final MainRepository repository;

  const MyInstitutesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<MyInstitutesEntity>>> call({RequestMyInstitutesModel? params}) {
    return repository.myInstitutes(params: params);
  }
}
