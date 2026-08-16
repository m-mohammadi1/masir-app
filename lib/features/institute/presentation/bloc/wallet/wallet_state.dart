part of 'wallet_bloc.dart';

@freezed
sealed class WalletState with _$WalletState {
  const factory WalletState.loading(bool isLoading) = _WalletLoading;
  const factory WalletState.error(bool isLoading, String message) = _WalletError;
  const factory WalletState.success(bool isLoading, List<WalletCardModel> data) =
      _WalletSuccess;
}
