import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/app_notification_model.dart';
import '../../../data/models/request_announcements_model.dart';
import '../../../domain/usecases/get_notifications.dart';
import '../../../domain/usecases/mark_notification_read.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';
part 'notifications_bloc.freezed.dart';

@injectable
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationReadUseCase markNotificationReadUseCase;

  NotificationsBloc({
    required this.getNotificationsUseCase,
    required this.markNotificationReadUseCase,
  }) : super(const NotificationsState.loading(false)) {
    on<NotificationsEvent>(_onEvent);
  }

  int _page = 1;
  final int _perPage = 20;

  void _onEvent(NotificationsEvent event, emit) async {
    await event.when(
      load: () async {
        _page = 1;
        emit(const NotificationsState.loading(true));
        final data = await getNotificationsUseCase(
          params: RequestNotificationsModel(page: 1, perPage: _perPage),
        );
        data.fold(
          (failure) {
            emit(NotificationsState.error(false, failure.message));
            GEasyHelper.retry(failure.message, () => add(event));
          },
          (items) {
            final models = items.cast<AppNotificationModel>();
            emit(NotificationsState.success(
              false,
              models,
              models.length >= _perPage,
              false,
            ));
          },
        );
      },
      loadMore: () async {
        final list = state.maybeWhen(
          success: (_, items, hasMore, loadingMore) =>
              hasMore && !loadingMore ? items : null,
          orElse: () => null,
        );
        if (list == null) return;
        emit(NotificationsState.success(false, list, true, true));
        _page += 1;
        final data = await getNotificationsUseCase(
          params: RequestNotificationsModel(page: _page, perPage: _perPage),
        );
        data.fold(
          (failure) {
            emit(NotificationsState.success(false, list, true, false));
          },
          (items) {
            final models = items.cast<AppNotificationModel>();
            emit(NotificationsState.success(
              false,
              [...list, ...models],
              models.length >= _perPage,
              false,
            ));
          },
        );
      },
      markRead: (id) async {
        await markNotificationReadUseCase(
          params: RequestNotificationIdModel(id: id),
        );
        state.whenOrNull(
          success: (_, items, hasMore, loadingMore) {
            final next = [
              for (final item in items)
                if (item.id == id)
                  AppNotificationModel(
                    id: item.id,
                    type: item.type,
                    payload: item.payload,
                    readAt: DateTime.now().toUtc().toIso8601String(),
                    createdAt: item.createdAt,
                  )
                else
                  item,
            ];
            emit(NotificationsState.success(false, next, hasMore, loadingMore));
          },
        );
      },
    );
  }
}
