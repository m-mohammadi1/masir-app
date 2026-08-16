import 'package:easy_helper/easy_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/features/quiz/presentation/widgets/speed_widget.dart';
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

  Color get _trackActive => context.colors.primary.withValues(alpha: .45);
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
                  fontSize: 10,
                  color: context.colors.inkMuted,
                ),
                const Spacer(),
                CustomText(totalLabel, fontSize: 10, color: context.colors.inkMuted),
              ],
            ),
          ),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
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
            OnClick(
              onTap: viewModel.previousSecond,
              child: Container(
                width: 37,
                height: 32,
                alignment: AlignmentDirectional.center,
                child: Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    // SvgPicture.asset(
                    //   "assets/quiz/previous_second.svg",
                    //   // color: widget.color,
                    //   width: 37,
                    //   height: 32,
                    // ),
                    Container(height: 12.6, width: 12, color: context.colors.surface),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 5),
                        child: CustomText(
                          "15s",
                          fontSize: 12,
                          color: context.colors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
              builder: (context, state) => OnClick(
                onTap: viewModel.onPressed,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: context.colors.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: AlignmentDirectional.center,
                  child: AnimatedIcon(
                    icon: AnimatedIcons.pause_play,
                    progress: viewModel.animationController,
                    color: context.colors.white,
                    size: 50,
                  ),
                ),
              ),
            ),
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
            OnClick(
              onTap: viewModel.nextSecond,
              child: Container(
                width: 37,
                height: 32,
                alignment: AlignmentDirectional.center,
                child: Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    // SvgPicture.asset(
                    //   "assets/quiz/next_second.svg",
                    //   color: context.colors.primary,
                    //   width: 37,
                    //   height: 32,
                    // ),
                    Container(height: 12.6, width: 12, color: context.colors.surface),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 7),
                        child: CustomText(
                          "15s",
                          fontSize: 10,
                          color: context.colors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
