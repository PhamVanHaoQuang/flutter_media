import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_learn/presentation/download_screen.dart';
import 'package:flutter_learn/presentation/file_picker_screen.dart';
import 'package:flutter_learn/presentation/list_file_screen.dart';
import 'package:flutter_learn/presentation/better_player/video_better_player.dart';
import 'package:flutter_learn/presentation/better_player/video_youtube_screen.dart';

MethodChannel platFormChannel = const MethodChannel('save_file');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  Uri link = Uri(path: 'https://www.youtube.com/watch?v=ndVxD9u95Z0');

  String link1 =
      // 'https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8';
      //live stream test quanlity
      //  'https://cph-p2p-msl.akamaized.net/hls/live/2000341/test/master.m3u8';

      // bay tinh yeu
      'https://live.xemtv24h.com/vod/vod/smil:PHIMBO_PhuDe_BayTinhYeu_E01.smil/playlist.m3u8';

  // biet doi bat hao
  // 'https://live.xemtv24h.com/vod/vod/smil:PHUDE_.Biet.Doi.Bat.Hao.The.Bad.Guys.Reign.of.Chaos.2019.smil/playlist.m3u8';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        //  '/': (context) => const MyHomePage(title: 'Flutter Learn 1 week'),
        '/download': (context) => const DownloadScreen(),
        '/video-youtube': (context) => const VideoYoutubeScreen(
              videoLink: 'https://www.youtube.com/watch?v=ndVxD9u95Z0',
            ),
        '/video': (context) => VideoBetterPlayerScreen(
              linkUrl: link1,
            ),
        '/list_file': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          final listFiles = args['files'];
          final title = args['title'];
          final color = args['color'];
          final icon = args['icon'];

          return ListFileScreen(
            files: listFiles,
            color: color,
            title: title,
            icon: icon,
          );
        },
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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  bool _checkYoutubeVideoByURL(String url) {
    final regex = RegExp(r'.*\?v=(.+?)($|[\&])', caseSensitive: false);
    try {
      if (regex.hasMatch(url)) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  String link = 'https://www.youtube.com/watch?v=ndVxD9u95Z0';
  String link1 =
      //  'https://live.xemtv24h.com/vod/vod/smil:PHIMBO_PhuDe_BayTinhYeu_E01.smil/playlist.m3u8';
      'http://demo.unified-streaming.com/video/tears-of-steel/tears-of-steel.ism/.m3u8';

  //Uri link = Uri(path: 'https://www.youtube.com/watch?v=ndVxD9u95Z0');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          InkWell(
            onTap: () {
              _checkYoutubeVideoByURL(link1)
                  ? Navigator.pushNamed(context, '/video-youtube')
                  : Navigator.pushNamed(context, '/video');
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Icon(Icons.video_collection_rounded),
            ),
          ),
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
      body: SingleChildScrollView(
        child: Column(
          children: const [
            Center(
              child: FilePickerScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
