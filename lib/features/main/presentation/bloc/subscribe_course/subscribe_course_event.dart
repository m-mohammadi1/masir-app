part of 'subscribe_course_bloc.dart';

@freezed
sealed class SubscribeCourseEvent with _$SubscribeCourseEvent {
  const factory SubscribeCourseEvent.subscribeCourse({RequestSubscribeCourseModel? params}) = _OnSubscribeCourse;
}
