import '/widgets/pressable.dart';
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/features/quiz/presentation/widgets/speed_widget.dart';
import 'package:mohammad/widgets/chunky_box.dart';
import 'package:mohammad/widgets/custom_text.dart';

import '../bloc/audio/audio_state.dart';
import '../bloc/audio/audio_view_model.dart';
import '/core/theme/theme_context.dart';
import '/core/theme/masir_style.dart';

late AudioViewModel viewModel;

void pauseAudio() {
  viewModel.pause();
}

class CustomAudioPlayer extends StatefulWidget {
  final String url;

  final Function(int value) onChanged;

  CustomAudioPlayer({super.key, required this.url, required this.onChanged});

  @override
  State<CustomAudioPlayer> createState() => _CustomAudioPlayerState();
}

class _CustomAudioPlayerState extends State<CustomAudioPlayer>
    with TickerProviderStateMixin {
  @override
  void dispose() {
    viewModel.close();
    super.dispose();
  }

  @override
  void initState() {
    viewModel = AudioViewModel(this, widget.url);
    viewModel.updateSpeed(1);
    super.initState();
  }

  int currentTime = 0;

  Color get _accent => context.colors.primary400;

  /// Wave with elapsed / total time under it. Dragging or tapping the wave
  /// seeks.
  Widget _buildProgressSection({
    required double currentTime,
    required double fullTime,
    required String elapsedLabel,
    required String totalLabel,
    required ValueChanged<double>? onSeek,
  }) {
    final safeMax = fullTime > 0 ? fullTime : 1.0;
    final fraction = (currentTime / safeMax).clamp(0.0, 1.0);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [
          _Wave(
            fraction: fraction,
            active: _accent,
            idle: _accent.withValues(alpha: 0.25),
            onSeek: onSeek == null ? null : (f) => onSeek(f * safeMax),
          ),
          const SizedBox(height: MasirSpace.sm),
          Row(
            children: [
              CustomText.micro(elapsedLabel, color: context.colors.inkMuted),
              const Spacer(),
              CustomText.micro(totalLabel, color: context.colors.inkMuted),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder(
          bloc: viewModel,
          builder: (context, state) {
            if (state is AudioErrorState) {
              return Padding(
                padding: const EdgeInsets.only(bottom: MasirSpace.md),
                child: CustomText.caption(
                  state.message,
                  color: context.colors.coral,
                ),
              );
            }
            if (state is AudioLoadingState) {
              return Padding(
                padding: const EdgeInsets.only(bottom: MasirSpace.md),
                child: LinearProgressIndicator(
                  color: _accent,
                  backgroundColor: _accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(MasirRadius.pill),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        BlocBuilder(
          bloc: viewModel,
          buildWhen: (previous, current) => current is AudioCurrentTimeState,
          builder: (context, state) {
            if (state is AudioCurrentTimeState) {
              currentTime = state.currentTime.toInt();
              return _buildProgressSection(
                currentTime: state.currentTime,
                fullTime: state.fullTime,
                elapsedLabel: state.time,
                totalLabel: state.current,
                onSeek: viewModel.seekTo,
              );
            }

            return _buildProgressSection(
              currentTime: 0,
              fullTime: 1,
              elapsedLabel: '00:00',
              totalLabel: '00:00',
              onSeek: null,
            );
          },
        ),
        const SizedBox(height: MasirSpace.xl),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SkipButton(
              icon: Icons.replay_rounded,
              label: '۱۵',
              color: _accent,
              onTap: viewModel.previousSecond,
            ),
            const SizedBox(width: MasirSpace.xl),
            BlocBuilder(
              bloc: viewModel,
              buildWhen: (previous, current) => current is AudioPlayState,
              builder: (context, state) => ChunkyBox(
                fill: _accent,
                edge: context.colors.primaryEdge,
                radius: MasirRadius.pill,
                width: 84,
                height: 88,
                alignment: Alignment.center,
                onTap: viewModel.onPressed,
                child: AnimatedIcon(
                  icon: AnimatedIcons.pause_play,
                  progress: viewModel.animationController,
                  color: context.colors.onPrimary,
                  size: 44,
                ),
              ),
            ),
            const SizedBox(width: MasirSpace.xl),
            _SkipButton(
              icon: Icons.refresh_rounded,
              label: '۱۵',
              color: _accent,
              onTap: viewModel.nextSecond,
            ),
          ],
        ),
        const SizedBox(height: MasirSpace.xl),
        SpeedWidget(
          color: _accent,
          onChanged: (value) {
            viewModel.updateSpeed(value);
          },
        ),
      ],
    );
  }
}

/// Decorative bar wave doubling as the seek bar.
class _Wave extends StatelessWidget {
  static const int _bars = 40;
  static const double _height = 64;

  final double fraction;
  final Color active;
  final Color idle;
  final ValueChanged<double>? onSeek;

  const _Wave({
    required this.fraction,
    required this.active,
    required this.idle,
    required this.onSeek,
  });

  /// Deterministic pseudo-random bar heights (0.25..1) so the wave looks
  /// natural but never changes between frames.
  static double _barHeight(int i) {
    final v = math.sin(i * 1.7) * 0.5 + math.sin(i * 0.6 + 1) * 0.5;
    return 0.3 + 0.7 * ((v + 1) / 2);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        void seek(double dx) {
          if (onSeek == null || width <= 0) return;
          onSeek!((dx / width).clamp(0.0, 1.0));
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) => seek(d.localPosition.dx),
          onHorizontalDragUpdate: (d) => seek(d.localPosition.dx),
          child: SizedBox(
            height: _height,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (var i = 0; i < _bars; i++) ...[
                  if (i > 0) const Spacer(),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 4,
                    height: _height * _barHeight(i),
                    decoration: BoxDecoration(
                      color: (i + 0.5) / _bars <= fraction ? active : idle,
                      borderRadius: BorderRadius.circular(MasirRadius.pill),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SkipButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SkipButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: SizedBox(
        width: 52,
        height: 52,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: 44, color: color),
            CustomText.micro(label, color: color),
          ],
        ),
      ),
    );
  }
}
