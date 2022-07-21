import 'dart:math';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

import '../../../helper/formated_time.dart';

class CustomProgressBar extends StatefulWidget {
  const CustomProgressBar({Key? key, required this.controller})
      : super(key: key);
  final BetterPlayerController controller;
  @override
  State<CustomProgressBar> createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends State<CustomProgressBar> {
  Widget customProgressBar() {
    final position =
        widget.controller.videoPlayerController?.value.position.inSeconds ?? 0;
    final duration =
        widget.controller.videoPlayerController?.value.duration?.inSeconds ?? 0;

    double currentSpeed = 1.0;

    double progress = position / duration * 100;
    widget.controller.addEventsListener((event) => {
          if (event.betterPlayerEventType == BetterPlayerEventType.progress)
            {
              progress = (event.parameters?['progress'].inSeconds /
                      widget.controller.videoPlayerController?.value.duration
                          ?.inSeconds) ??
                  0,
              setState(() {})
            }
          else if (event.betterPlayerEventType ==
              BetterPlayerEventType.setSpeed)
            {currentSpeed = event.parameters?['speed']}
        });

    if ((duration != 0)) {
      return SliderTheme(
        data: SliderThemeData(
          trackHeight: 3,
          overlayShape: SliderComponentShape.noOverlay,
          activeTrackColor: const Color(0xff1EC5F9),
          inactiveTrackColor: Colors.white.withOpacity(0.5),
          thumbColor: const Color(0xff1EC5F9),
        ),
        child: Slider(
          value: max(0, min(progress, 100)),
          min: 0,
          max: 100,
          divisions: 100,
          label: formatedTime(position),
          onChanged: (value) async {
            var newValue = max(0, min(value, 99)) * 0.01;
            var seconds = (duration * newValue).toInt();
            await widget.controller.seekTo(Duration(seconds: seconds));
            setState(
              () {},
            );
          },
          onChangeStart: (value) {
            widget.controller.pause();
          },
          onChangeEnd: (value) async {
            var newValue = max(0, min(value, 99)) * 0.01;
            var seconds = (duration * newValue).toInt();
            await widget.controller.seekTo(Duration(seconds: seconds));
            widget.controller.play();
          },
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return customProgressBar();
  }
}
