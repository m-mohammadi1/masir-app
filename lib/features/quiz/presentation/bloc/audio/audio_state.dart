abstract class AudioBaseState {}

class AudioInitialState extends AudioBaseState {}

class AudioLoadingState extends AudioBaseState {}

class AudioPlayState extends AudioBaseState {}

class AudioErrorState extends AudioBaseState {
  final String message;
  AudioErrorState([this.message = 'خطا در پخش صوت']);
}

class AudioCurrentTimeState extends AudioBaseState {
  final String time;
  final String current;
  final double fullTime, currentTime;

  AudioCurrentTimeState({
    required this.time,
    required this.current,
    required this.fullTime,
    required this.currentTime,
  });
}
