import 'package:flutter/material.dart';
import 'package:flutter_learn/video_items.dart';

class VideoScreen extends StatefulWidget {
  final String linkUrl;
  const VideoScreen({
    Key? key,
    required this.linkUrl,
  }) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  @override
  void initState() {
    super.initState();

    //  _getVideo();
  }

  // _getVideo() async {
  //   // videoURL = await getDownloadLink(widget.file);
  //   await getSavedData();
  //   setState(() {});
  // }

  // Future<String> getDownloadLink(Reference file) async {
  //   final downloadURL = await file.getDownloadURL();

  //   return downloadURL;
  // }

  // getSavedData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   checkAbleToDownload = prefs.getBool(videoURL) ?? false;
  //   print(checkAbleToDownload);
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: (widget.linkUrl != '')
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * 253 / 896,
                      width: size.width,
                      child: VideoItem(
                        link: widget.linkUrl,
                        // file: File(pickerFile!.path!),
                        autoplay: true,
                        looping: false,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16),
                      child: Text(
                        'Bẫy tình yêu',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
