import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '/features/about_us/domain/entities/about_us.dart';
import '/features/about_us/domain/repository/about_us_repository.dart';
import '../../data/models/request_about_us_model.dart';

@injectable
class AboutUsUseCase implements UseCase<AboutUsEntity, RequestAboutUsModel?> {
  final AboutUsRepository repository;

  const AboutUsUseCase({required this.repository});

  @override
  Future<Either<Failure, AboutUsEntity>> call({RequestAboutUsModel? params}) {
    return repository(params: params);
  }
}
