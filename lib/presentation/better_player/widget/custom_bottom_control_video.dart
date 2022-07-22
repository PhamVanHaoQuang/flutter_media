import 'dart:async';
import 'dart:math';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

import '../../../helper/formated_time.dart';
import 'custom_progress_bar.dart';

class CustomBottomControlVideo extends StatefulWidget {
  const CustomBottomControlVideo({Key? key, required this.controller})
      : super(key: key);
  final BetterPlayerController controller;

  @override
  State<CustomBottomControlVideo> createState() =>
      _CustomBottomControlVideoState();
}

class _CustomBottomControlVideoState extends State<CustomBottomControlVideo> {
  double progress = 0;
  int position = 0;

  late bool isMute;
  late int duration;
  @override
  void initState() {
    super.initState();

    _init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    scheduleMicrotask(() async {
      widget.controller.addEventsListener((event) {
        if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
          if (duration == 0) return;
          progress = event.parameters?['progress'].inSeconds / duration;
          position = widget
                  .controller.videoPlayerController?.value.position.inSeconds ??
              0;
          setState(() {});
        }
      });
    });
  }

  @override
  void didUpdateWidget(covariant CustomBottomControlVideo oldWidget) {
    _init();
    super.didUpdateWidget(oldWidget);
  }

  void _init() {
    isMute = (widget.controller.videoPlayerController?.value.volume ?? 0) > 0;

    position =
        widget.controller.videoPlayerController?.value.position.inSeconds ?? 0;
  }

  void getDuration() async {
    if (widget.controller.isVideoInitialized() ?? false) {
      duration =
          widget.controller.videoPlayerController?.value.duration?.inSeconds ??
              0;
    } else {
      duration = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    getDuration();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () async {
                  if (isMute) {
                    widget.controller.setVolume(0);
                  } else {
                    widget.controller.setVolume(1);
                  }
                  setState(() {});
                },
                child: (isMute)
                    ? const Icon(
                        Icons.volume_up_outlined,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.volume_off_outlined,
                        color: Colors.white,
                      ),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                formatedTime(widget.controller.videoPlayerController?.value
                            .position.inSeconds ??
                        0) +
                    ' / ' +
                    formatedTime(widget.controller.videoPlayerController?.value
                            .duration?.inSeconds ??
                        0),
              ),
              Expanded(
                child: CustomProgressBar(
                  progress: progress,
                  position: position,
                  onChangeStart: (value) {
                    widget.controller.pause();
                  },
                  onChanged: (value) {
                    var newValue = max(1, min(value, 99)) * 0.01;
                    var seconds = (duration * newValue).toInt();
                    widget.controller.seekTo(Duration(seconds: seconds));
                    setState(() {});
                  },
                  onChangeEnd: (value) async {
                    var newValue = max(1, min(value, 99)) * 0.01;
                    var seconds = (duration * newValue).toInt();
                    await widget.controller.seekTo(Duration(seconds: seconds));
                    widget.controller.play();
                  },
                ),
              ),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Icon(
                    widget.controller.isFullScreen
                        ? Icons.fullscreen_exit
                        : Icons.fullscreen,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                onTap: () {
                  if (widget.controller.isFullScreen) {
                    widget.controller.exitFullScreen();
                  } else {
                    widget.controller.enterFullScreen();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
