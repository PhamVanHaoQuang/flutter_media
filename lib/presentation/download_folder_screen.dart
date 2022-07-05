import 'package:flutter/material.dart';

class DownloadFolderItemWidget extends StatelessWidget {
  const DownloadFolderItemWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
     this.color,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Icon icon;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 24, left: 48, right: 48),
      height: 80,
      width: size.width - 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white10,
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(children: [
          Container(
            margin: const EdgeInsets.only(left: 12),
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: color,
            ),
            child: Center(child: icon),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 16, top: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: "Inter"),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, fontFamily: "Inter"),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
