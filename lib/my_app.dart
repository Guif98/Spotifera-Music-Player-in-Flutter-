import 'package:flutter/material.dart';
import 'package:muisc_player/music_app.dart';
import 'package:muisc_player/view/browser_page.dart';
import 'package:muisc_player/view/upload_music.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/browser',
      routes: {
        '/': (context) => MusicApp(),
        '/browser': (context) => BrowserPage(),
        '/upload': (context) => UploadMusic(),
      },
    );
  }
}
