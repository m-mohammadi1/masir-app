part of 'about_us_bloc.dart';

@freezed
sealed class AboutUsEvent with _$AboutUsEvent {
  const factory AboutUsEvent.aboutUs({RequestAboutUsModel? params}) = _OnAboutUs;
}
