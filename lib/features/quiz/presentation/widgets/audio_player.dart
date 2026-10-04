import 'package:easy_helper/easy_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/features/quiz/presentation/widgets/speed_widget.dart';
import 'package:mohammad/widgets/chunky_box.dart';
import 'package:mohammad/widgets/custom_text.dart';

import '../bloc/audio/audio_state.dart';
import '../bloc/audio/audio_view_model.dart';
import '/core/theme/theme_context.dart';

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

  Color get _trackActive => context.colors.primary;
  Color get _trackInactive => context.colors.primaryTint;
  Color get _thumbColor => context.colors.primary;

  Widget _buildProgressSection({
    required double currentTime,
    required double fullTime,
    required String elapsedLabel,
    required String totalLabel,
    required ValueChanged<double>? onSeek,
  }) {
    final safeMax = fullTime > 0 ? fullTime : 1.0;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                CustomText(
                  elapsedLabel,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: context.colors.inkMuted,
                ),
                const Spacer(),
                CustomText(totalLabel, fontSize: 12, fontWeight: FontWeight.w700, color: context.colors.inkMuted),
              ],
            ),
          ),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 8,
              trackShape: const RoundedRectSliderTrackShape(),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: SliderComponentShape.noOverlay,
              activeTrackColor: _trackActive,
              inactiveTrackColor: _trackInactive,
              thumbColor: _thumbColor,
            ),
            child: Slider(
              value: currentTime.clamp(0, safeMax),
              min: 0,
              max: safeMax,
              onChanged: onSeek,
            ),
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
              return CustomText(
                state.message,
                fontSize: 13,
                color: context.colors.primary,
              );
            }
            if (state is AudioLoadingState) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: CircularProgressIndicator(color: context.colors.primary),
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
        const SizedBox(height: 21),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SkipButton(
              icon: Icons.replay_rounded,
              label: '۱۵',
              onTap: viewModel.previousSecond,
            ),
            16.w,
            // OnClick(
            //   onTap: () {
            //     if (widget.index >= 1) {
            //       widget.index -= 1;
            //       viewModel.previousAudio();
            //       widget.onChanged(widget.index);
            //     }
            //   },
            //   child: Container(
            //     width: 32,
            //     height: 32,
            //     margin: const EdgeInsets.symmetric(horizontal: 11),
            //     decoration: BoxDecoration(
            //       border: Border.all(color: widget.color, width: 2),
            //       shape: BoxShape.circle,
            //     ),
            //     alignment: AlignmentDirectional.center,
            //     child: SvgPicture.asset(
            //       "assets/quiz/previous_audio.svg",
            //       color: widget.color,
            //     ),
            //   ),
            // ),
            BlocBuilder(
              bloc: viewModel,
              buildWhen: (previous, current) => current is AudioPlayState,
              builder: (context, state) => ChunkyBox(
                fill: context.colors.primary,
                edge: context.colors.primaryEdge,
                radius: 40,
                width: 80,
                height: 84,
                alignment: Alignment.center,
                onTap: viewModel.onPressed,
                child: AnimatedIcon(
                  icon: AnimatedIcons.pause_play,
                  progress: viewModel.animationController,
                  color: context.colors.onPrimary,
                  size: 40,
                ),
              ),
            ),
            16.w,
            // OnClick(
            //   onTap: () {
            //     if (widget.index < widget.list.length - 1) {
            //       widget.index += 1;
            //       viewModel.nextAudio();
            //       widget.onChanged(widget.index);
            //     }
            //   },
            //   child: Container(
            //     width: 32,
            //     height: 32,
            //     margin: const EdgeInsets.symmetric(horizontal: 11),
            //     decoration: BoxDecoration(
            //       border: Border.all(color: widget.color, width: 2),
            //       shape: BoxShape.circle,
            //     ),
            //     alignment: AlignmentDirectional.center,
            //     child: SvgPicture.asset(
            //       "assets/quiz/next_audio.svg",
            //       color: widget.color,
            //     ),
            //   ),
            // ),
            _SkipButton(
              icon: Icons.refresh_rounded,
              label: '۱۵',
              onTap: viewModel.nextSecond,
            ),
          ],
        ),
        20.h,
        SpeedWidget(
          color: context.colors.primary,
          onChanged: (value) {
            viewModel.updateSpeed(value);
          },
        ),
      ],
    );
  }
}

class _SkipButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SkipButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return OnClick(
      onTap: onTap,
      child: SizedBox(
        width: 52,
        height: 52,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: 44, color: c.primary),
            CustomText(
              label,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: c.primary,
            ),
          ],
        ),
      ),
    );
  }
}
