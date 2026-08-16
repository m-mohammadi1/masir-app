import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/main_feed.dart';
import '../../../domain/usecases/discovery_usecases.dart';

part 'main_feed_event.dart';
part 'main_feed_state.dart';
part 'main_feed_bloc.freezed.dart';

@injectable
class MainFeedBloc extends Bloc<MainFeedEvent, MainFeedState> {
  final GetMainFeedUseCase getMainFeedUseCase;

  MainFeedBloc({required this.getMainFeedUseCase})
      : super(const MainFeedState.loading(false)) {
    on<MainFeedEvent>(_onEvent);
  }

  void _onEvent(MainFeedEvent event, emit) async {
    await event.when(
      load: () async {
        emit(const MainFeedState.loading(true));
        final data = await getMainFeedUseCase(params: const NoParams());
        data.fold(
          (failure) {
            emit(MainFeedState.error(false, failure.message));
            GEasyHelper.retry(failure.message, () => add(event));
          },
          (feed) {
            emit(MainFeedState.success(false, feed.sections));
          },
        );
      },
    );
  }
}
