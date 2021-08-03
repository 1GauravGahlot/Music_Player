import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import './songs_list.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  GlobalKey<FormState> authFormKey = GlobalKey();
  TextEditingController songName = TextEditingController();
  TextEditingController artistName = TextEditingController();
  File image, song;
  String imagePath, songPath;
  StorageReference ref;
  var image_down_url, song_down_url;
  void selectImage() async {
    image = await FilePicker.getFile();
    setState(() {
      image = image;
      imagePath = basename(image.path);
    });
  }

  Stream<StorageTaskEvent> getStream;

  Future<String> uploadImage(List<int> image, String imagepath) async {
    ref = FirebaseStorage.instance.ref().child(imagepath);
    StorageUploadTask uploadTask = ref.putData(image);
    setState(() {
      getStream = uploadTask.events;
    });

    image_down_url = await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  void selectSong() async {
    song = await FilePicker.getFile();
    setState(() {
      song = song;
      songPath = basename(song.path);
    });
  }

  Future<String> uploadSong(List<int> song, String songPath) async {
    ref = FirebaseStorage.instance.ref().child(songPath);
    StorageUploadTask uploadsongTask = ref.putData(song);
    song_down_url =
        await (await uploadsongTask.onComplete).ref.getDownloadURL();
    setState(() {});
  }

  Future<String> uploading(ctxt) async {
    setState(() {
      isUploading = true;
    });
    FocusScope.of(ctxt).unfocus();
    await uploadImage(image.readAsBytesSync(), imagePath);
    await uploadSong(song.readAsBytesSync(), songPath);
    var data = {
      "song_name": songName.text,
      "artist_name": artistName.text,
      "song_url": song_down_url.toString(),
      "image_url": image_down_url.toString(),
    };
    await Firestore.instance.collection("songs").document().setData(data);
    setState(() {
      isUploading = false;
    });
  }

  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      extendBodyBehindAppBar: true,
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        title: new Text("Upload"),
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => SongsList())),
              child: new Text(
                "MySongs",
                style: new TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 60.0),
        decoration: new BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.grey[700],
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: new Column(
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/music.png',
                    width: 60.0,
                  ),
                  new SizedBox(
                    width: 10.0,
                  ),
                  new Text(
                    "My Player",
                    style: new TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0,
                        color: Colors.white),
                  )
                ],
              ),
              SizedBox(
                width: 30.0,
              ),
              Form(
                  key: authFormKey,
                  child: Column(
                    children: [
                      new Padding(
                        padding: EdgeInsets.all(20.0),
                        child: new TextFormField(
                          cursorColor: Colors.grey,
                          style: new TextStyle(color: Colors.white),
                          controller: songName,
                          decoration: new InputDecoration(
                            hintText: "Song Name",
                            hintStyle: TextStyle(color: Colors.white),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                          ),
                          validator: (value) {
                            if (value.length <= 0) {
                              return "Please Enter Song Name";
                            }
                            return null;
                          },
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.all(20.0),
                        child: new TextFormField(
                          validator: (value) {
                            if (value.length <= 0) {
                              return "Enter Artist name";
                            }
                            return null;
                          },
                          cursorColor: Colors.grey,
                          style: new TextStyle(color: Colors.white),
                          controller: artistName,
                          decoration: new InputDecoration(
                            hintText: "Write Artist Name",
                            hintStyle: TextStyle(color: Colors.white),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  )),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(50.0, 90.0),
                            bottomRight: Radius.elliptical(50.0, 90.0))),
                    onPressed: () => selectImage(),
                    child: new Text(
                      "Open Image",
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  new RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(50.0, 90.0),
                            bottomRight: Radius.elliptical(50.0, 90.0))),
                    onPressed: () => selectSong(),
                    child: new Text("Select Song"),
                  ),
                ],
              ),
              new SizedBox(
                height: 15.0,
              ),
              new RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                elevation: 50.0,
                onPressed: () => uploading(context),
                child: isUploading
                    ? SizedBox(
                        height: 10.0,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.grey,
                          strokeWidth: 5.0,
                        ),
                      )
                    : new Text(
                        "Upload",
                        style: new TextStyle(
                            color: Colors.red[700],
                            fontWeight: FontWeight.w900),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
