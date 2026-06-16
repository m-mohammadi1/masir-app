import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoViewModel extends Cubit<VideoBaseState> {
  VideoViewModel() : super(VideoInitialState());

  int _sec = 0;

  void changeSec(int s) {
    _sec = s;
  }

  int get secound => _sec;

  /// Handle player
  void play() {
    emit(VideoPlayState());
  }

  void pause() {
    emit(VideoPauseState());
  }

  void seekTo(int minute, int seconds) =>
      emit(SeekTo(minute: minute, seconds: seconds));

  void speed(double value) => emit(PlaybackSpeed(speed: value));

  /// Handle cache video
  final String _key = "videoCacheKey";

  late final CacheManager _instance = CacheManager(
    Config(
      _key,
      stalePeriod: const Duration(days: 90),
      maxNrOfCacheObjects: 60,
      repo: JsonCacheInfoRepository(databaseName: _key),
      fileService: HttpFileService(),
    ),
  );

  Future<File?> getFile(String url, bool autoPlay) async {
    emit(LoadingPlayState());
    var result = await _instance.store.getFile(url);
    if (autoPlay) {
      play();
    } else {
      pause();
    }
    return result?.file;
  }

  Future<FileInfo> downloadFile(String url) async {
    return await _instance.downloadFile(url);
  }

  void clearCache() => _instance.emptyCache();

  void removeFile(String url) {
    _instance.removeFile(url).then((value) {
      debugPrint('File removed');
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
    });
  }
}

abstract class VideoBaseState {}

class VideoInitialState extends VideoBaseState {}

class VideoPlayState extends VideoBaseState {}

class VideoPauseState extends VideoBaseState {}

class SeekTo extends VideoBaseState {
  final int minute;
  final int seconds;

  SeekTo({
    required this.minute,
    required this.seconds,
  });
}

class PlaybackSpeed extends VideoBaseState {
  final double speed;

  PlaybackSpeed({required this.speed});
}

class LoadingPlayState extends VideoBaseState {}
