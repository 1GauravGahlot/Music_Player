import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/rendering.dart';

class PlayScreen extends StatefulWidget {
  String imageUrl, songName, artistName, songUrl;
  AssetsAudioPlayer assetsPlayer;
  bool _isplaying;

  PlayScreen(
    this.imageUrl,
    this.songName,
    this.artistName,
    this.songUrl,
    this.assetsPlayer,
    this._isplaying,
  );

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  Duration _duration = new Duration();

  Duration sliderDuration = new Duration();

  Duration to = Duration(seconds: 10);
  Duration by = Duration(seconds: -10);
  // AssetsAudioPlayer assetsPlayer = AssetsAudioPlayer();
  bool _isPlaying;
  double totalTime = 0.0;
  int timeMinutes = 0;
  int timeSeconds = 0;
  Future TotalTime() async {
    if (_isPlaying) {
      totalTime = await widget
          .assetsPlayer.current.value.audio.duration.inSeconds
          .toDouble();
    }

    timeMinutes = await widget
        .assetsPlayer.current.value.audio.duration.inMinutes
        .toInt();
    timeSeconds = await widget
        .assetsPlayer.current.value.audio.duration.inSeconds
        .remainder(60)
        .toInt();
  }

  slider() {
    return StreamBuilder(
        stream: widget.assetsPlayer.currentPosition,
        builder: (ctx, snapshot) {
          sliderDuration = snapshot.data;
          TotalTime();
          return Slider(
              activeColor: Colors.red[100],
              inactiveColor: Colors.white60,
              min: 0.0,
              max: totalTime > 0 ? totalTime : 0.0,
              value: sliderDuration.inSeconds.toDouble(),
              onChanged: (double value) {
                setState(() {
                  seekToSeconds(value.toInt());
                });
              });
        });
  }

  seekToSeconds(int second) {
    Duration newDuration = Duration(seconds: second);
    widget.assetsPlayer.seek(newDuration);
  }

  @override
  void initState() {
    super.initState();

    if (widget._isplaying) {
      _isPlaying = widget._isplaying;
      /* _playing = widget._isplaying; */
    } else {
      _isPlaying = false;
      /* _playing = false; */
    }
    /* checkisPlaying(); */
    TotalTime();
  }

  /* void playMusic() {
    if (!_isPlaying) {
      setState(() {
        _isPlaying = !_isPlaying;
        if (_isPlaying) {
          _playing = _isPlaying;
        } else {
          _playing = _isPlaying;
        }
        time = widget.assetsPlayer.current.value.audio.duration.toString();
      });
    }

    widget.assetsPlayer.open(Audio.network(widget.songUrl),
        playInBackground: PlayInBackground.enabled,
        loopMode: LoopMode.playlist,
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
        showNotification: true,
        notificationSettings: NotificationSettings(
          customStopIcon: AndroidResDrawable(name: "ic_stop_custom"),
        ));
  } */

  void seek() {
    widget.assetsPlayer.seekBy(to);
  }

  /* void setTotalTime() {
    widget.assetsPlayer.current.listen((playing) {
      _position = playing.audio.duration;
    });

    print(_position);
  } */

  setSeconds() {
    return StreamBuilder(
        stream: widget.assetsPlayer.currentPosition,
        builder: (cntxt, asyncSnapshot) {
          Future ch() async {
            _isPlaying = await widget.assetsPlayer.isPlaying.value;
            if (!_isPlaying) {
              setState(() {
                _isPlaying = false;
              });
            } else {
              setState(() {
                _isPlaying = true;
              });
            }
            print(_isPlaying);
          }

          _duration = asyncSnapshot.data;

          ch();
          return new Text(
            "${_duration.inSeconds.remainder(60)}",
            style:
                new TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
          );
        });
  }

  setMinutes() {
    return StreamBuilder(
        stream: widget.assetsPlayer.currentPosition,
        builder: (cntxt, asyncSnapshot) {
          _duration = asyncSnapshot.data;
          return new Text(
            _duration.inMinutes.toString(),
            style:
                new TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
          );
        });
  }

  void seekPrev() {
    widget.assetsPlayer.seekBy(by);
  }

  void pauseMusic() {
    widget.assetsPlayer.playOrPause();
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  /* onFinished() {
    widget.assetsPlayer.playlistAudioFinished;
  } */

  void nextMusic() {
    widget.assetsPlayer.playlistAudioFinished.listen((event) {
      print(" The Number ${event}");
    });
    widget.assetsPlayer.next();
    setState(() {
      _isPlaying = true;
    });
  }

  void prevMusic() {
    widget.assetsPlayer.previous();
    setState(() {
      _isPlaying = true;
    });
  }

  void stopMusic() {
    widget.assetsPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  String time;
  /* 
  totalTiming() {
    //return new Text(assetsPlayer.current.value.audio.duration.toString());
    setState(() {
      time = widget.assetsPlayer.current.value.audio.duration.toString();
    });
  } */

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.grey, Colors.red],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        padding: EdgeInsets.only(top: 30.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15.0,
            ),
            new Text(
              widget.songName,
              style: new TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            new Text(
              widget.artistName,
              style: new TextStyle(
                fontSize: 17.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                elevation: 35.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    height: 350.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            slider(),
            /* checkisPlaying(), */
            new Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Row(
                        children: [
                          setMinutes(),
                          /* checkisPlaying(), */
                          new Text(
                            ":",
                            style: new TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          setSeconds(),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 80.0, right: 10.0)),
                      new Row(
                        children: <Widget>[
                          new Text(
                            "$timeMinutes",
                            style: new TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          new Text(
                            ":",
                            style: new TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          new Text(
                            "$timeSeconds",
                            style: new TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 35.0,
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                /* FloatingActionButton(
                  heroTag: "btn1",
                  elevation: 35.0,
                  backgroundColor: Colors.red[300],
                  onPressed: prevMusic,
                  child: Icon(
                    Icons.skip_previous,
                  ),
                ), */
                FloatingActionButton(
                  heroTag: "btn2",
                  elevation: 35.0,
                  backgroundColor: Colors.red[400],
                  onPressed: seekPrev,
                  child: Icon(
                    Icons.replay_10,
                  ),
                ),
                FloatingActionButton(
                  heroTag: "btn3",
                  elevation: 35.0,
                  backgroundColor: Colors.red,
                  onPressed: pauseMusic /* _playing ? pauseMusic : null */,
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                ),
                FloatingActionButton(
                  heroTag: "btn4",
                  elevation: 35.0,
                  backgroundColor: Colors.red[900],
                  onPressed: stopMusic,
                  child: Icon(
                    Icons.stop,
                  ),
                ),
                FloatingActionButton(
                  heroTag: "btn5",
                  elevation: 35.0,
                  backgroundColor: Colors.red[400],
                  onPressed: seek,
                  child: Icon(
                    Icons.forward_10,
                  ),
                ),
                /* FloatingActionButton(
                  heroTag: "btn6",
                  elevation: 35.0,
                  backgroundColor: Colors.red[300],
                  onPressed: nextMusic,
                  child: Icon(
                    Icons.skip_next,
                  ),
                ) */
              ],
            ),
          ],
        ),
      ),
    );
  }
}
