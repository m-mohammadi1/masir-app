import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/request_wallet_model.dart';
import '../../../data/models/wallet_card_model.dart';
import '../../../domain/usecases/get_wallet.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';
part 'wallet_bloc.freezed.dart';

@injectable
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletUseCase getWalletUseCase;

  WalletBloc({required this.getWalletUseCase})
    : super(const WalletState.loading(false)) {
    on<WalletEvent>(_onWalletEvent);
  }

  void _onWalletEvent(WalletEvent event, emit) async {
    await event.when(
      wallet: (params) async {
        emit(const WalletState.loading(true));
        var data = await getWalletUseCase(params: params);
        data.fold(
          (failure) {
            emit(WalletState.error(false, failure.message));
            GEasyHelper.retry(failure.message, () => add(event));
          },
          (data) {
            emit(WalletState.success(false, data.cast<WalletCardModel>()));
          },
        );
      },
    );
  }
}
