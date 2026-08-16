import 'package:flutter/material.dart';
import 'package:mohammad/widgets/custom_text.dart';
import 'package:video_player/video_player.dart';
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
      borderRadius: BorderRadius.circular(12),
      child: ColoredBox(
        color: Colors.black,
        child: AspectRatio(aspectRatio: 16 / 9, child: _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    if (_hasError) {
      return const Center(
        child: CustomText(
          'خطا در پخش ویدئو',
          fontSize: 14,
          color: Colors.white,
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
          if (_showControls) ...[
            Container(color: Colors.black26),
            IconButton(
              onPressed: _togglePlay,
              iconSize: 56,
              color: Colors.white,
              icon: Icon(
                value.isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  child: Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 12,
                          ),
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
                          CustomText(
                            _format(value.position),
                            fontSize: 11,
                            color: Colors.white,
                          ),
                          const Spacer(),
                          CustomText(
                            _format(value.duration),
                            fontSize: 11,
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
        ],
      ),
    );
  }
}
