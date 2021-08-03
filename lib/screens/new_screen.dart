import 'package:flutter/material.dart';
import 'package:music_player/music_player.dart';

class NewScreen extends StatefulWidget {
  String imageUrl, songName, artistName, songUrl;
  NewScreen(this.imageUrl, this.songName, this.artistName, this.songUrl);
  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  MusicPlayer musicPlayer;
  bool _isPlaying = false;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Initializing the Music Player and adding a single [PlaylistItem]
  Future<void> initPlatformState() async {
    musicPlayer = MusicPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: new Column(
        children: <Widget>[
          SizedBox(
            height: 30.0,
          ),
          new Text(
            widget.songName,
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w900,
            ),
          ),
          new Text(widget.artistName),
          SizedBox(
            height: 30.0,
          ),
          Card(
            child: Image.network(
              widget.imageUrl,
              height: 250.0,
            ),
            elevation: 30.0,
          ),
          new SizedBox(
            height: 25.0,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 150.0,
              ),
              IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });
                    musicPlayer.play(MusicItem(
                      trackName: '',
                      albumName: '',
                      artistName: '',
                      url: widget.songUrl,
                      coverUrl: '',
                      duration: Duration(seconds: 255),
                    ));
                  }),
              IconButton(
                  icon: Icon(Icons.stop),
                  onPressed: () {
                    setState(() {
                      _isPlaying = false;
                    });
                    musicPlayer.stop();
                  })
            ],
          )
        ],
      ),
    ));
  }
}
