import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/announcement_model.dart';
import '../../../data/models/request_announcements_model.dart';
import '../../../domain/usecases/get_announcements.dart';

part 'announcements_event.dart';
part 'announcements_state.dart';
part 'announcements_bloc.freezed.dart';

@injectable
class AnnouncementsBloc extends Bloc<AnnouncementsEvent, AnnouncementsState> {
  final GetAnnouncementsUseCase getAnnouncementsUseCase;

  AnnouncementsBloc({required this.getAnnouncementsUseCase})
      : super(const AnnouncementsState.loading(false)) {
    on<AnnouncementsEvent>(_onEvent);
  }

  String? _instituteId;
  int _page = 1;
  final int _perPage = 20;

  void _onEvent(AnnouncementsEvent event, emit) async {
    await event.when(
      load: (instituteId, perPage) async {
        _instituteId = instituteId;
        _page = 1;
        emit(const AnnouncementsState.loading(true));
        final data = await getAnnouncementsUseCase(
          params: RequestAnnouncementsModel(
            instituteId: instituteId,
            page: 1,
            perPage: perPage ?? _perPage,
          ),
        );
        data.fold(
          (failure) {
            emit(AnnouncementsState.error(false, failure.message));
            GEasyHelper.retry(failure.message, () => add(event));
          },
          (items) {
            final models = items.cast<AnnouncementModel>();
            emit(AnnouncementsState.success(
              false,
              models,
              models.length >= (perPage ?? _perPage),
              false,
            ));
          },
        );
      },
      loadMore: () async {
        final current = state;
        final list = current.maybeWhen(
          success: (_, items, hasMore, loadingMore) => hasMore && !loadingMore ? items : null,
          orElse: () => null,
        );
        if (list == null || _instituteId == null) return;
        emit(AnnouncementsState.success(false, list, true, true));
        _page += 1;
        final data = await getAnnouncementsUseCase(
          params: RequestAnnouncementsModel(
            instituteId: _instituteId!,
            page: _page,
            perPage: _perPage,
          ),
        );
        data.fold(
          (failure) {
            emit(AnnouncementsState.success(false, list, true, false));
            GEasyHelper.retry(failure.message, () => add(event));
          },
          (items) {
            final models = items.cast<AnnouncementModel>();
            emit(AnnouncementsState.success(
              false,
              [...list, ...models],
              models.length >= _perPage,
              false,
            ));
          },
        );
      },
      markLocalRead: (announcementId) async {
        state.whenOrNull(
          success: (_, items, hasMore, loadingMore) {
            final next = [
              for (final item in items)
                if (item.id == announcementId)
                  AnnouncementModel(
                    id: item.id,
                    title: item.title,
                    body: item.body,
                    publishedAt: item.publishedAt,
                    courseId: item.courseId,
                    courseTitle: item.courseTitle,
                    moduleId: item.moduleId,
                    isUnread: false,
                    notificationId: item.notificationId,
                  )
                else
                  item,
            ];
            emit(AnnouncementsState.success(false, next, hasMore, loadingMore));
          },
        );
      },
    );
  }
}
