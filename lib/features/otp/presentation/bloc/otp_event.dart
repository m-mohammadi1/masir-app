part of 'otp_bloc.dart';

@freezed
sealed class OtpEvent with _$OtpEvent {
  const factory OtpEvent.otp({RequestOtpModel? params}) = _OnOtp;
}
