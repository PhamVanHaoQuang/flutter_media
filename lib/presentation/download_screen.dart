import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  late Future<ListResult> futureFiles;
  Map<int, double?> downloadProgress = {};

  bool checkAbleToDownload = true;

  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseStorage.instance.ref('/files').list();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Screen'),
        leading: InkWell(
          child: const SizedBox(
            height: 40,
            width: 40,
            child: Center(child: Icon(Icons.arrow_left_outlined)),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<ListResult>(
        future: futureFiles,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final files = snapshot.data!.items;
            return ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                double? progress = downloadProgress[index];
                return ListTile(
                  title: Text(
                    file.name,
                    maxLines: 2,
                  ),
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
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error occurred'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future downloadFile(int index, Reference ref) async {
    /// Download from the app
    // final dir = await getApplicationDocumentsDirectory();
    // final file = File('${dir.path}/${ref.name}');
    // await ref.writeToFile(file);

    /// User download from the phone
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

    //final result = await platFormChannel.invokeMethod('save',{'file' : path , 'name' : 'cho'});

   // print(result);

 

    if (url.contains('.mp4') || url.contains('.mp3')) {
      await GallerySaver.saveVideo(path, toDcim: true);
    } else if (url.contains('.jpg') || url.contains('.png')) {
      await GallerySaver.saveImage(path, toDcim: true);
    } else if (url.contains('.pdf') || url.contains('.docx')) {
      // await FilePicker.platform.saveFile(
      //     fileName: url,
      //     lockParentWindow: true,
      //     type: FileType.custom,
      //     allowedExtensions: ['pdf', 'docx']);

      await FirebaseStorage.instance
          .refFromURL(url)
          .writeToFile(downloadToFile);
    }

    /// Show to UI result
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Download ${ref.name}')),
    );
  }
}
