import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '/design/design.dart';

/// Video with the design's controls: a dark glass bar with pause, the time
/// track, and full screen. [poster] shows until the student presses play.
class MasirVideo extends StatefulWidget {
  final String url;
  final Widget poster;
  final int durationSeconds;
  final String posterLabel;
  final bool autoplay;
  final ValueChanged<double>? onProgress;
  final VoidCallback? onEnded;

  const MasirVideo({
    super.key,
    required this.url,
    required this.poster,
    this.durationSeconds = 0,
    this.posterLabel = '',
    this.autoplay = false,
    this.onProgress,
    this.onEnded,
  });

  @override
  State<MasirVideo> createState() => _MasirVideoState();
}

class _MasirVideoState extends State<MasirVideo> {
  VideoPlayerController? _c;
  bool _failed = false;
  bool _ended = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoplay) _start();
  }

  Future<void> _start() async {
    if (_c != null) {
      _c!.play();
      return;
    }
    final c = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    setState(() => _c = c);
    try {
      await c.initialize();
      c.addListener(_tick);
      await c.play();
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
    if (mounted) setState(() {});
  }

  void _tick() {
    final c = _c!;
    final v = c.value;
    if (!v.isInitialized) return;
    final d = v.duration.inMilliseconds;
    if (d > 0) widget.onProgress?.call(v.position.inMilliseconds / d);
    if (!_ended &&
        d > 0 &&
        v.position.inMilliseconds >= d - 300 &&
        !v.isPlaying) {
      _ended = true;
      widget.onEnded?.call();
    }
    // VideoBar follows the controller itself; this frame only changes once
    // the video is ready.
    final shown = (v.isInitialized, v.aspectRatio);
    if (shown == _shown) return;
    _shown = shown;
    if (mounted) setState(() {});
  }

  Object? _shown;

  @override
  void dispose() {
    _c?.removeListener(_tick);
    _c?.dispose();
    super.dispose();
  }

  Future<void> _fullscreen() async {
    final c = _c;
    if (c == null) return;
    await Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        opaque: true,
        pageBuilder: (_, _, _) => _FullScreen(controller: c),
        transitionsBuilder: (_, a, _, child) =>
            FadeTransition(opacity: a, child: child),
      ),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final c = _c;
    final pal = context.pal;
    if (c == null || _failed) {
      return Stack(
        fit: StackFit.expand,
        children: [
          widget.poster,
          Center(
            child: Semantics(
              button: true,
              label: _failed ? 'ویدیو پخش نشد، دوباره' : 'پخش ویدیو',
              child: GestureDetector(
                onTap: () {
                  if (_failed) {
                    _c?.dispose();
                    setState(() {
                      _c = null;
                      _failed = false;
                    });
                  }
                  _start();
                },
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Color(0x40000000), offset: Offset(0, 6)),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: MIcon(
                    _failed ? MI.retry : MI.play,
                    size: 30,
                    color: pal.p,
                  ),
                ),
              ),
            ),
          ),
          if (widget.posterLabel.isNotEmpty && !_failed)
            Positioned(
              right: 16,
              bottom: 16,
              child: Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xA814101C),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Center(
                  widthFactor: 1,
                  child: Text(
                    widget.posterLabel,
                    style: T.of(13, FontWeight.w800, Colors.white),
                  ),
                ),
              ),
            ),
        ],
      );
    }
    final v = c.value;
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Color(0xFF1A1622)),
        if (v.isInitialized)
          Center(
            child: AspectRatio(
              aspectRatio: v.aspectRatio,
              child: VideoPlayer(c),
            ),
          )
        else
          Stack(
            fit: StackFit.expand,
            children: [
              ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Color(0x73000000),
                  BlendMode.darken,
                ),
                child: widget.poster,
              ),
              const Center(
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              ),
            ],
          ),
        Positioned(
          left: 12,
          right: 12,
          bottom: 12,
          child: VideoBar(controller: c, onFullscreen: _fullscreen),
        ),
      ],
    );
  }
}

/// «۰:۲۴ ━━━━ ۱:۴۲» over pause and full-screen buttons.
class VideoBar extends StatelessWidget {
  final VideoPlayerController controller;
  final VoidCallback? onFullscreen;
  const VideoBar({super.key, required this.controller, this.onFullscreen});

  @override
  Widget build(
    BuildContext context,
  ) => ValueListenableBuilder<VideoPlayerValue>(
    valueListenable: controller,
    builder: (context, v, _) {
      final total = v.duration.inMilliseconds;
      final f = total == 0
          ? 0.0
          : (v.position.inMilliseconds / total).clamp(0.0, 1.0);
      Widget btn(
        MI icon,
        String label,
        VoidCallback onTap, {
        bool filled = true,
      }) => Semantics(
        button: true,
        label: label,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0x2EFFFFFF),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: MIcon(icon, size: 20, color: Colors.white),
          ),
        ),
      );
      return Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: const Color(0xB314101C),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  clock(v.position.inSeconds),
                  style: T.of(12, FontWeight.w700, Colors.white),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, box) => GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (d) {
                        if (total == 0) return;
                        // The track fills right-to-left in RTL.
                        final x =
                            (box.maxWidth - d.localPosition.dx) / box.maxWidth;
                        controller.seekTo(
                          Duration(
                            milliseconds: (total * x.clamp(0, 1)).round(),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 20,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: SizedBox(
                              height: 6,
                              child: Stack(
                                children: [
                                  const Positioned.fill(
                                    child: ColoredBox(color: Color(0x4DFFFFFF)),
                                  ),
                                  FractionallySizedBox(
                                    alignment: AlignmentDirectional.centerStart,
                                    widthFactor: f,
                                    child: const ColoredBox(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  clock(v.duration.inSeconds),
                  style: T.of(12, FontWeight.w700, Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                btn(
                  v.isPlaying ? MI.pause : MI.play,
                  v.isPlaying ? 'توقف' : 'پخش',
                  () => v.isPlaying ? controller.pause() : controller.play(),
                ),
                const Spacer(),
                if (onFullscreen != null)
                  btn(MI.fullscreen, 'تمام‌صفحه', onFullscreen!),
              ],
            ),
          ],
        ),
      );
    },
  );
}

class _FullScreen extends StatelessWidget {
  final VideoPlayerController controller;
  const _FullScreen({required this.controller});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    body: SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: RoundIcon(
              MI.close,
              label: 'بستن',
              bg: const Color(0x2EFFFFFF),
              fg: Colors.white,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: VideoBar(controller: controller),
          ),
        ],
      ),
    ),
  );
}
