part of 'subscribe_course_bloc.dart';

@freezed
sealed class SubscribeCourseState with _$SubscribeCourseState {
  const factory SubscribeCourseState.loading(bool isLoading) = _SubscribeCourseLoading;
  const factory SubscribeCourseState.error(bool isLoading, String message) = _SubscribeCourseError;
  const factory SubscribeCourseState.success(bool isLoading, SubscribeCourseModel data) = _SubscribeCourseSuccess;
}
