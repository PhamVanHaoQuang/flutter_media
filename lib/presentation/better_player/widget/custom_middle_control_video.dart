import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class CustomMiddleControlVideo extends StatefulWidget {
  final BetterPlayerController controller;
  const CustomMiddleControlVideo({Key? key, required this.controller})
      : super(key: key);

  @override
  State<CustomMiddleControlVideo> createState() =>
      _CustomMiddleControlVideoState();
}

class _CustomMiddleControlVideoState extends State<CustomMiddleControlVideo> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            Duration? videoDuration =
                await widget.controller.videoPlayerController?.position;
            setState(() {
              if (widget.controller.isPlaying()!) {
                Duration rewindDuration =
                    Duration(seconds: (videoDuration!.inSeconds - 2));
                if (rewindDuration <
                    widget.controller.videoPlayerController!.value.duration!) {
                  widget.controller.seekTo(const Duration(seconds: 0));
                } else {
                  widget.controller.seekTo(rewindDuration);
                }
              }
            });
          },
          child: const Icon(
            Icons.replay_10_rounded,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          width: 32,
        ),
        InkWell(
          onTap: () {
            setState(() {
              if (widget.controller.isPlaying()!) {
                widget.controller.pause();
              } else {
                widget.controller.play();
              }
            });
          },
          child: Icon(
            widget.controller.isPlaying()! ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          width: 32,
        ),
        InkWell(
          onTap: () async {
            Duration? videoDuration =
                await widget.controller.videoPlayerController?.position;
            setState(() {
              if (widget.controller.isPlaying()!) {
                Duration forwardDuration =
                    Duration(seconds: (videoDuration!.inSeconds + 2));
                if (forwardDuration >
                    widget.controller.videoPlayerController!.value.duration!) {
                  widget.controller.seekTo(const Duration(seconds: 0));
                  widget.controller.pause();
                } else {
                  widget.controller.seekTo(forwardDuration);
                }
              }
            });
          },
          child: const Icon(
            Icons.forward_10_rounded,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
