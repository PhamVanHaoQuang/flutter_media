import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learn/api/firebase_api.dart';
import 'package:flutter_learn/video_items.dart';

class FilePickerScreen extends StatefulWidget {
  const FilePickerScreen({Key? key}) : super(key: key);

  @override
  State<FilePickerScreen> createState() => _FilePickerScreenState();
}

class _FilePickerScreenState extends State<FilePickerScreen> {
  PlatformFile? pickerFile;
  UploadTask? uploadTask;
  bool isUploadDone = false;

  late Future<ListResult> futureFile;
  @override
  void initState() {
    super.initState();
    futureFile = FirebaseStorage.instance.ref('/files').list();
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickerFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final destination = 'files/${pickerFile!.name}';
    final file = File(pickerFile!.path!);
    //final ref = FirebaseStorage.instance.ref().child(destination);

    var ref = FirebaseApi.uploadFile(destination, file);
    setState(() {
      uploadTask = ref;
    });

    final snapshot = await uploadTask!;

    setState(() {
      isUploadDone = true;
    });

    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Quang File: $urlDownload');

    setState(() {
      uploadTask = null;
    });
  }

  Future deleteFile() async {
    setState(() {
      pickerFile = null;
      isUploadDone = false;
    });
  }

  // Future downloadFile(Reference ref) async {
  //   final urlDownload = await ref.getDownloadURL();

  //   ///Visible User Gallery
  //   final dir = await getApplicationDocumentsDirectory();
  //   final file = File('${dir.path}/${ref.name}');
  //   await ref.writeToFile(file);
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        (pickerFile != null)
            ? SizedBox(
                width: size.width,
                height: 400,
                child: Container(
                  color: Colors.white10,
                  child: Center(
                      child: (pickerFile!.name.contains('.jpg') ||
                              pickerFile!.name.contains('.png'))
                          ? Image.file(
                              File(pickerFile!.path!),
                              width: double.infinity,
                            )
                          : VideoItem(
                              file: File(pickerFile!.path!),
                              autoplay: true,
                              looping: false,
                            )),
                ))
            : const SizedBox(
                height: 400,
              ),

        // const SizedBox(
        //   height: 32,
        // ),
        InkWell(
          onTap: () => selectFile(),
          child: Container(
            height: 40,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(18)),
            child: const Center(
              child: Text(
                'Choose file',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        (pickerFile != null)
            ? (Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    pickerFile!.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  IconButton(
                    onPressed: () {
                      deleteFile();
                    },
                    icon: const Icon(
                      Icons.cancel_outlined,
                    ),
                  )
                ],
              ))
            : const SizedBox(
                height: 48,
              ),
        const SizedBox(
          height: 8,
        ),
        InkWell(
            onTap: () {
              (pickerFile != null) ? uploadFile() : null;
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
              ),
              height: 40,
              width: 100,
              child: Center(
                child: Text(
                  (isUploadDone == false)
                      ? ((uploadTask == null) ? 'Upload ' : 'Uploading')
                      : 'Uploaded',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color:
                          (pickerFile != null) ? Colors.white : Colors.white54),
                ),
              ),
            )),
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: buildProgress(),
        ),
      ],
    );
  }

  Widget buildProgress() {
    return StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          // if (snapshot.hasData) {
          if (uploadTask != null && snapshot.hasData) {
            final data = snapshot.data!;

            //   uploadTask.whenComplete(() => null);
            double progress = data.bytesTransferred / data.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);
            return Center(
              child: Text(
                '$percentage %',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return const SizedBox(
              height: 8,
            );
          }
        });
  }
}
