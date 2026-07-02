import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '/features/main/domain/entities/main.dart';
import '/features/main/domain/repository/main_repository.dart';
import '../../data/models/request_main_model.dart';

@injectable
class MainUseCase implements UseCase<MainEntity, RequestMainModel?> {
  final MainRepository repository;

  const MainUseCase({required this.repository});

  @override
  Future<Either<Failure, MainEntity>> call({RequestMainModel? params}) {
    return repository(params: params);
  }
}
