import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../domain/entities/institutes.dart';
import '../../data/models/request_institutes_model.dart';
import '../repository/main_repository.dart';


@injectable
class InstitutesUseCase implements UseCaseList<List<InstitutesEntity>, RequestInstitutesModel?> {
  final MainRepository repository;

  const InstitutesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<InstitutesEntity>>> call({RequestInstitutesModel? params}) {
    return repository.institutes(params: params);
  }
}
