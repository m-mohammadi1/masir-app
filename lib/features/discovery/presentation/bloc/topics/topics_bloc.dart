import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/main_feed_model.dart';
import '../../../domain/usecases/discovery_usecases.dart';

part 'topics_event.dart';
part 'topics_state.dart';
part 'topics_bloc.freezed.dart';

@injectable
class TopicsBloc extends Bloc<TopicsEvent, TopicsState> {
  final GetTopicsUseCase getTopicsUseCase;

  TopicsBloc({required this.getTopicsUseCase})
      : super(const TopicsState.loading(false)) {
    on<TopicsEvent>(_onEvent);
  }

  void _onEvent(TopicsEvent event, emit) async {
    await event.when(
      load: () async {
        emit(const TopicsState.loading(true));
        final data = await getTopicsUseCase(params: const NoParams());
        data.fold(
          (failure) {
            emit(TopicsState.error(false, failure.message));
          },
          (items) {
            emit(TopicsState.success(
              false,
              items.cast<DiscoveryTopicModel>(),
            ));
          },
        );
      },
    );
  }
}
