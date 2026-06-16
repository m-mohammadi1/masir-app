import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'intro_state_event.dart';
part 'intro_state_state.dart';
part 'intro_state_bloc.freezed.dart';

class IntroStateBloc extends Bloc<IntroStateEvent, IntroStateState> {
  IntroStateBloc() : super(const IntroStateState.changeState(state: 0)) {
    on<IntroStateEvent>((event, emit) {
      emit(IntroStateState.changeState(state: event.value));
    });
  }
}
