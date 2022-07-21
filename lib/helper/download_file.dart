import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class DownloadHelper {
  Future downloadFile(BuildContext context, Reference ref) async {
    /// User download to the phone
    /// Visible to User Inside Gallery
    final url = await ref.getDownloadURL();

    final temDir = await getTemporaryDirectory();
    final appDir = await getApplicationDocumentsDirectory();
    final path = '${temDir.path}/${ref.name}';
    File downloadToFile = File(appDir.path);

    // await Dio().download(url, path, onReceiveProgress: (received, total) {
    //   double? progress = received / total;
    //   setState(() {
    //     downloadProgress[index] = progress;
    //   });
    // }).whenComplete(() {
    //   downloadProgress[index] = null;
    //   setState(() {});
    // });

    if (url.contains('.mp4') || url.contains('.mp3')) {
      await GallerySaver.saveVideo(path, toDcim: true);
    } else if (url.contains('.jpg') || url.contains('.png')) {
      await GallerySaver.saveImage(path, toDcim: true);
      
    } else if (url.contains('.pdf') ||
        url.contains('.docx') ||
        url.contains('.txt')) {
      // await FilePicker.platform.saveFile(
      //     fileName: url,
      //     lockParentWindow: true,
      //     type: FileType.custom,
      //     allowedExtensions: ['pdf', 'docx']);

      var task = await FirebaseStorage.instance
          .refFromURL(url)
          .writeToFile(downloadToFile);
    }

    // Show to UI result
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Download ${ref.name}')),
    );
  }
}
