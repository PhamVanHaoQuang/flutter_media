import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoYoutubeScreen extends StatefulWidget {
  final String videoLink;
  const VideoYoutubeScreen({
    Key? key,
    required this.videoLink,
  }) : super(key: key);
  @override
  State<VideoYoutubeScreen> createState() => _VideoYoutubeScreenState();
}

class _VideoYoutubeScreenState extends State<VideoYoutubeScreen> {
  late YoutubePlayerController controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  //double _volume = 100;
  // bool _muted = false;
  // bool _isPlayerReady = false;
  bool _initialLoad = true;

  @override
  void initState() {
    super.initState();
    controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoLink) ?? '',
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _videoMetaData = controller.metadata;
    _playerState = PlayerState.unknown;
  }

  void listener() async {
    if (controller.value.isReady && _initialLoad) {
      _initialLoad = false;
      if (controller.flags.autoPlay) controller.play();
      if (controller.flags.mute) controller.mute();
      //widget.onReady?.call();
      if (controller.flags.controlsVisibleAtStart) {
        controller.updateValue(
          controller.value.copyWith(isControlsVisible: true),
        );
      }
    }
    if (mounted) setState(() {});
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.blueAccent,
          progressColors: ProgressBarColors(
            playedColor: const Color(0xff1EC5F9),
            backgroundColor: Colors.white.withOpacity(0.5),
          ),
          topActions: <Widget>[
            const SizedBox(width: 4.0),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded)),
            Expanded(
              child: Text(
                controller.metadata.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.more_vert_outlined,
                color: Colors.white,
                size: 25.0,
              ),
              onPressed: () {},
            ),
          ],
          //bottomActions: [],
          onReady: () {
            controller.addListener(() {});
          },
          // onEnded: (data) {
          //   _controller
          //       .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
          //   // _showSnackBar('Next Video Started!');
          // },
        ),
        builder: (context, player) => Column(children: [
          player,
          SizedBox(
            height: size.height * 19 / 896,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: size.width * 16 / 414, right: size.width * 16 / 414),
            child: Text(
              controller.metadata.title,
              style: const TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ]),
      ),
    );
  }
}
