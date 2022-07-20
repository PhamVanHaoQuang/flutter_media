import 'package:flutter/material.dart';

class CustomTopControlVideo extends StatelessWidget {
  final VoidCallback ?onBack;
  final VoidCallback onShowBottomSheet;
  const CustomTopControlVideo({Key? key, required this.onShowBottomSheet,this.onBack})
      : super(key: key);

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
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.chevron_left_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              onTap: onBack ?? () => Navigator.pop(context),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: onShowBottomSheet,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.more_vert_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
