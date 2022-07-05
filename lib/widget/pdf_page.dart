import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';

import '../helper/download_file.dart';

class PdfPage extends StatefulWidget {
  final Reference file;

  const PdfPage({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  PdfController? controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (controller == null) {
      initData();
    }
  }

  Future<void> initData() async {
    fileUrl = await getDownloadLink(widget.file);
    controller = PdfController(
        document: PdfDocument.openData(InternetFile.get(fileUrl)));
    setState(() {});
  }

  Future<String> getDownloadLink(Reference file) async {
    final downloadURL = await file.getDownloadURL();
    // final file = Firebase
    // print(downloadURL);
    return downloadURL;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  String fileUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.file.name),
           actions: [
          IconButton(
              onPressed: () {
                DownloadHelper().downloadFile(context,widget.file);
              },
              icon: const Icon(Icons.download))
        ],
        ),
        body: controller != null
            ? PdfView(
                controller: controller!,
                scrollDirection: Axis.horizontal,
                builders: PdfViewBuilders<DefaultBuilderOptions>(
                  options: const DefaultBuilderOptions(),
                  documentLoaderBuilder: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  pageLoaderBuilder: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()));
  }
}
