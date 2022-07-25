import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_learn/presentation/better_player/widget/custom_control.dart';

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
  final GlobalKey<ScaffoldState> videoScaffold = GlobalKey();

  List<BetterPlayerAsmsTrack> listTracks = [];

  double currentSpeed = 1.0;
  late Timer? timeToHideControl;
  // int _timeRemain = 3;
  var _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.linkUrl,
      // subtitles: [
      //   BetterPlayerSubtitlesSource(
      //     type: BetterPlayerSubtitlesSourceType.network,
      //     name: 'VN',
      //      urls: [
      //       "https://cdnstatic.mcvgo.vn/subtitle/srt/Bad Guys The Movie (2019).vie.srt"
      //     ],
      //   ),
      //   BetterPlayerSubtitlesSource(
      //     type: BetterPlayerSubtitlesSourceType.network,
      //     name: 'EN',
      //      urls: [
      //       "https://cdnstatic.mcvgo.vn/subtitle/srt/the-bad-guys-reign-of-chaos_english.rtt"
      //     ],
      //   )
      // ]
    );

    betterPlayerConfiguration = BetterPlayerConfiguration(
        autoPlay: true,
        looping: false,
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.portraitUp,
        ],
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
    controller = BetterPlayerController(
      betterPlayerConfiguration,
      betterPlayerDataSource: betterPlayerDataSource,
    );
    controller.addEventsListener(_videoEventsListener);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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

  final GlobalKey _betterPlayerKey = GlobalKey();

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
                  key: _betterPlayerKey,
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
    return GestureDetector(
      onTap: () {
        if (_opacity == 0.0) {
          _opacity = 1.0;
        } else {
          _opacity = 0.0;
        }
        setState(() {});
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 600),
        child: CustomController(
          controller: controller,
          listTracks: listTracks,
          onControlsVisibilityChanged: onControlsVisibilityChanged,
          globalKey: _betterPlayerKey,
          
        ),
      ),
    );
  }
}




  // timeToHideControl = Timer(const Duration(seconds: 3), () {
  //           if (_timeRemain == 0) {
  //             _opacity = 0;
  //             timeToHideControl?.cancel();
  //             setState(() {});
  //           } else {
  //             _opacity = 1.0;
  //             setState(() {
  //               _timeRemain--;
  //             });
  //           }
  //         });

  //  timeToHideControl?.cancel();

// isHide
// func show()
// func hide()
// startCountDown()
// cancelCountDown()
//
// if(isHide){
    // show();
    // startCountDown();
      // if countDown ==0 {
      //    hide();
      //    cancelCountDown();
      // } else {
      //    show();
      //    startCountDown();
      // }
      // 
      // 
// } else {
  // hide();
  // cancelCountDown()'
// }
