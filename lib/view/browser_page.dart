import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:muisc_player/music_app.dart';

class BrowserPage extends StatefulWidget {
  @override
  _BrowserPageState createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  Future getData() async {
    QuerySnapshot query =
        await Firestore.instance.collection('audios').getDocuments();
    return query.documents;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Playlist',
                style: TextStyle(
                  color: Colors.deepPurple,
                ),
              ),
              automaticallyImplyLeading: false,
              iconTheme: IconThemeData(
                color: Colors.deepPurple,
              ),
              actionsIconTheme: IconThemeData(
                color: Colors.deepPurple,
              ),
              toolbarHeight: 50.0,
              backgroundColor: Colors.white,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/upload');
                  },
                  icon: Icon(Icons.add_to_photos_rounded),
                  color: Colors.deepPurple,
                ),
              ],
            ),
            body: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple[800],
                    Colors.deepPurple[200],
                  ],
                ),
              ),
              child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MusicApp(
                                song_name:
                                    snapshot.data[index].data["song_name"],
                                artist_name:
                                    snapshot.data[index].data["artist_name"],
                                audio_url:
                                    snapshot.data[index].data["audio_url"],
                                image_url:
                                    snapshot.data[index].data["image_url"],
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 150,
                                  height: 150,
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Image.network(
                                      snapshot.data[index].data["image_url"],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Column(
                                children: [
                                  Text(
                                    snapshot.data[index].data["song_name"],
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    snapshot.data[index].data["artist_name"],
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          );
        }
      },
    );
  }
}
