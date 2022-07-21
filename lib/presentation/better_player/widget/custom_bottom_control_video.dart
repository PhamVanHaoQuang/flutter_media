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
  @override
  Widget build(BuildContext context) {
    final isMute =
        (widget.controller.videoPlayerController?.value.volume ?? 0) > 0;
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
                controller: widget.controller,
              )),
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
