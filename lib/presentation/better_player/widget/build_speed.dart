import 'package:flutter/material.dart';

class BuildSpeed extends StatelessWidget {
  final double speed;
  final double currentSpeed;
  final Function(double speed) setPlaybackSpeed;

  const BuildSpeed({
    Key? key,
    required this.setPlaybackSpeed,
    required this.speed,
    required this.currentSpeed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 0, right: 12, left: 16),
      child: TextButton(
        onPressed: () => setPlaybackSpeed.call(speed),
        child: Align(
          alignment: Alignment.centerLeft,
          child: (speed != currentSpeed)
              ? Text(
                  (speed != 1.0)
                      ? speed.toString()
                      : (speed.toString() + ' (chuẩn)'),
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                )
              : Text(
                  (speed != 1.0)
                      ? speed.toString()
                      : (speed.toString() + ' (chuẩn)'),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
