import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_learn/model/m3u8.dart';
import 'package:gallery_saver/files.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class VideoItem extends StatefulWidget {
  const VideoItem({
    Key? key,
    this.looping,
    this.autoplay,
    this.file,
    this.link,
  }) : super(key: key);

  final bool? looping;
  final bool? autoplay;
  final File? file;
  final String? link;

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> with WidgetsBindingObserver {
  late ChewieController _chewieController;
  late final VideoPlayerController _videoPlayerController;

  Future<void> parseLink(String? link) async {
    final Map<String, String> header = {
      'content-type': 'application/x-www-form-urlencoded'
    };
    var response = await http.get(Uri.parse(link ?? ''), headers: header);

    print('Response body: ${response.body}');
    print('quangaaaa');
    splitData(response.body);
  }

  void splitData(String data) {
    List _masForUsing = data.split('\n \n');
    print(_masForUsing);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    parseLink(widget.link);

    (widget.link == null)
        ? _videoPlayerController = VideoPlayerController.file(
            widget.file!,
            videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false),
          )
        : _videoPlayerController = VideoPlayerController.network(
            widget.link!,
            videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false),
          );
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
      autoInitialize: true,

      // additionalOptions: (context) {
      //   return <OptionItem>[
      //     OptionItem(
      //         onTap: () {},
      //         iconData: Icons.arrow_back_ios_new_rounded,
      //         title: 'Back Button')
      //   ];
      // },
      autoPlay: widget.autoplay ?? false,
      looping: widget.looping ?? false,
      allowFullScreen: true,
      progressIndicatorDelay: const Duration(seconds: 1),
      customControls: const MaterialControls(showPlayButton: true),
      // customControls: const CupertinoControls(
      //   backgroundColor: Colors.white30,
      //   iconColor: Colors.white,
      //   showPlayButton: true,
      // ),
      useRootNavigator: true,
      hideControlsTimer: const Duration(seconds: 2),
      materialProgressColors: ChewieProgressColors(playedColor: Colors.white),
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState currentState) {
    if (currentState == AppLifecycleState.paused) {
      _videoPlayerController.pause();
    }
    if (currentState == AppLifecycleState.resumed) {
      // _videoPlayerController.setLooping(false);
      _videoPlayerController.play();
    }
  }

  @override
  void dispose() {
    _chewieController.dispose();
    _videoPlayerController.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }
}
