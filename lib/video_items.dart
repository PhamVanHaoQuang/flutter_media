import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoItem extends StatefulWidget {
  const VideoItem({
    Key? key,
    this.looping,
    this.autoplay,
    required this.file,
  }) : super(key: key);

  final bool? looping;
  final bool? autoplay;
  final File file;

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> with WidgetsBindingObserver {
  late ChewieController _chewieController;
  late final VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _videoPlayerController = VideoPlayerController.file(widget.file,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false));
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 5 / 8,
      autoInitialize: true,
      autoPlay: widget.autoplay ?? false,
      looping: widget.looping ?? false,
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
    super.dispose();
    _chewieController.dispose();
    WidgetsBinding.instance?.removeObserver(this);
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
