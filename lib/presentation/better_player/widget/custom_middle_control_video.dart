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
                    Duration(seconds: (videoDuration!.inSeconds - 10));
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
            size: 24,
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        // InkWell(
        //   onTap: () {},
        //   child: const Icon(
        //     Icons.fast_rewind,
        //     color: Colors.white,
        //     size: 30,
        //   ),
        // ),
        const SizedBox(
          width: 26,
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
            size: 30,
          ),
        ),
        const SizedBox(
          width: 26,
        ),
        // InkWell(
        //   onTap: () {},
        //   child: const Icon(
        //     Icons.fast_forward,
        //     color: Colors.white,
        //     size: 30,
        //   ),
        // ),
        const SizedBox(
          width: 16,
        ),
        InkWell(
          onTap: () async {
            Duration? videoDuration =
                await widget.controller.videoPlayerController?.position;

            if (widget.controller.isPlaying()!) {
              Duration forwardDuration =
                  Duration(seconds: (videoDuration!.inSeconds + 10));
              setState(() {
                if (forwardDuration >
                    widget.controller.videoPlayerController!.value.duration!) {
                  widget.controller.seekTo(Duration(
                      seconds: widget.controller.videoPlayerController!.value
                              .duration?.inSeconds ??
                          0));
                  widget.controller.pause();
                } else {
                  widget.controller.seekTo(forwardDuration);
                }
              });
            }
          },
          child: const Icon(
            Icons.forward_10_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }
}
