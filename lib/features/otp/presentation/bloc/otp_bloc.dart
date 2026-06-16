import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../domain/usecases/otp_usecase.dart';
import '/features/otp/data/models/otp_model.dart';
import '../../data/models/otp_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/request_otp_model.dart';


part 'otp_event.dart';
part 'otp_state.dart';
part 'otp_bloc.freezed.dart';

@injectable
class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final OtpUseCase otpUseCase;

  OtpBloc({required this.otpUseCase})
      : super(const OtpState.loading(false)) {
    on<OtpEvent>(_onOtpEvent);
  }

  void _onOtpEvent(OtpEvent event, emit) async {
    await event.when(
      otp: (params) async{
       emit(const OtpState.loading(true));
       var data = await otpUseCase(params: params);
       data.fold(
         (failure) {
           emit(OtpState.error(false, failure.message));
           GEasyHelper.retry(failure.message, () => add(event));
         },
         (data) {
           emit(OtpState.success(false, cast<OtpModel>(data)));
         },
        );
      },
    );
  }
}
