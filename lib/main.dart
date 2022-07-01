import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_learn/presentation/download_screen.dart';
import 'presentation/file_picker_screen.dart';

MethodChannel platFormChannel = const  MethodChannel('save_file');


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        //  '/': (context) => const MyHomePage(title: 'Flutter Learn 1 week'),
        '/download': (context) => const DownloadScreen()
      },
      home: const MyHomePage(title: 'Flutter Learn 1 week'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    //final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/download');
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Icon(Icons.download_for_offline_sharp),
            ),
          )
        ],
      ),
      body: const SingleChildScrollView(
        // physics: NeverScrollableScrollPhysics(),
        child: Center(
          child: FilePickerScreen(),
        ),
      ),
    );
  }
}
