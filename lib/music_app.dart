import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class MusicApp extends StatefulWidget {
  String song_name, artist_name, audio_url, image_url;

  MusicApp({this.song_name, this.artist_name, this.audio_url, this.image_url});

  @override
  _MusicAppState createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  bool playing = false;
  bool repeat = false;

  AudioPlayer audioPlayer;
  AudioCache audioCache;

  void getAudio() async {
    var url = widget.audio_url;
    if (playing) {
      var res = await audioPlayer.pause();
      if (res == 1) {
        setState(() {
          playing = false;
        });
      }
    } else {
      var res = await audioPlayer.play(url);
      if (res == 1) {
        setState(() {
          audioCache.play(url);
          playing = true;
        });
      }
    }
  }

  Duration position = new Duration();
  Duration musicLength = new Duration();

  Widget slider() {
    return Container(
      width: 300.0,
      child: Slider.adaptive(
        activeColor: Colors.deepPurple[900],
        inactiveColor: Colors.grey[600],
        value: position.inSeconds.toDouble(),
        max: musicLength.inSeconds.toDouble(),
        onChanged: (value) {
          seekToSec(value.toInt());
        },
      ),
    );
  }

  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    audioPlayer.seek(newPos);
  }

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);

    audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        musicLength = d;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((p) {
      setState(() {
        position = p;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        _moveBack(context);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(
            color: Colors.deepPurple,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.deepPurple,
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  if (repeat == true) {
                    repeat = false;
                  } else {
                    repeat = true;
                  }
                  print(repeat);
                });
              },
              icon: repeat == true ? Icon(Icons.repeat_on) : Icon(Icons.repeat),
            ),
            IconButton(
              onPressed: () {
                if (playing == true) {
                  playing = false;
                  audioPlayer.pause();
                }
                Navigator.pop(context);
              },
              icon: Icon(Icons.home),
            ),
          ],
          backgroundColor: Colors.white,
          toolbarHeight: 50.0,
        ),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.deepPurple[800],
                  Colors.deepPurple[200],
                ]),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: 5.0,
            ),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      "SpotiFera",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      "Escute as suas músicas favoritas",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100.0,
                  ),
                  Center(
                    child: Container(
                      width: 250.0,
                      height: 250.0,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Image.network(widget.image_url),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  Center(
                    child: Text(
                      widget.song_name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Center(
                    child: Text(
                      widget.artist_name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${position.inMinutes}:${position.inSeconds.remainder(60)}",
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                                slider(),
                                Text(
                                  "${musicLength.inMinutes}:${musicLength.inSeconds.remainder(60)}",
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 20.0),
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.skip_previous_sharp,
                                    ),
                                    iconSize: 40.0,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    getAudio();
                                  },
                                  child: Icon(
                                    playing == false
                                        ? Icons.play_circle_fill
                                        : Icons.pause_circle_filled,
                                    size: 60.0,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.skip_next_sharp,
                                    ),
                                    iconSize: 40.0,
                                    color: Colors.deepPurple,
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _moveBack(BuildContext context) {
    playing = false;
    audioPlayer.pause();
    Navigator.of(context).pop();
  }
}
