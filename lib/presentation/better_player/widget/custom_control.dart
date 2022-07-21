import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'build_change_track.dart';
import 'build_speed.dart';
import 'custom_bottom_control_video.dart';
import 'custom_middle_control_video.dart';
import 'custom_top_control_video.dart';

class CustomController extends StatefulWidget {
  const CustomController(
      {Key? key,
      required this.controller,
      required this.onControlsVisibilityChanged,
      required this.listTracks})
      : super(key: key);
  final BetterPlayerController controller;
  final List<BetterPlayerAsmsTrack> listTracks;
  final Function(bool visbility) onControlsVisibilityChanged;
  @override
  State<CustomController> createState() => _MyControllerState();
}

class _MyControllerState extends State<CustomController> {
  List<double> listSpeed = [0.25, 0.5, 1.0, 1.5, 1.75, 2.0];
  double currentSpeed = 1.0;
  BetterPlayerAsmsTrack? currentTrack;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTopControlVideo(
                onShowBottomSheet: showBottomSheet,
              ),
              CustomMiddleControlVideo(
                controller: widget.controller,
              ),
              CustomBottomControlVideo(
                controller: widget.controller,
              )
            ],
          ),
        ),
      ],
    );
  }

  void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Padding(
        padding:
            const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Cài đặt',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            InkWell(
              onTap: showQuanlityBottomSheet,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Quanlity',
                            style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            currentTrack != null
                                ? '${currentTrack!.height}p60'
                                : '',
                            style: const TextStyle(
                                color: Color(0xff8A8A8A),
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                          const Icon(
                            Icons.navigate_next_outlined,
                            color: Color(0xff8A8A8A),
                          ),
                          const SizedBox(
                            width: 8,
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: showSpeedBottomSheet,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Speed',
                        style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        currentSpeed.toString(),
                        style: const TextStyle(
                            color: Color(0xff8A8A8A),
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                      const Icon(
                        Icons.navigate_next_outlined,
                        color: Color(0xff8A8A8A),
                      ),
                      const SizedBox(
                        width: 8,
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            InkWell(
              onTap: () {},
              child: Row(
                children: const [
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Subtitles',
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showQuanlityBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Padding(
        padding:
            const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  child: const Icon(
                    Icons.chevron_left_outlined,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  'Cài đặt',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 420),
              child: ListView(
                shrinkWrap: true,
                children: widget.listTracks
                    .map((track) => BuildChangedTrack(
                        track: track,
                        setTrack: (value) {
                          widget.controller.setTrack(track);
                          currentTrack = value;
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSpeedBottomSheet() {
    final orientation = MediaQuery.of(context).orientation;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Padding(
        padding:
            const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                InkWell(
                  child: const Icon(
                    Icons.chevron_left_outlined,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  'Cài đặt',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ConstrainedBox(
              constraints: (orientation == Orientation.portrait)
                  ? const BoxConstraints(maxHeight: 350)
                  : const BoxConstraints(maxHeight: 200),
              child: ListView(
                // shrinkWrap: true,
                children: listSpeed
                    .map((speed) => BuildSpeed(
                          setPlaybackSpeed: (value) {
                            widget.controller.setSpeed(value);

                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            currentSpeed = value;
                          },
                          speed: speed,
                          currentSpeed: currentSpeed,
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );

    void setTrack(BetterPlayerAsmsTrack track) {
      widget.controller.setTrack(track);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }
}
