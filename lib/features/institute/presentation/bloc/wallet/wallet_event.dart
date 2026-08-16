part of 'wallet_bloc.dart';

@freezed
sealed class WalletEvent with _$WalletEvent {
  const factory WalletEvent.wallet({RequestWalletModel? params}) = _OnWallet;
}
