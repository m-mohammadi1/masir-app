import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/announcement_model.dart';
import '../../../data/models/request_announcements_model.dart';
import '../../../domain/usecases/get_announcement.dart';
import '../../../domain/usecases/mark_notification_read.dart';

part 'announcement_detail_event.dart';
part 'announcement_detail_state.dart';
part 'announcement_detail_bloc.freezed.dart';

@injectable
class AnnouncementDetailBloc
    extends Bloc<AnnouncementDetailEvent, AnnouncementDetailState> {
  final GetAnnouncementUseCase getAnnouncementUseCase;
  final MarkNotificationReadUseCase markNotificationReadUseCase;

  AnnouncementDetailBloc({
    required this.getAnnouncementUseCase,
    required this.markNotificationReadUseCase,
  }) : super(const AnnouncementDetailState.loading(false)) {
    on<AnnouncementDetailEvent>(_onEvent);
  }

  void _onEvent(AnnouncementDetailEvent event, emit) async {
    await event.when(
      load: (instituteId, announcementId) async {
        emit(const AnnouncementDetailState.loading(true));
        final data = await getAnnouncementUseCase(
          params: RequestAnnouncementIdModel(
            instituteId: instituteId,
            announcementId: announcementId,
          ),
        );
        await data.fold(
          (failure) async {
            emit(AnnouncementDetailState.error(false, failure.message));
            GEasyHelper.retry(failure.message, () => add(event));
          },
          (item) async {
            final model = item as AnnouncementModel;
            emit(AnnouncementDetailState.success(false, model));
            final notificationId = model.notificationId;
            if (notificationId != null && notificationId.isNotEmpty) {
              await markNotificationReadUseCase(
                params: RequestNotificationIdModel(id: notificationId),
              );
            }
          },
        );
      },
    );
  }
}
