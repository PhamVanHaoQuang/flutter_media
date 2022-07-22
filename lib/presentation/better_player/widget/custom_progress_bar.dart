import 'dart:math';
import 'package:flutter/material.dart';

import '../../../helper/formated_time.dart';

class CustomProgressBar extends StatefulWidget {
  const CustomProgressBar(
      {Key? key,
      required this.progress,
      required this.position,
      required this.onChanged,
      required this.onChangeEnd,
      required this.onChangeStart})
      : super(key: key);
  final double progress;
  final int position;
  final void Function(double newValue) onChanged;
  final void Function(double value) onChangeStart;
  final void Function(double value) onChangeEnd;
  @override
  State<CustomProgressBar> createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends State<CustomProgressBar> {
  late double progress;
  late int position;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant CustomProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _init();
  }

  void _init() {
    progress = widget.progress * 100;
    position = widget.position;
  }

  Widget customProgressBar() {
    return progress != 0
        ? SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              overlayShape: SliderComponentShape.noOverlay,
              activeTrackColor: const Color(0xff1EC5F9),
              inactiveTrackColor: Colors.white.withOpacity(0.5),
              thumbColor: const Color(0xff1EC5F9),
            ),
            child: Slider(
              value: max(0, min(progress, 100)),
              min: 0,
              max: 100,
              divisions: 100,
              label: formatedTime(position),
              onChanged: widget.onChanged,
              onChangeStart: widget.onChangeStart,
              onChangeEnd: widget.onChangeEnd,
            ),
          )
        : const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return customProgressBar();
  }
}
