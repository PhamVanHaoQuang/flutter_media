import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class BuildChangedTrack extends StatelessWidget {
  final Function(BetterPlayerAsmsTrack track) setTrack;
  final BetterPlayerAsmsTrack track;

  const BuildChangedTrack({
    Key? key,
    required this.track,
    required this.setTrack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 0, right: 12, left: 16),
      child: TextButton(
        onPressed: () => setTrack.call(track),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${track.width}x${track.height}',
              style: const TextStyle(color: Colors.black, fontSize: 16),
            )),
      ),
    );
  }
}
