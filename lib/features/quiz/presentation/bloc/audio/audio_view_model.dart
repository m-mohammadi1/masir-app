import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:audioplayers/audioplayers.dart';
import 'audio_state.dart';

class AudioViewModel extends Cubit<AudioBaseState> {
  final TickerProvider tickerProvider;
  final String url;

  bool _initialed = true, _playing = false;

  AudioViewModel(this.tickerProvider, this.url)
      : super(AudioInitialState()) {
    _audio = AudioPlayer(playerId: url);
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  late int _index;

  late AudioPlayer _audio;

  // AudioPlayer get _audio => AudioPlayer(playerId: allAudio[_index]);

  StreamSubscription get _stream =>
      _audio.onPositionChanged.listen((event) async {
        if(!isClosed){
          emit(AudioCurrentTimeState(
            time: _printDuration(event),
            current: _current,
            currentTime: event.inSeconds.toDouble(),
            fullTime: _fullTime,
          ));
        }
      });

  String _current = "";

  double _fullTime = 0.1;

  /// Handle cache video
  final String _key = "audioCacheKey";

  late final CacheManager _instance = CacheManager(
    Config(
      _key,
      stalePeriod: const Duration(days: 90),
      maxNrOfCacheObjects: 60,
      repo: JsonCacheInfoRepository(databaseName: _key),
      fileService: HttpFileService(),
    ),
  );

  Future<File?> _getFile(String url) async {
    emit(AudioLoadingState());
    var result = await _instance.store.getFile(url);
    return result?.file;
  }

  Future<FileInfo> _downloadFile(String url) async {
    return await _instance.downloadFile(url);
  }

  void _play() async {
    try {
      var data = await _getFile(url);
      if (data != null) {
        await _audio.play(DeviceFileSource(data.path));
      } else {
        await _audio.play(UrlSource(url));
        _downloadFile(url);
      }

      _stream;
      _playing = false;
      _fullTime =
          (await _audio.getDuration() ?? Duration.zero).inSeconds.toDouble();
      _current = _printDuration(await _audio.getDuration() ?? Duration.zero);
    } catch (_) {
      if (!isClosed) emit(AudioErrorState());
    }
  }

  void seekTo(double second) async {
    Duration d = Duration(seconds: second.toInt());
    _audio.seek(d);
  }

  void pause(){
    _audio.pause();
    animationController.forward();
    _playing = false;
    emit(AudioPlayState());
  }

  void onPressed() async {
    if (_initialed) {
      _initialed = false;
      emit(AudioLoadingState());
      _play();
      animationController.forward();
      emit(AudioPlayState());
    }
    if (_playing) {
      _audio.pause();
      animationController.forward();
      _playing = false;
      emit(AudioPlayState());
    } else {
      _audio.resume();
      animationController.reverse();
      _playing = true;
      emit(AudioPlayState());
    }
  }

  void nextAudio() async {
    _audio.stop();
    _index += 1;
    _play();
    animationController.forward();
    emit(AudioPlayState());
  }

  void previousAudio() async {
    _audio.stop();
    _index -= 1;
    _play();
    animationController.forward();
    emit(AudioPlayState());
  }

  void updateSpeed(double value) => _audio.setPlaybackRate(value);

  void nextSecond() async {
    Duration d = await _audio.getCurrentPosition() ?? Duration.zero;
    d += const Duration(seconds: 15);
    _audio.seek(d);
  }

  void previousSecond() async {
    Duration d = await _audio.getCurrentPosition() ?? Duration.zero;
    d -= const Duration(seconds: 15);
    if (d.inSeconds > 0) {
      _audio.seek(d);
    }
  }

  late final AnimationController animationController = AnimationController(
    vsync: tickerProvider,
    duration: const Duration(milliseconds: 450),
    value: 1,
  );

  @override
  Future<void> close() {
    _audio.stop();
    _audio.pause();
    _stream.cancel();
    _audio.audioCache.clearAll();
    _audio.dispose();
    animationController.dispose();
    return super.close();
  }
}
