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

  late final TextEditingController myController;

  late Future<ListResult> futureFile;
  @override
  void initState() {
    super.initState();
    myController = TextEditingController();
    futureFile = FirebaseStorage.instance.ref('/files').list();
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickerFile = result.files.first;
      if (pickerFile?.name != null) {
        myController.text =
            pickerFile!.name.substring(0, pickerFile!.name.indexOf('.'));
      }
    });
  }

  Future uploadFile() async {
    final file = File(pickerFile!.path!);
    String name = pickerFile!.name;
    String newName =
        myController.text + '.' + pickerFile!.name.split(RegExp(r"(\.+)")).last;
    final firestoragePath = 'files/$newName';

    //File newFile = await file.rename(file.path.replaceAll(name, newName));

    try {
      // File newFile =
      //     await file.rename(pickerFile!.path!.replaceAll(name, newName));
      File newFile = await file.rename(file.path.replaceAll(name, newName));

      var ref = FirebaseApi.uploadFile(firestoragePath, newFile);
      setState(() {
        uploadTask = ref;
      });

      final snapshot = await uploadTask!;
      setState(() {
        isUploadDone = true;
      });

      final urlDownload = await snapshot.ref.getDownloadURL();

      setState(() {
        uploadTask = null;
      });
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Future deleteFile() async {
    setState(() {
      pickerFile = null;
      isUploadDone = false;
    });
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

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
                          ),
                  ),
                ),
              )
            : const SizedBox(
                height: 400,
              ),
        const SizedBox(
          height: 16,
        ),
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
                  const SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    flex: 24,
                    child: TextField(
                      controller: myController,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white70,
                                  style: BorderStyle.solid))),
                      onTap: () => myController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: myController.value.text.length),
                    ),
                  ),
                  Text(
                    '.' + pickerFile!.name.split(RegExp(r"(\.+)")).last,
                    style: const TextStyle(fontSize: 16),
                  ),
                  // Text(extension),
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
          height: 16,
        ),
        (pickerFile != null)
            ? InkWell(
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
                        color: (pickerFile != null)
                            ? Colors.white
                            : Colors.white54,
                      ),
                    ),
                  ),
                ))
            : const SizedBox(height: 40),
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
      },
    );
  }
}
