import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/download_file.dart';

class ImagePage extends StatefulWidget {
  final Reference file;
  const ImagePage({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  bool checkAbleToDownload = true;
  @override
  void initState() {
    super.initState();

    _getImage();
  }

  _getImage() async {
    imageURL = await getDownloadLink(widget.file);
    await getSavedData();
    setState(() {});
  }

  Future<String> getDownloadLink(Reference file) async {
    final downloadURL = await file.getDownloadURL();

    return downloadURL;
  }

  getSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    checkAbleToDownload = prefs.getBool(imageURL) ?? false;
    print(checkAbleToDownload);
  }

  String imageURL = '';

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
                    prefs.setBool(imageURL, true);
                    setState(() {
                      checkAbleToDownload = true;
                    });
                  },
                  icon: const Icon(Icons.download))
              : Container()
        ],
      ),
      body: (imageURL != '')
          ? Image.network(
              imageURL,
              height: double.infinity,
              width: double.infinity,
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
