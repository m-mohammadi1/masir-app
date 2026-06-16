part of 'otp_bloc.dart';

@freezed
sealed class OtpState with _$OtpState {
  const factory OtpState.loading(bool isLoading) = _OtpLoading;
  const factory OtpState.error(bool isLoading, String message) = _OtpError;
  const factory OtpState.success(bool isLoading, OtpModel data) = _OtpSuccess;
}
