import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:player/providers/auth_check.dart';
import '../widgets/play_screen.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import './loginpage.dart';
import 'package:provider/provider.dart';

class SongsList extends StatefulWidget {
  @override
  _SongsListState createState() => _SongsListState();
}

class _SongsListState extends State<SongsList> {
  Duration _position = Duration();
  QuerySnapshot qS;
  Future getFuture() async {
    qS = await Firestore.instance.collection("songs").getDocuments();

    return qS.documents;
  }

  static bool _isPlaying = false;
  AssetsAudioPlayer assetsPlayer = AssetsAudioPlayer();

  playMusic(String url) {
    setState(() {
      _isPlaying = true;
    });
    assetsPlayer.open(Audio.network(url),
        playInBackground: PlayInBackground.enabled,
        /* loopMode: LoopMode.playlist, */
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
        showNotification: true,
        notificationSettings: NotificationSettings(
          seekBarEnabled: true,
          customStopIcon: AndroidResDrawable(name: "ic_stop_custom"),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: new Text("My Player"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_upload),
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('/upload'),
          ),
          IconButton(
            highlightColor: Colors.red[300],
            splashColor: Colors.red,
            tooltip: "Logout",
            icon: Icon(Icons.exit_to_app),
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => LoginPage(),
              ),
            ),
          ),
        ],
      ),
      /*  drawer: Drawer(
        child: new Column(
          children: [
            UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  child: new Text("T"),
                ),
                accountName: Text("Test"),
                accountEmail: Text("Text@text.com")),
            SizedBox(
              height: 20.0,
            ),
            new ListTile(
              title: new Text("LogOut"),
              trailing: new Icon(Icons.call_missed_outgoing),
              onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => LoginPage(),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            new Text(name),
          ],
        ),
      ), */
      body: Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(colors: [
          Colors.white,
          Colors.grey[700],
        ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
        child: FutureBuilder(
            future: getFuture(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: new CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                );
              } else {
                if (qS.documents.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (contxt, index) {
                      return InkWell(
                          onTap: () {
                            return {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => PlayScreen(
                                  snapshot.data[index].data["image_url"],
                                  snapshot.data[index].data["song_name"],
                                  snapshot.data[index].data["artist_name"],
                                  snapshot.data[index].data["song_url"],
                                  assetsPlayer,
                                  _isPlaying,
                                ),
                              )),
                              playMusic(
                                snapshot.data[index].data["song_url"],
                              ),
                            };
                          },
                          /*  child: Card(
                        margin: EdgeInsets.all(10.0),
                        elevation: 30.0, */
                          child: ListTile(
                            leading: Container(
                              decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                border: Border.all(
                                    color: Colors.red[400], width: 3.0),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                    snapshot.data[index].data["image_url"],
                                    width: 50.0,
                                    height: 50.0,
                                    fit: BoxFit.fill),
                              ),
                            ),
                            subtitle: new Text(
                              snapshot.data[index].data["artist_name"],
                              style: new TextStyle(color: Colors.grey[350]),
                            ),
                            title: new Text(
                              snapshot.data[index].data["song_name"],
                              style: new TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () {},
                              color: Colors.white,
                            ),
                          ) /* ), */
                          );
                    },
                  );
                } else
                  return new Center(
                    child: new Text(
                      "No Uploaded Songs Found",
                      style: new TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  );
              }
            }),
      ),
    );
  }
}
