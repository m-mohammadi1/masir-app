import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../domain/entities/units.dart';
import '../../data/models/request_units_model.dart';
import '../repository/main_repository.dart';


@injectable
class UnitsUseCase implements UseCase<UnitsEntity, RequestUnitsModel?> {
  final MainRepository repository;

  const UnitsUseCase({required this.repository});

  @override
  Future<Either<Failure, UnitsEntity>> call({RequestUnitsModel? params}) {
    return repository.units(params: params);
  }
}
