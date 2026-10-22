import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '/design/design.dart';

/// Media payload of a video or audio unit.
class MediaPayload {
  final String url;
  final int durationSeconds;
  final String thumbnailUrl;
  final List<({int at, String title})> chapters;
  final String transcript;

  const MediaPayload({
    required this.url,
    required this.durationSeconds,
    required this.thumbnailUrl,
    required this.chapters,
    required this.transcript,
  });

  factory MediaPayload.fromJson(Map<String, dynamic> j) => MediaPayload(
    url: '${j['media_access_url'] ?? ''}',
    durationSeconds: (j['duration_seconds'] as num?)?.toInt() ?? 0,
    thumbnailUrl: '${j['thumbnail_url'] ?? ''}',
    chapters: [
      for (final c in (j['chapters'] as List? ?? const []))
        if (c is Map)
          (
            at: (c['at_seconds'] as num?)?.toInt() ?? 0,
            title: '${c['title'] ?? ''}',
          ),
    ],
    transcript: '${j['transcript'] ?? ''}',
  );
}

/// «ویدیو»: dark player card with a scrubber, time and speed, then the
/// chapters list that jumps to each part.
class VideoUnitPlayer extends StatefulWidget {
  final MediaPayload media;
  final ValueChanged<double> onProgress;
  const VideoUnitPlayer({
    super.key,
    required this.media,
    required this.onProgress,
  });

  @override
  State<VideoUnitPlayer> createState() => _VideoUnitPlayerState();
}

class _VideoUnitPlayerState extends State<VideoUnitPlayer> {
  VideoPlayerController? _c;
  bool _failed = false;
  double _speed = 1;
  static const _speeds = [1.0, 1.25, 1.5, 0.75];

  @override
  void dispose() {
    _c?.removeListener(_tick);
    _c?.dispose();
    super.dispose();
  }

  Future<void> _ensure() async {
    if (_c != null) return;
    if (widget.media.url.isEmpty) {
      setState(() => _failed = true);
      return;
    }
    final c = VideoPlayerController.networkUrl(Uri.parse(widget.media.url));
    setState(() => _c = c);
    try {
      await c.initialize();
      c.addListener(_tick);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
    if (mounted) setState(() {});
  }

  Object? _shown;

  void _tick() {
    final v = _c!.value;
    final d = v.duration.inMilliseconds;
    if (d > 0) widget.onProgress((v.position.inMilliseconds / d).clamp(0, 1));
    // The controller reports many times a second; rebuild only when what the
    // card shows changes (the clock and scrubber move in whole seconds).
    final shown = (
      v.position.inSeconds,
      v.duration.inSeconds,
      v.isPlaying,
      v.isInitialized,
      v.aspectRatio,
    );
    if (shown == _shown) return;
    _shown = shown;
    if (mounted) setState(() {});
  }

  Future<void> _toggle() async {
    await _ensure();
    final c = _c;
    if (c == null || !c.value.isInitialized) return;
    c.value.isPlaying ? c.pause() : c.play();
  }

  Future<void> _seek(int seconds) async {
    await _ensure();
    final c = _c;
    if (c == null || !c.value.isInitialized) return;
    await c.seekTo(Duration(seconds: seconds));
    c.play();
  }

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final c = _c;
    final v = c?.value;
    final ready = v?.isInitialized ?? false;
    final total = ready ? v!.duration.inSeconds : widget.media.durationSeconds;
    final pos = ready ? v!.position.inSeconds : 0;
    final f = total == 0 ? 0.0 : (pos / total).clamp(0.0, 1.0);
    final playing = v?.isPlaying ?? false;
    final currentChapter = widget.media.chapters.lastIndexWhere(
      (ch) => ch.at <= pos,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: C.darkPaper,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [lip(C.darkLip)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: ready && v!.aspectRatio > 0
                    ? v.aspectRatio
                    : 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (ready)
                      GestureDetector(onTap: _toggle, child: VideoPlayer(c!))
                    else if (widget.media.thumbnailUrl.isNotEmpty)
                      CoverImage(url: widget.media.thumbnailUrl),
                    if (!playing)
                      Center(
                        child: Semantics(
                          button: true,
                          label: _failed ? 'ویدیو پخش نشد' : 'پخش',
                          child: GestureDetector(
                            onTap: _failed ? null : _toggle,
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [lip(C.lockedLip)],
                              ),
                              alignment: Alignment.center,
                              child: c != null && !ready && !_failed
                                  ? const SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        color: C.darkPaper,
                                      ),
                                    )
                                  : MIcon(
                                      _failed ? MI.alert : MI.play,
                                      size: 30,
                                      color: C.darkPaper,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    if (_failed)
                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Text(
                          'ویدیو باز نشد؛ اینترنتت رو چک کن.',
                          textAlign: TextAlign.center,
                          style: T.of(13, FontWeight.w700, C.darkMuted),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                child: Column(
                  children: [
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: LayoutBuilder(
                        builder: (context, box) => GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapDown: (d) => _seek(
                            (total *
                                    (d.localPosition.dx / box.maxWidth).clamp(
                                      0,
                                      1,
                                    ))
                                .round(),
                          ),
                          onHorizontalDragUpdate: (d) => _c?.seekTo(
                            Duration(
                              seconds:
                                  (total *
                                          (d.localPosition.dx / box.maxWidth)
                                              .clamp(0, 1))
                                      .round(),
                            ),
                          ),
                          child: SizedBox(
                            height: 20,
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: C.darkBorder,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: f,
                                  child: Container(
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: pal.p,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: box.maxWidth * f - 8,
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          '${clock(pos)} / ${clock(total)}',
                          textDirection: TextDirection.ltr,
                          style: T.of(13, FontWeight.w500, C.darkInk),
                        ),
                        const Spacer(),
                        _DarkChip(
                          label:
                              '${fa(_speed.toString().replaceAll(RegExp(r'\.?0+$'), '').replaceAll('.', '٫'))}×',
                          semantic: 'سرعت پخش',
                          onTap: () {
                            final next =
                                _speeds[(_speeds.indexOf(_speed) + 1) %
                                    _speeds.length];
                            setState(() => _speed = next);
                            _c?.setPlaybackSpeed(next);
                          },
                        ),
                        const SizedBox(width: 6),
                        _DarkChip(
                          label: playing ? 'مکث' : 'پخش',
                          semantic: playing ? 'مکث' : 'پخش',
                          onTap: _toggle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (widget.media.chapters.isNotEmpty) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text('بخش‌های ویدیو', style: T.of(17, FontWeight.w800)),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: C.surface,
              border: Border.all(color: C.border, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                for (var i = 0; i < widget.media.chapters.length; i++)
                  _ChapterRow(
                    at: widget.media.chapters[i].at,
                    title: widget.media.chapters[i].title,
                    state: i < currentChapter
                        ? 1
                        : (i == currentChapter && ready ? 2 : 0),
                    last: i == widget.media.chapters.length - 1,
                    onTap: () => _seek(widget.media.chapters[i].at),
                  ),
              ],
            ),
          ),
        ],
        if (widget.media.transcript.isNotEmpty) ...[
          const SizedBox(height: 16),
          TranscriptBox(text: widget.media.transcript, title: 'متن ویدیو'),
        ],
      ],
    );
  }
}

class _DarkChip extends StatelessWidget {
  final String label;
  final String semantic;
  final VoidCallback onTap;
  const _DarkChip({
    required this.label,
    required this.semantic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: semantic,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 44),
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2738),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          widthFactor: 1,
          child: Text(label, style: T.of(12, FontWeight.w700, C.darkInk)),
        ),
      ),
    ),
  );
}

class _ChapterRow extends StatelessWidget {
  final int at;
  final String title;
  final int state; // 0 ahead, 1 watched, 2 playing
  final bool last;
  final VoidCallback onTap;
  const _ChapterRow({
    required this.at,
    required this.title,
    required this.state,
    required this.last,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final playing = state == 2;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        decoration: BoxDecoration(
          border: last
              ? null
              : const Border(bottom: BorderSide(color: C.sand, width: 2)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 44,
              child: Text(
                clock(at),
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.right,
                style: T.of(13, FontWeight.w500, playing ? pal.ink : C.muted),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: T.of(
                  15,
                  playing ? FontWeight.w800 : FontWeight.w600,
                  playing ? pal.ink : C.ink,
                ),
              ),
            ),
            if (state == 1)
              const MIcon(MI.check, size: 16, color: C.green, strokeWidth: 3.2),
            if (playing)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: pal.p, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }
}

/// «متن صوت»: folded transcript.
class TranscriptBox extends StatefulWidget {
  final String text;
  final String title;
  const TranscriptBox({super.key, required this.text, this.title = 'متن صوت'});

  @override
  State<TranscriptBox> createState() => _TranscriptBoxState();
}

class _TranscriptBoxState extends State<TranscriptBox> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final latin = RegExp(
      r'^[\x00-\x7F\s]*$',
    ).hasMatch(widget.text.substring(0, widget.text.length.clamp(0, 40)));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: C.surface,
        border: Border.all(color: C.border, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            expanded: _open,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _open = !_open),
              child: SizedBox(
                height: 52,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: T.of(15, FontWeight.w800),
                      ),
                    ),
                    Text(
                      _open ? 'ببند' : 'باز کن',
                      style: T.of(13, FontWeight.w600, C.muted),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_open)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(
                widget.text,
                textDirection: latin ? TextDirection.ltr : TextDirection.rtl,
                textAlign: latin ? TextAlign.left : TextAlign.right,
                style: T.of(14, FontWeight.w500, C.ink, 1.9),
              ),
            ),
        ],
      ),
    );
  }
}

/// «صوتی»: big headphones tile, a waveform that fills as it plays, ±10s and
/// play/pause, then the transcript.
class AudioUnitPlayer extends StatefulWidget {
  final MediaPayload media;
  final ValueChanged<double> onProgress;
  const AudioUnitPlayer({
    super.key,
    required this.media,
    required this.onProgress,
  });

  @override
  State<AudioUnitPlayer> createState() => _AudioUnitPlayerState();
}

class _AudioUnitPlayerState extends State<AudioUnitPlayer> {
  final _player = AudioPlayer();
  final _subs = <StreamSubscription<dynamic>>[];
  Duration _pos = Duration.zero;
  Duration _dur = Duration.zero;
  bool _playing = false;
  bool _loaded = false;
  bool _failed = false;

  static const _bars = [
    18,
    30,
    22,
    40,
    28,
    46,
    34,
    20,
    38,
    52,
    30,
    24,
    44,
    36,
    18,
    28,
    48,
    40,
    26,
    34,
    20,
    42,
    30,
    50,
    36,
    22,
    30,
    44,
    28,
    18,
    38,
    26,
    46,
    32,
    20,
    36,
    28,
    42,
    24,
    30,
    18,
    34,
    26,
    20,
  ];

  @override
  void initState() {
    super.initState();
    _dur = Duration(seconds: widget.media.durationSeconds);
    _subs.addAll([
      _player.onPositionChanged.listen((p) {
        if (!mounted) return;
        // Positions arrive several times a second; rebuild only when the
        // clock, the filled bars or the read-out percentage change.
        final before = _shown;
        _pos = p;
        if (_shown != before) setState(() {});
        if (_dur.inMilliseconds > 0) {
          widget.onProgress(
            (p.inMilliseconds / _dur.inMilliseconds).clamp(0, 1),
          );
        }
      }),
      _player.onDurationChanged.listen((d) {
        if (mounted) setState(() => _dur = d);
      }),
      _player.onPlayerStateChanged.listen((s) {
        if (mounted) setState(() => _playing = s == PlayerState.playing);
      }),
      _player.onPlayerComplete.listen((_) {
        if (mounted) setState(() => _pos = _dur);
        widget.onProgress(1);
      }),
    ]);
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    _player.dispose();
    super.dispose();
  }

  Future<bool> _load() async {
    if (_loaded) return true;
    if (widget.media.url.isEmpty) {
      setState(() => _failed = true);
      return false;
    }
    try {
      await _player.setSourceUrl(widget.media.url);
      _loaded = true;
      return true;
    } catch (_) {
      if (mounted) setState(() => _failed = true);
      return false;
    }
  }

  Future<void> _toggle() async {
    if (_playing) {
      await _player.pause();
      return;
    }
    if (await _load()) await _player.resume();
  }

  Future<void> _jump(int seconds) async {
    if (!await _load()) return;
    final t = _pos + Duration(seconds: seconds);
    await _player.seek(
      t < Duration.zero ? Duration.zero : (t > _dur ? _dur : t),
    );
  }

  double get _f => _dur.inMilliseconds == 0
      ? 0.0
      : (_pos.inMilliseconds / _dur.inMilliseconds).clamp(0.0, 1.0);

  /// What the player shows of the position.
  Object get _shown =>
      (_pos.inSeconds, (_f * _bars.length).floor(), (_f * 100).round());

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final f = _f;
    final filled = (f * _bars.length).floor();
    Widget round(String label, String semantic, VoidCallback onTap) =>
        Semantics(
          button: true,
          label: semantic,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: C.surface,
                shape: BoxShape.circle,
                border: Border.all(color: C.border, width: 2),
                boxShadow: [lip(C.lip, 3)],
              ),
              alignment: Alignment.center,
              child: Text(label, style: T.of(13, FontWeight.w800)),
            ),
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: pal.p,
              borderRadius: BorderRadius.circular(48),
              boxShadow: [lip(pal.e, 8)],
            ),
            alignment: Alignment.center,
            child: MIcon(
              MI.headphones,
              size: 96,
              color: pal.on,
              strokeWidth: 1.8,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Semantics(
          label: 'پیشرفت پخش ${pct((f * 100).round())}',
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: LayoutBuilder(
              builder: (context, box) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (d) async {
                  if (!await _load()) return;
                  final x = (d.localPosition.dx / box.maxWidth).clamp(0.0, 1.0);
                  await _player.seek(
                    Duration(milliseconds: (_dur.inMilliseconds * x).round()),
                  );
                },
                child: SizedBox(
                  height: 56,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (var i = 0; i < _bars.length; i++) ...[
                        if (i > 0) const SizedBox(width: 3),
                        Expanded(
                          child: Container(
                            height: _bars[i].toDouble(),
                            decoration: BoxDecoration(
                              color: i < filled ? pal.p : C.lip,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            children: [
              Text(
                clock(_pos.inSeconds),
                style: T.of(13, FontWeight.w500, C.muted),
              ),
              const Spacer(),
              Text(
                clock(_dur.inSeconds),
                style: T.of(13, FontWeight.w500, C.muted),
              ),
            ],
          ),
        ),
        if (_failed)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'صوت باز نشد؛ اینترنتت رو چک کن.',
              textAlign: TextAlign.center,
              style: T.of(13, FontWeight.w700, C.coralText),
            ),
          ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            round('+۱۰', '۱۰ ثانیه جلو', () => _jump(10)),
            const SizedBox(width: 22),
            Semantics(
              button: true,
              label: _playing ? 'مکث' : 'پخش',
              child: GestureDetector(
                onTap: _toggle,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: pal.p,
                    shape: BoxShape.circle,
                    boxShadow: [lip(pal.e, 5)],
                  ),
                  alignment: Alignment.center,
                  child: MIcon(
                    _playing ? MI.pause : MI.play,
                    size: 30,
                    color: pal.on,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 22),
            round('−۱۰', '۱۰ ثانیه عقب', () => _jump(-10)),
          ],
        ),
        if (widget.media.transcript.isNotEmpty) ...[
          const SizedBox(height: 20),
          TranscriptBox(text: widget.media.transcript),
        ],
      ],
    );
  }
}
