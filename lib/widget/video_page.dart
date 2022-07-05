import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learn/video_items.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/download_file.dart';

class VideoPage extends StatefulWidget {
  final Reference file;
  const VideoPage({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  State<VideoPage> createState() => _ImagePageState();

  // Future.wait(refs.map((ref) => ref.getDownloadURL()));
}

class _ImagePageState extends State<VideoPage> {
  bool checkAbleToDownload = true;
  String videoURL = '';

  @override
  void initState() {
    super.initState();

    _getVideo();
  }

  _getVideo() async {
    videoURL = await getDownloadLink(widget.file);
    await getSavedData();
    setState(() {});
  }

  Future<String> getDownloadLink(Reference file) async {
    final downloadURL = await file.getDownloadURL();

    return downloadURL;
  }

  getSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    checkAbleToDownload = prefs.getBool(videoURL) ?? false;
    print(checkAbleToDownload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.file.name),
        centerTitle: true,
        actions: [
          !(checkAbleToDownload)
              ? IconButton(
                  onPressed: () async {
                    DownloadHelper().downloadFile(context, widget.file);
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool(videoURL, true);
                    setState(() {
                      checkAbleToDownload = true;
                    });
                  },
                  icon: const Icon(Icons.download))
              : Container()
        ],
      ),
      body: (videoURL != '')
          ? Center(
              child: VideoItem(
                link: videoURL,
                // file: File(pickerFile!.path!),
                autoplay: true,
                looping: false,
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
