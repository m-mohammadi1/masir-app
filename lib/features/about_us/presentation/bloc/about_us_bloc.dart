import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../domain/usecases/about_us_usecase.dart';
import '/features/about_us/data/models/about_us_model.dart';
import '../../data/models/about_us_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/request_about_us_model.dart';


part 'about_us_event.dart';
part 'about_us_state.dart';
part 'about_us_bloc.freezed.dart';

@injectable
class AboutUsBloc extends Bloc<AboutUsEvent, AboutUsState> {
  final AboutUsUseCase aboutUsUseCase;

  AboutUsBloc({required this.aboutUsUseCase})
      : super(const AboutUsState.loading(false)) {
    on<AboutUsEvent>(_onAboutUsEvent);
  }

  void _onAboutUsEvent(AboutUsEvent event, emit) async {
    await event.when(
      aboutUs: (params) async{
       emit(const AboutUsState.loading(true));
       var data = await aboutUsUseCase(params: params);
       data.fold(
         (failure) {
           emit(AboutUsState.error(false, failure.message));
           GEasyHelper.retry(failure.message, () => add(event));
         },
         (data) {
           emit(AboutUsState.success(false, cast<AboutUsModel>(data)));
         },
        );
      },
    );
  }
}
