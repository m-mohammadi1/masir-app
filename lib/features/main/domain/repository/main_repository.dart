import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '/features/main/domain/entities/main.dart';
import '../../data/models/request_main_model.dart';
import '../../data/datasource/main_remote_data_source.dart';

abstract class MainRepository {
  final MainRemoteDataSource remoteDataSource;

  const MainRepository({required this.remoteDataSource});

  @factoryMethod
  Future<Either<Failure, MainEntity>> call({RequestMainModel? params});
}
