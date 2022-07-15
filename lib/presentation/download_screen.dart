import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'download_folder_screen.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  late Future<ListResult> futureFiles;
  List<Reference> videoFiles = <Reference>[];
  List<Reference> imageFiles = <Reference>[];
  List<Reference> musicFiles = <Reference>[];
  List<Reference> documentFiles = <Reference>[];
  Map<int, double?> downloadProgress = {};

  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseStorage.instance.ref('/files').list();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await splitList().whenComplete(() {
        setState(() {});
      });
    });
  }

  Future<void> splitList() async {
    ListResult listFiles = await futureFiles;
    for (final Reference element in listFiles.items) {
      String extension = element.name.split(RegExp(r"(\.+)")).last;

      switch (extension) {
        case 'mp4':
        case 'oob':
          videoFiles.add(element);
          break;

        case 'png':
        case 'jpg':
        case 'jpge':
          imageFiles.add(element);
          break;

        case 'mp3':
        case 'ogg':
          musicFiles.add(element);
          break;

        case 'pdf':
        case 'docx':
        case 'doc':
        case 'txt':
          documentFiles.add(element);
          break;

        default:
          documentFiles.add(element);
          break;
      }
    }
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
      body: Column(
        children: [
          DownloadFolderItemWidget(
            title: 'Document',
            subtitle: documentFiles.length.toString() + ' files',
            icon: const Icon(Icons.description_outlined),
            color: Colors.orange[400],
            onTap: () {
              Navigator.of(context).pushNamed('/list-file', arguments: {
                'title': 'Document',
                'files': documentFiles,
                'icon': const Icon(Icons.description_outlined),
                'color': Colors.orange[400],
              });
            },
          ),
          DownloadFolderItemWidget(
            title: 'Videos',
            subtitle: videoFiles.length.toString() + ' files',
            icon: const Icon(Icons.video_library_rounded),
            color: Colors.purple[400],
            onTap: () {
              Navigator.of(context).pushNamed('/list-file', arguments: {
                'title': 'Videos',
                'files': videoFiles,
                'icon': const Icon(Icons.video_library_rounded),
                'color': Colors.purple[400],
              });
            },
          ),
          DownloadFolderItemWidget(
            title: 'Images',
            subtitle: imageFiles.length.toString() + ' files',
            icon: const Icon(Icons.image),
            color: Colors.pink[400],
            onTap: () {
              Navigator.of(context).pushNamed('/list-file', arguments: {
                'title': 'Images',
                'files': imageFiles,
                'icon': const Icon(Icons.image),
                'color': Colors.pink[400],
              });
            },
          ),
          DownloadFolderItemWidget(
            title: 'Music',
            subtitle: musicFiles.length.toString() + ' files',
            icon: const Icon(Icons.music_note_rounded),
            color: Colors.lightBlue[200],
            onTap: () {
              Navigator.of(context).pushNamed('/list-file', arguments: {
                'title': 'Music',
                'files': musicFiles,
                'icon': const Icon(Icons.music_note_rounded),
                'color': Colors.lightBlue[200],
              });
            },
          ),
        ],
      ),
    );
  }
}
