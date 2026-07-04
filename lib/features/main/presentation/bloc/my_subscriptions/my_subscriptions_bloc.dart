import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import '../../../domain/usecases/my_subscriptions_usecase.dart';
import '/features/main/data/models/my_subscriptions_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/request_my_subscriptions_model.dart';


part 'my_subscriptions_event.dart';
part 'my_subscriptions_state.dart';
part 'my_subscriptions_bloc.freezed.dart';

@injectable
class MySubscriptionsBloc extends Bloc<MySubscriptionsEvent, MySubscriptionsState> {
  final MySubscriptionsUseCase mySubscriptionsUseCase;

  MySubscriptionsBloc({required this.mySubscriptionsUseCase})
      : super(const MySubscriptionsState.loading(false)) {
    on<MySubscriptionsEvent>(_onMySubscriptionsEvent);
  }

  List<MySubscriptionsModel> values = [];
  void _onMySubscriptionsEvent(MySubscriptionsEvent event, emit) async {
    await event.when(
      mySubscriptions: (params) async{
       emit(const MySubscriptionsState.loading(true));
       var data = await mySubscriptionsUseCase(params: params);
       data.fold(
         (failure) {
           emit(MySubscriptionsState.error(false, failure.message));
           GEasyHelper.retry(failure.message, () => add(event));
         },
         (data) {
           values = data.cast<MySubscriptionsModel>();
           print("values is : ${values.length}");
           emit(MySubscriptionsState.success(false, data.cast<MySubscriptionsModel>()));
         },
        );
      },
    );
  }
}
