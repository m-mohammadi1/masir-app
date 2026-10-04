import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../../domain/usecases/institutes_usecase.dart';
import '/features/main/data/models/institutes_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/request_institutes_model.dart';

part 'institutes_event.dart';
part 'institutes_state.dart';
part 'institutes_bloc.freezed.dart';

@injectable
class InstitutesBloc extends Bloc<InstitutesEvent, InstitutesState> {
  final InstitutesUseCase institutesUseCase;

  InstitutesBloc({required this.institutesUseCase})
    : super(const InstitutesState.loading(false)) {
    on<InstitutesEvent>(_onInstitutesEvent);
  }

  void _onInstitutesEvent(InstitutesEvent event, emit) async {
    await event.when(
      institutes: (params) async {
        emit(const InstitutesState.loading(true));
        var data = await institutesUseCase(params: params);
        data.fold(
          (failure) {
            emit(InstitutesState.error(false, failure.message));
            GEasyHelper.retry(failure.message, () => add(event));
          },
          (data) {
            emit(InstitutesState.success(false, data.cast<InstitutesModel>()));
          },
        );
      },
    );
  }
}
