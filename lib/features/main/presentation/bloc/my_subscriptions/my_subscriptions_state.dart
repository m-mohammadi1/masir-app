part of 'my_subscriptions_bloc.dart';

@freezed
sealed class MySubscriptionsState with _$MySubscriptionsState {
  const factory MySubscriptionsState.loading(bool isLoading) = _MySubscriptionsLoading;
  const factory MySubscriptionsState.error(bool isLoading, String message) = _MySubscriptionsError;
  const factory MySubscriptionsState.success(bool isLoading, List<MySubscriptionsModel> data) = _MySubscriptionsSuccess;
}
