import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/package/lib/pod_player.dart';
import '../bloc/video/video_view_model.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String url;
  final bool autoPlay;
  final VideoViewModel videoViewModel;

  const CustomVideoPlayer({
    Key? key,
    required this.url,
    required this.videoViewModel,
    this.autoPlay = false,
  }) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  // late final VideoPlayerController _videoController;

  // late final ChewieController _controller;

  @override
  void dispose() {
    controller.pause();
    controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  void pause() {
    controller.pause();
  }

  void play() {
    controller.play();
  }

  late final PodPlayerController controller;

  late Timer _timer;

  @override
  void initState() {
    controller = PodPlayerController(
      podPlayerConfig: PodPlayerConfig(autoPlay: widget.autoPlay),
      playVideoFrom: PlayVideoFrom.network(
        widget.url,
      ),
    )
      ..initialise().then((value) {
        if(widget.autoPlay){
          controller.play();
        }
      }
      );
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: widget.videoViewModel,
      listener: (context, state) {
        if (state is VideoPauseState) {
          pause();
        } else if (state is VideoPlayState) {
          play();
        } else if (state is SeekTo) {
          controller.videoSeekTo(Duration(
            minutes: state.minute,
            seconds: state.seconds,
          ));
        } else if (state is PlaybackSpeed) {
          String time = "1x";
          if (state.speed == 1) {
            time = "1x";
          } else if (state.speed == 1.25) {
            time = "1.25x";
          } else if (state.speed == 0.75) {
            time = "0.75x";
          } else if (state.speed == 1.5) {
            time = "1.5x";
          } else if (state.speed == 2) {
            time = "2x";
          } else {
            time = "1x";
          }

          controller.ctr.setVideoPlayBack(time);
        }
      },
      child: PodVideoPlayer(
        controller: controller,
        podPlayerLabels: const PodPlayerLabels(
          loopVideo: "boucle vidéo",
          playbackSpeed: "Vitesse de lecture",
        ),
      ),
    );
  }
}
