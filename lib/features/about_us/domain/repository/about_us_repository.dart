import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '/features/about_us/domain/entities/about_us.dart';
import '../../data/models/request_about_us_model.dart';
import '../../data/datasource/about_us_remote_data_source.dart';

abstract class AboutUsRepository {
  final AboutUsRemoteDataSource remoteDataSource;

  const AboutUsRepository({required this.remoteDataSource});

  @factoryMethod
  Future<Either<Failure, AboutUsEntity>> call({RequestAboutUsModel? params});
}
