import 'package:flutter/material.dart';
import 'package:muisc_player/music_app.dart';
import 'package:muisc_player/view/browser_page.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MusicApp(),
        '/browser': (context) => BrowserPage(),
      },
    );
  }
}
