import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class UploadMusic extends StatefulWidget {
  @override
  _UploadMusicState createState() => _UploadMusicState();
}

class _UploadMusicState extends State<UploadMusic> {
  TextEditingController songname = TextEditingController();
  TextEditingController artistname = TextEditingController();

  File image, audio;
  String imagepath, audiopath;
  StorageReference ref;

  var image_down_url, audio_down_url;

  final firestoreInstance = Firestore.instance;

  void selectImage() async {
    image = await FilePicker.getFile();

    setState(() {
      image = image;
      imagepath = basename(image.path);
      uploadImageFile(image.readAsBytesSync(), imagepath);
    });
  }

  Future<String> uploadImageFile(List<int> image, String imagepath) async {
    ref = FirebaseStorage.instance.ref().child(imagepath);
    StorageUploadTask uploadTask = ref.putData(image);

    image_down_url = await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  void selectSong() async {
    audio = await FilePicker.getFile();

    setState(() {
      audio = audio;
      audiopath = basename(audio.path);
      uploadAudioFile(audio.readAsBytesSync(), audiopath);
    });
  }

  Future<String> uploadAudioFile(List<int> audio, String audiopath) async {
    ref = FirebaseStorage.instance.ref().child(audiopath);
    StorageUploadTask uploadTask = ref.putData(audio);

    audio_down_url = await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  finalUpload() {
    var data = {
      "song_name": songname.text,
      "artist_name": artistname.text,
      "audio_url": audio_down_url.toString(),
      "image_url": image_down_url.toString(),
    };

    firestoreInstance.collection("audios").document().setData(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.deepPurple,
        ),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(
          color: Colors.deepPurple,
        ),
        toolbarHeight: 40,
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
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 40),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 300.0,
                    height: 80.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                      ),
                      onPressed: () => selectImage(),
                      child: Text(
                        "Selecione a capa",
                        style: TextStyle(
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: SizedBox(
                      width: 300.0,
                      height: 80.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.white),
                        onPressed: () => selectSong(),
                        child: Text(
                          "Selecione a música",
                          style: TextStyle(
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: Container(
                      width: 300,
                      child: TextField(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        controller: songname,
                        decoration: InputDecoration(
                          labelText: 'Nome da música:',
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: Container(
                      width: 300,
                      child: TextField(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        controller: artistname,
                        decoration: InputDecoration(
                          labelText: 'Nome do artista',
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: SizedBox(
                      width: 300.0,
                      height: 80.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        ),
                        onPressed: () => finalUpload(),
                        child: Text(
                          'Salvar',
                          style: TextStyle(
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
