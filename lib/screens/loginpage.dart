import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:player/screens/songs_list.dart';
import '../widgets/auth_form.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  GoogleSignIn _login = GoogleSignIn(scopes: ['email']);
  googleIn(BuildContext context) async {
    try {
      await _login.signIn();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (ctx) => SongsList()));
      print("Logged in");
    } catch (err) {
      print(err);
    }
  }

  _screenLook(
    String title,
    Color colours,
    IconData icons,
    BuildContext context,
  ) {
    return new Container(
      padding: EdgeInsets.all(5),
      alignment: Alignment.center,
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: colours,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: FittedBox(
        fit: BoxFit.cover,
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icons,
              color: Colors.white,
            ),
            new FlatButton(
              onPressed: () => googleIn(context),
              child: new Text(
                title,
                style: new TextStyle(
                  fontFamily: 'IBM',
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [
                  Colors.white,
                  Colors.grey[700],
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(top: 60.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          decoration: new BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: Image.asset(
                            'images/new_logo.png',
                            width: 90.0,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        new Text(
                          "My Player",
                          style: new TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20.0),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    _screenLook(
                      "CONTINUE WITH GMAIL",
                      Colors.red,
                      MaterialCommunityIcons.gmail,
                      context,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(children: <Widget>[
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 15.0),
                            child: Divider(
                              color: Colors.white,
                              height: 50,
                            )),
                      ),
                      Text(
                        "OR",
                        style: new TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87),
                      ),
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 15.0, right: 10.0),
                            child: Divider(
                              color: Colors.white,
                              height: 50,
                            )),
                      ),
                    ]),
                    AuthForm(),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
