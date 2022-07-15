import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  List<BetterPlayerAsmsTrack> listTracks = [];

  @override
  void initState() {
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.linkUrl,
      resolutions: {'360p': '', '720p': '', '1080p': ''},
    );
    betterPlayerConfiguration = const BetterPlayerConfiguration(
        autoPlay: true,
        looping: false,
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        aspectRatio: 16 / 9,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableQualities: true,
        ));
    controller = BetterPlayerController(betterPlayerConfiguration,
        betterPlayerDataSource: betterPlayerDataSource);
    controller.addEventsListener(_videoEventsListener);
    super.initState();
  }

  _videoEventsListener(BetterPlayerEvent event) {
    switch (event.betterPlayerEventType) {
      case BetterPlayerEventType.initialized:
        final tracks = controller.betterPlayerAsmsTracks;
        setState(() {
          listTracks = controller.betterPlayerAsmsTracks;
        });
        tracks.forEach((element) {
          print('###track width ${element.width}, height ${element.height}');
          print(
              '###track bitrate ${element.bitrate}, codecs ${element.codecs}');
          print(
              '###track frameRate ${element.frameRate}, mimeType ${element.mimeType}');
        });
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
        print('changedTrack');
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
        print('');
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
            Expanded(
                child: Center(
                    child: ListView(
                        children: listTracks.map(_buildChangeTrack).toList())))
          ],
        ),
      ),
    );
  }

  Widget _buildChangeTrack(BetterPlayerAsmsTrack track) {
    return Padding(
        padding: const EdgeInsets.all(12),
        child: OutlinedButton(
            onPressed: () {
              controller.setTrack(track);
            },
            child: Text('${track.width}x${track.height}')));
  }
}
