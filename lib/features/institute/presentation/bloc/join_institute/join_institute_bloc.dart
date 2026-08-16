import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/request_institute_id_model.dart';
import '../../../domain/usecases/join_institute.dart';

part 'join_institute_event.dart';
part 'join_institute_state.dart';
part 'join_institute_bloc.freezed.dart';

@injectable
class JoinInstituteBloc extends Bloc<JoinInstituteEvent, JoinInstituteState> {
  final JoinInstituteUseCase joinInstituteUseCase;

  JoinInstituteBloc({required this.joinInstituteUseCase})
    : super(const JoinInstituteState.idle()) {
    on<JoinInstituteEvent>(_onJoinInstituteEvent);
  }

  void _onJoinInstituteEvent(JoinInstituteEvent event, emit) async {
    await event.when(
      join: (params) async {
        emit(const JoinInstituteState.loading());
        var data = await joinInstituteUseCase(params: params);
        data.fold(
          (failure) {
            emit(JoinInstituteState.error(failure.message));
            GEasyHelper.retry(failure.message, () => add(event));
          },
          (_) {
            emit(const JoinInstituteState.success());
          },
        );
      },
    );
  }
}
