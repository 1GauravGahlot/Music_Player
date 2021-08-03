import 'package:flutter/material.dart';
import '../widgets/play_screen.dart';

class PlayerScreen extends StatefulWidget {
  String uri;
  PlayerScreen(this.uri);
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.file_upload),
              onPressed: () => Navigator.of(context).pushNamed('/upload'),
            ),
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () => Navigator.of(context).pushNamed('/songs-List'),
            )
          ],
          backgroundColor: Colors.transparent,
          title: new Text(
            "My Player",
            textAlign: TextAlign.center,
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.red[300], Colors.grey],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft),
              ),
            ),
            SizedBox(
              height: 110,
            ),
            // PlayScreen(widget.uri),
          ],
        ));
  }
}
