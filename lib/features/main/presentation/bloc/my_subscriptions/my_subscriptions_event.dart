part of 'my_subscriptions_bloc.dart';

@freezed
sealed class MySubscriptionsEvent with _$MySubscriptionsEvent {
  const factory MySubscriptionsEvent.mySubscriptions({RequestMySubscriptionsModel? params}) = _OnMySubscriptions;
}
