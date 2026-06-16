import 'package:easy_helper/easy_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mohammad/core/helper/custom_colors.dart';
import 'package:mohammad/features/quiz/presentation/widgets/speed_widget.dart';
import 'package:mohammad/widgets/custom_text.dart';

import '../bloc/audio/audio_state.dart';
import '../bloc/audio/audio_view_model.dart';

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
    viewModel = AudioViewModel(this,widget.url);
    viewModel.updateSpeed(1);
    super.initState();
  }

  int currentTime = 0;

  @override
  Widget build(BuildContext context) {
    print('audio url is : ${widget.url}');
    return Column(
      children: [
        SizedBox(
          height: 20,
          child: BlocConsumer(
            bloc: viewModel,
            buildWhen: (previous, current) => current is AudioCurrentTimeState,
            listener: (context, state) {},
            builder: (context, state) {
              if (state is AudioCurrentTimeState) {
                return Padding(
                  padding: const EdgeInsetsDirectional.only(start: 50, end: 48),
                  child: Row(
                    children: [
                      CustomText(state.time, fontSize: 10),
                      const Spacer(),
                      CustomText(state.current, fontSize: 10),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsetsDirectional.only(start: 50, end: 48),
                  child: Row(
                    children: [
                      CustomText("00:00", fontSize: 10,),
                      const Spacer(),
                      CustomText("00:00", fontSize: 10,),
                    ],
                  ),
                );
              }
            },
          ),
        ),
        BlocBuilder(
          bloc: viewModel,
          buildWhen: (previous, current) => current is AudioCurrentTimeState,
          builder: (context, state) {
            if (state is AudioCurrentTimeState) {
              currentTime = state.currentTime.toInt();
              return Padding(
                padding: const EdgeInsetsDirectional.only(start: 30, end: 28),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 20,
                  child: Slider(
                    value: state.currentTime,
                    min: 0,
                    max: state.fullTime,
                    // activeColor: widget.color,
                    // inactiveColor: border,
                    onChanged: viewModel.seekTo,
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsetsDirectional.only(start: 30, end: 28),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 20,
                  child: Slider(
                    value: 0,
                    min: 0,
                    max: 100,
                    // activeColor: widget.color,
                    // inactiveColor: border,
                    onChanged: (double value) {},
                  ),
                ),
              );
            }
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
                    SvgPicture.asset(
                      "assets/quiz/previous_second.svg",
                      // color: widget.color,
                      width: 37,
                      height: 32,
                    ),
                    Container(height: 12.6, width: 12, color: AppColor.white),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 5),
                        child: CustomText(
                          "15s",
                         fontSize: 12,
                          color: AppColor.primary,
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
                    color: AppColor.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: AlignmentDirectional.center,
                  child: AnimatedIcon(
                    icon: AnimatedIcons.pause_play,
                    progress: viewModel.animationController,
                    color: AppColor.white,
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
                    SvgPicture.asset(
                      "assets/quiz/next_second.svg",
                      color: AppColor.primary,
                      width: 37,
                      height: 32,
                    ),
                    Container(height: 12.6, width: 12, color: Colors.white),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 7),
                        child: CustomText(
                          "15s",
                            fontSize: 10,
                            color: AppColor.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        SpeedWidget(
          color: AppColor.primary,
          onChanged: (value) {
            viewModel.updateSpeed(value);
          },
        ),
      ],
    );
  }
}
