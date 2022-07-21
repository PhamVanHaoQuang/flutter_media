import 'package:flutter/material.dart';

class CustomTopControlVideo extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback onShowBottomSheet;
  const CustomTopControlVideo(
      {Key? key, required this.onShowBottomSheet, this.onBack})
      : super(key: key);

  @override
  State<CustomTopControlVideo> createState() => _CustomTopControlVideoState();
}

class _CustomTopControlVideoState extends State<CustomTopControlVideo> {
  bool isSwitched = true;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.chevron_left_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              onTap: widget.onBack ?? () => Navigator.pop(context),
            ),
          ),
        ),
        Row(
          children: [
            InkWell(
              onTap: widget.onShowBottomSheet,
              child: Switch(
                activeColor: const Color(0xff1EC5F9),
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = !isSwitched;
                  });
                },
              ),
            ),
            InkWell(
              onTap: widget.onShowBottomSheet,
              child: const Icon(
                Icons.settings_outlined,
                color: Colors.white,
                size: 21,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, bottom: 8, top: 8, right: 12),
              child: InkWell(
                onTap: widget.onShowBottomSheet,
                child: const Icon(
                  Icons.more_vert_outlined,
                  color: Colors.white,
                  size: 21,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
