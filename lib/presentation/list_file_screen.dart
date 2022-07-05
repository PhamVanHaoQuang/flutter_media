import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learn/widget/pdf_page.dart';
import 'package:flutter_learn/widget/video_page.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import '../widget/image_page.dart';

class ListFileScreen extends StatefulWidget {
  ListFileScreen({
    required this.files,
    required this.color,
    required this.title,
    required this.icon,
    Key? key,
  }) : super(key: key);
  List<Reference> files;
  Color color;
  String title;
  Icon icon;

  @override
  State<ListFileScreen> createState() => _ListFileScreenState();
}

class _ListFileScreenState extends State<ListFileScreen> {
  bool checkAbleToDownload = true;
  Map<int, double?> downloadProgress = {};
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        leading: InkWell(
          child: const SizedBox(
            height: 40,
            width: 40,
            child: Center(
                child: Icon(
              Icons.arrow_left_outlined,
              size: 40,
            )),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView.builder(
        itemCount: widget.files.length,
        itemBuilder: (context, index) {
          final Reference file = widget.files[index];
          double? progress = downloadProgress[index];
          return ListTile(
            onTap: () {
              print('sdfsdfsd');

              openFile(file);
            },
            tileColor: (index % 2 == 0) ? Colors.white10 : Colors.black12,
            title: Text(
              file.name,
              maxLines: 2,
            ),
            leading: widget.icon,
            subtitle: progress != null
                ? LinearProgressIndicator(
                    value: progress,
                    color: Colors.white,
                  )
                : null,
            trailing: IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                if (checkAbleToDownload) {
                  setState((() => checkAbleToDownload = false));
                  downloadFile(index, file).whenComplete(() => setState(
                        () => checkAbleToDownload = true,
                      ));
                }
              },
            ),
          );
        },
      ),
    );
  }

  Future downloadFile(int index, Reference ref) async {
    /// User download to the phone
    /// Visible to User Inside Gallery

    final url = await ref.getDownloadURL();

    final temDir = await getTemporaryDirectory();
    final appDir = await getApplicationDocumentsDirectory();
    final path = '${temDir.path}/${ref.name}';
    File downloadToFile = File(appDir.path);

    await Dio().download(url, path, onReceiveProgress: (received, total) {
      double? progress = received / total;
      setState(() {
        downloadProgress[index] = progress;
      });
    }).whenComplete(() {
      downloadProgress[index] = null;
      setState(() {});
    });

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

    /// Show to UI result
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Download ${ref.name}')),
    );
  }

  void openFile(Reference file) {
    String extension = file.name.split(RegExp(r"(\.+)")).last;
    switch (extension) {
      case 'mp4':
      case 'oob':
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VideoPage(
                  file: file,
                )));
        break;

      case 'png':
      case 'jpg':
      case 'jpge':
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ImagePage(
                  file: file,
                )));
        break;

      case 'mp3':
      case 'ogg':
        break;

      case 'pdf':
      case 'docx':
      case 'doc':
      case 'txt':
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PdfPage(
                  file: file,
                )));
        break;

      default:
        //documentFiles.add(element);
        break;
    }
  }
}
