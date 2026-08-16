import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/request_wallet_model.dart';
import '../entities/wallet_card.dart';
import '../repository/institute_repository.dart';

@injectable
class GetWalletUseCase
    implements UseCaseList<List<WalletCardEntity>, RequestWalletModel?> {
  final InstituteRepository repository;

  const GetWalletUseCase({required this.repository});

  @override
  Future<Either<Failure, List<WalletCardEntity>>> call({
    RequestWalletModel? params,
  }) {
    return repository.wallet(params: params);
  }
}
