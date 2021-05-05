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
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(
          color: Colors.deepPurple,
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => selectImage(),
                  child: Text("Selecione a capa"),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: ElevatedButton(
                    onPressed: () => selectSong(),
                    child: Text("Selecione a música"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Container(
                    width: 300,
                    child: TextField(
                      controller: songname,
                      decoration: InputDecoration(hintText: "Nome da música"),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Container(
                    width: 300,
                    child: TextField(
                      controller: artistname,
                      decoration: InputDecoration(hintText: "Nome do artista"),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: ElevatedButton(
                    onPressed: () => finalUpload(),
                    child: Text('Salvar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
