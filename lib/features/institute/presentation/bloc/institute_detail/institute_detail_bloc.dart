import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/institute_detail_model.dart';
import '../../../data/models/request_institute_id_model.dart';
import '../../../domain/entities/institute_detail.dart';
import '../../../domain/usecases/get_institute_detail.dart';

part 'institute_detail_event.dart';
part 'institute_detail_state.dart';
part 'institute_detail_bloc.freezed.dart';

@injectable
class InstituteDetailBloc
    extends Bloc<InstituteDetailEvent, InstituteDetailState> {
  final GetInstituteDetailUseCase getInstituteDetailUseCase;

  InstituteDetailBloc({required this.getInstituteDetailUseCase})
    : super(const InstituteDetailState.loading(false)) {
    on<InstituteDetailEvent>(_onInstituteDetailEvent);
  }

  void _onInstituteDetailEvent(InstituteDetailEvent event, emit) async {
    await event.when(
      load: (params) async {
        emit(const InstituteDetailState.loading(true));
        var data = await getInstituteDetailUseCase(params: params);
        data.fold(
          (failure) {
            emit(InstituteDetailState.error(false, failure.message));
            GEasyHelper.retry(failure.message, () => add(event));
          },
          (data) {
            emit(
              InstituteDetailState.success(
                false,
                data as InstituteDetailModel,
              ),
            );
          },
        );
      },
      markJoined: () async {
        state.whenOrNull(
          success: (isLoading, data) {
            emit(
              InstituteDetailState.success(
                isLoading,
                data.copyWith(
                  membership: InstituteMembership(
                    isMember: true,
                    memberSince:
                        data.membership.memberSince ??
                        DateTime.now().toUtc().toIso8601String(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
