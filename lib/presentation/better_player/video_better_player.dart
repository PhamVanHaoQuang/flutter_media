import 'dart:math';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_learn/helper/formated_time.dart';
import 'package:flutter_learn/presentation/better_player/widget/build_change_track.dart';
import 'package:flutter_learn/presentation/better_player/widget/build_speed.dart';
import 'package:flutter_learn/presentation/better_player/widget/custom_middle_control_video.dart';
import 'package:flutter_learn/presentation/better_player/widget/custom_top_control_video.dart';

class VideoBetterPlayerScreen extends StatefulWidget {
  final String linkUrl;
  const VideoBetterPlayerScreen({
    Key? key,
    required this.linkUrl,
  }) : super(key: key);

  @override
  State<VideoBetterPlayerScreen> createState() =>
      _VideoBetterPlayerScreenState();
}

class _VideoBetterPlayerScreenState extends State<VideoBetterPlayerScreen> {
  late BetterPlayerConfiguration betterPlayerConfiguration;
  late BetterPlayerController controller;
  double? progress = 0.0;
  final GlobalKey<ScaffoldState> videoScaffold = GlobalKey();

  List<BetterPlayerAsmsTrack> listTracks = [];
  List<double> listSpeed = [0.25, 0.5, 1.0, 1.5, 1.75, 2.0];
  double currentSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.linkUrl,
      // resolutions: {'360p60': '', '720p60': '', '1080p60': ''},
    );

    betterPlayerConfiguration = BetterPlayerConfiguration(
        autoPlay: true,
        looping: false,
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        deviceOrientationsOnFullScreen: [
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft
        ],
        aspectRatio: 16 / 9,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          // enableProgressText: false,
          enableQualities: true,
          enablePip: true,
          playerTheme: BetterPlayerTheme.custom,
          customControlsBuilder: _customControl,
        ));
    controller = BetterPlayerController(betterPlayerConfiguration,
        betterPlayerDataSource: betterPlayerDataSource);
    controller.addEventsListener(_videoEventsListener);
  }

  _videoEventsListener(BetterPlayerEvent event) {
    switch (event.betterPlayerEventType) {
      case BetterPlayerEventType.initialized:
        setState(() {
          listTracks = controller.betterPlayerAsmsTracks;
        });
        for (var element in listTracks) {
          print('###track width ${element.width}, height ${element.height}');
          print(
              '###track bitrate ${element.bitrate}, codecs ${element.codecs}');
          print(
              '###track frameRate ${element.frameRate}, mimeType ${element.mimeType}');
        }
        break;
      case BetterPlayerEventType.play:
        print('###play');
        break;
      case BetterPlayerEventType.pause:
        print('pause');
        break;
      case BetterPlayerEventType.seekTo:
        print('seekTo');
        break;
      case BetterPlayerEventType.openFullscreen:
        print('openFullscreen');
        break;
      case BetterPlayerEventType.hideFullscreen:
        print('');
        break;
      case BetterPlayerEventType.setVolume:
        print('');
        break;
      case BetterPlayerEventType.progress:
        print('');
        break;
      case BetterPlayerEventType.finished:
        print('');
        break;
      case BetterPlayerEventType.exception:
        print('');
        break;
      case BetterPlayerEventType.controlsVisible:
        print('');
        break;
      case BetterPlayerEventType.controlsHiddenStart:
        print('');
        break;
      case BetterPlayerEventType.controlsHiddenEnd:
        print('');
        break;
      case BetterPlayerEventType.setSpeed:
        print('');
        break;
      case BetterPlayerEventType.changedSubtitles:
        print('');
        break;
      case BetterPlayerEventType.changedTrack:
        var a = controller.betterPlayerAsmsTrack;
        // controller.
        // print(controller.betterPlayerAsmsTrack?.height);
        print('changedTrack ${a?.height}');
        // controller.setTrack(listTracks[1]);
        break;
      case BetterPlayerEventType.changedPlayerVisibility:
        print('');
        break;
      case BetterPlayerEventType.changedResolution:
        print('changedResolution');
        break;
      case BetterPlayerEventType.pipStart:
        print('');
        break;
      case BetterPlayerEventType.pipStop:
        print('');
        break;
      case BetterPlayerEventType.setupDataSource:
        print('setupDataSource ');
        break;
      case BetterPlayerEventType.bufferingStart:
        print('');
        break;
      case BetterPlayerEventType.bufferingUpdate:
        print('');
        break;
      case BetterPlayerEventType.bufferingEnd:
        print('');
        break;
      case BetterPlayerEventType.changedPlaylistItem:
        print('');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        key: videoScaffold,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 253 / 896,
              width: size.width,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: BetterPlayer(
                  controller: controller,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customControl(BetterPlayerController controller,
      Function(bool visbility) onControlsVisibilityChanged) {
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
                controller: controller,
              ),
              //   _customMiddleVideo(),
              _customBottomVideo()
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
                children: listTracks
                    .map((track) =>
                        BuildChangedTrack(track: track, setTrack: setTrack))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setTrack(BetterPlayerAsmsTrack track) {
    controller.setTrack(track);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void showSpeedBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
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
            ListView(
              shrinkWrap: true,
              children: listSpeed
                  .map((speed) => BuildSpeed(
                        setPlaybackSpeed: setPlaybackSpeed,
                        speed: speed,
                        currentSpeed: currentSpeed,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void setPlaybackSpeed(double speed) {
    controller.setSpeed(speed);

    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  Widget _customBottomVideo() {
    final isMute = (controller.videoPlayerController?.value.volume ?? 0) > 0;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
        ),
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
                      controller.setVolume(0);
                    } else {
                      controller.setVolume(1);
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
                Expanded(child: customProgressBar()),
                Text(
                  formatedTime(controller
                          .videoPlayerController?.value.duration?.inSeconds ??
                      0),
                ),
                const SizedBox(
                  width: 4,
                ),
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        controller.isFullScreen
                            ? Icons.fullscreen_exit
                            : Icons.fullscreen,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  onTap: () {
                    if (controller.isFullScreen) {
                      controller.exitFullScreen();
                    } else {
                      controller.enterFullScreen();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget customProgressBar() {
    final position =
        controller.videoPlayerController?.value.position.inSeconds ?? 0;
    final duration =
        controller.videoPlayerController?.value.duration?.inSeconds ?? 0;
    final head =
        controller.videoPlayerController?.value.position.inSeconds ?? 0;
    final remained = max(0, duration - head);
    final timeRemained = formatedTime(remained);

    progress = position / duration * 100;
    controller.addEventsListener((event) => {
          if (event.betterPlayerEventType == BetterPlayerEventType.progress)
            {
              progress = (event.parameters?['progress'].inSeconds /
                      controller
                          .videoPlayerController?.value.duration?.inSeconds) ??
                  0,
              setState(() {})
            }
          else if (event.betterPlayerEventType ==
              BetterPlayerEventType.setSpeed)
            {currentSpeed = event.parameters?['speed']}
        });

    if ((duration != 0)) {
      return Slider(
        value: max(0, min(progress ?? 0, 100)),
        min: 0,
        max: 100,
        divisions: 100,
        label: timeRemained,
        onChanged: (value) {
          setState(
            () {
              controller.addEventsListener(
                (event) => {
                  if (event.betterPlayerEventType ==
                      BetterPlayerEventType.progress)
                    {
                      progress = (event.parameters?['progress'].inSeconds /
                          controller
                              .videoPlayerController?.value.duration?.inSeconds)
                    }
                },
              );
            },
          );
        },
        onChangeStart: (value) {
          controller.pause();
        },
        onChangeEnd: (value) async {
          var newValue = max(0, min(value, 99)) * 0.01;
          var seconds = (duration * newValue).toInt();
          await controller.seekTo(Duration(seconds: seconds));
          controller.play();
        },
      );
    } else {
      return Container();
    }
  }
}
