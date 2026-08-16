part of 'teacher_detail_bloc.dart';

@freezed
sealed class TeacherDetailEvent with _$TeacherDetailEvent {
  const factory TeacherDetailEvent.load({RequestTeacherIdModel? params}) =
      _OnLoad;
}
