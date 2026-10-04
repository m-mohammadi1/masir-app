import 'package:flutter/material.dart';
import 'package:mohammad/widgets/chunky_box.dart';
import 'package:mohammad/widgets/custom_text.dart';
import 'package:video_player/video_player.dart';
import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String url;
  final bool autoPlay;

  const CustomVideoPlayer({
    super.key,
    required this.url,
    this.autoPlay = false,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late final VideoPlayerController _controller;
  bool _initialized = false;
  bool _hasError = false;
  bool _showControls = true;

  Color get _accent => context.colors.primary;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize()
          .then((_) {
            if (!mounted) return;
            setState(() => _initialized = true);
            if (widget.autoPlay) {
              _controller.play();
            }
          })
          .catchError((error, stack) {
            debugPrint('Video play error: $error\n$stack');
            if (!mounted) return;
            setState(() => _hasError = true);
          });

    _controller.addListener(_onUpdate);
  }

  void _onUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onUpdate);
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(MasirRadius.card),
      child: ColoredBox(
        color: Colors.black,
        child: AspectRatio(aspectRatio: 16 / 9, child: _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white70,
              size: MasirIconSize.xl,
            ),
            const SizedBox(height: MasirSpace.sm),
            const CustomText.body('ویدیو پخش نشد، دوباره امتحان کن', color: Colors.white),
          ],
        ),
      );
    }

    if (!_initialized) {
      return Center(child: CircularProgressIndicator(color: _accent));
    }

    final value = _controller.value;
    final position = value.position.inMilliseconds.toDouble();
    final durationMs = value.duration.inMilliseconds.toDouble();
    final max = durationMs > 0 ? durationMs : 1.0;
    final sliderValue = position.clamp(0.0, max).toDouble();
    final aspect = value.aspectRatio == 0 ? 16 / 9 : value.aspectRatio;
    final ended = durationMs > 0 && position >= durationMs - 300;

    return GestureDetector(
      onTap: () => setState(() => _showControls = !_showControls),
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: aspect * 100,
              height: 100,
              child: VideoPlayer(_controller),
            ),
          ),
          if (value.isBuffering)
            Center(child: CircularProgressIndicator(color: _accent)),
          // Controls fade in and out instead of popping.
          IgnorePointer(
            ignoring: !_showControls,
            child: AnimatedOpacity(
              opacity: _showControls ? 1 : 0,
              duration: const Duration(milliseconds: 220),
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  const ColoredBox(color: Colors.black26),
                  ChunkyBox(
                    fill: _accent,
                    edge: context.colors.primaryEdge,
                    radius: MasirRadius.pill,
                    width: 76,
                    height: 80,
                    alignment: Alignment.center,
                    onTap: ended ? _replay : _togglePlay,
                    child: Icon(
                      ended
                          ? Icons.replay_rounded
                          : value.isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: 44,
                      color: context.colors.onPrimary,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          MasirSpace.md,
                          0,
                          MasirSpace.md,
                          MasirSpace.sm,
                        ),
                        child: Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 10,
                                trackShape: const RoundedRectSliderTrackShape(),
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 10,
                                ),
                                overlayShape: SliderComponentShape.noOverlay,
                                activeTrackColor: _accent,
                                inactiveTrackColor: Colors.white38,
                                thumbColor: Colors.white,
                              ),
                              child: Slider(
                                min: 0,
                                max: max,
                                value: sliderValue,
                                onChanged: (v) {
                                  _controller.seekTo(
                                    Duration(milliseconds: v.round()),
                                  );
                                },
                              ),
                            ),
                            Row(
                              children: [
                                CustomText.micro(
                                  _format(value.position),
                                  color: Colors.white,
                                ),
                                const Spacer(),
                                CustomText.micro(
                                  _format(value.duration),
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _replay() {
    _controller
      ..seekTo(Duration.zero)
      ..play();
  }
}
