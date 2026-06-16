import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'otp_form_event.dart';
part 'otp_form_state.dart';
part 'otp_form_bloc.freezed.dart';

@injectable
class OtpFormBloc extends Bloc<OtpFormEvent, OtpFormState> {
  OtpFormBloc() : super(const OtpFormState.refresh()) {
    on<OtpFormEvent>((event, emit) {
      emit(OtpFormState.init());
      emit(OtpFormState.refresh());
    });
  }
}
