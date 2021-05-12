import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muisc_player/view/alert.dart';
import 'package:path/path.dart';

class UploadMusic extends StatefulWidget {
  @override
  _UploadMusicState createState() => _UploadMusicState();
}

class _UploadMusicState extends State<UploadMusic> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    if (audio_down_url != null || image_down_url != null) {
      var data = {
        "song_name": songname.text,
        "artist_name": artistname.text,
        "audio_url": audio_down_url.toString(),
        "image_url": image_down_url.toString(),
      };
      firestoreInstance.collection("audios").document().setData(data);
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioFileName =
        audio_down_url != null ? basename(audiopath) : 'No file selected!';

    final imageFileName =
        image_down_url != null ? basename(imagepath) : 'No file Selected!';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Adicionar Música',
          style: TextStyle(
            color: Colors.deepPurple,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.deepPurple,
        ),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(
          color: Colors.deepPurple,
        ),
        toolbarHeight: 50,
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: 300.0,
                          height: 80.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurple,
                            ),
                            onPressed: () => selectImage(),
                            child: Text(
                              "Selecione a capa",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          imageFileName,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: SizedBox(
                            width: 300.0,
                            height: 80.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple,
                              ),
                              onPressed: () => selectSong(),
                              child: Text(
                                "Selecione a música",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          audioFileName,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30.0),
                          child: Container(
                            width: 300,
                            child: TextFormField(
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.deepPurple,
                              ),
                              textAlign: TextAlign.center,
                              controller: songname,
                              decoration: InputDecoration(
                                labelText: 'Nome da música:',
                                labelStyle: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'A música deve ter um nome!';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30.0),
                          child: Container(
                            width: 300,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.deepPurple,
                              ),
                              controller: artistname,
                              decoration: InputDecoration(
                                labelText: 'Nome do artista',
                                labelStyle: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              validator: (String value) {
                                if (value == null || value.isEmpty) {
                                  return 'O nome do artista é necessário!';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(30.0),
                          child: SizedBox(
                            width: 300.0,
                            height: 80.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple,
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  if (finalUpload()) {
                                    Navigator.of(context).pop();
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text('Alerta'),
                                        content: Text(
                                            'Você deve adicionar uma imagem de capa e uma música!'),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("OK"),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                'Salvar',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
