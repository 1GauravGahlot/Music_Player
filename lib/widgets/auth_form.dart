import 'dart:async';
import 'package:flutter/material.dart';
import '../providers/auth_check.dart';
import '../screens/songs_list.dart';
import 'package:provider/provider.dart';
import '../providers/error_handling.dart';
import '../screens/signup_screen.dart';
import 'package:get_ip/get_ip.dart';
import 'package:geolocator/geolocator.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  GlobalKey<FormState> _formKey = GlobalKey();
  String _userEmail;
  String _userPassword;
  bool _isLoading = false;
  bool _isloginLoading = false;
  FocusNode myFocusNode = new FocusNode();

  void userDialogue(BuildContext contxt) {
    FocusScopeNode _currentFocus = FocusScope.of(context);
    _currentFocus.unfocus();
    showDialog(
      context: contxt,
      builder: (ctx) => AlertDialog(
        actions: <Widget>[
          new FlatButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: new Text("Okay"))
        ],
        title: Text("ErrorOccured"),
        content: new Text("Email/Password does not match. Try Again!"),
      ),
    );
  }

  void handle(BuildContext cntext, String errormessage) {
    FocusScopeNode _currentFocus = FocusScope.of(context);
    _currentFocus.unfocus();
    setState(() {
      _isLoading = false;
    });

    showDialog(
      context: cntext,
      builder: (ctx) => AlertDialog(
        actions: <Widget>[
          new FlatButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: new Text("Okay"))
        ],
        title: Text("ErrorOccured"),
        content: new Text(errormessage),
      ),
    );
  }

  Future<void> SignUp(BuildContext ctext) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final _val = _formKey.currentState.validate();
      if (_val) {
        _formKey.currentState.save();
        await Provider.of<AuthCheck>(context, listen: false)
            .Signup(_userEmail, _userPassword);
        setState(() {
          _isLoading = false;
        });
      }
    } on ErrorHandling catch (error) {
      var errorMessage = 'Authentication Failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = "Email Already Registered.";
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'Email is wrong.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'Password too short.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Email does not exists.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Entered password is incorrect.';
      }

      handle(ctext, errorMessage);
    }
  }

  StreamSubscription<Position> positionStream;
  List<Placemark> placemark;
  var locationOption = LocationOptions(
      accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 100);
  Geolocator geo = Geolocator();

  Future<void> LogIn(BuildContext cntx) async {
    String ip = await GetIp.ipAddress;
    print(ip);
    positionStream =
        geo.getPositionStream(locationOption).listen((Position position) async {
      print(position == null
          ? "Unknown Location"
          : position.latitude.toString() +
              ', ' +
              position.longitude.toString());

      placemark = await geo.placemarkFromCoordinates(
          position.latitude.toDouble(), position.longitude.toDouble());
      print("${placemark[0].administrativeArea}" ":" "${placemark[0].country}");
    });
    setState(() {
      FocusScope.of(cntx).unfocus();
      _isloginLoading = true;
    });
    final _val = _formKey.currentState.validate();
    if (_val) {
      _formKey.currentState.save();
      await Provider.of<AuthCheck>(context, listen: false)
          .LogIn(_userEmail, _userPassword);
      final auth = await Provider.of<AuthCheck>(context, listen: false).isAuth;

      if (!auth) {
        userDialogue(cntx);
      } else {
        //Navigator.of(context).pushReplacementNamed('/playerScreen');
        Navigator.of(context).pushReplacement(
            (MaterialPageRoute(builder: (ctx) => SongsList())));
      }
    }
    setState(() {
      _isloginLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                decoration: new BoxDecoration(
                    border: Border.all(color: Colors.white38, width: 5),
                    borderRadius: BorderRadius.circular(20.0)),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      cursorColor: Colors.white,
                      focusNode: myFocusNode,
                      style: TextStyle(color: Colors.white),
                      decoration: new InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelText: "Enter Email",
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please Enter a valid mail.';
                        }
                        return null;
                      },
                      onSaved: (value) => _userEmail = value,
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                      decoration: new InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelText: "Enter Password",
                          labelStyle: TextStyle(color: Colors.black)),
                      validator: (value) {
                        if (value.length < 6) {
                          return 'Password minimum length should be 6.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _userPassword = value,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 260.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  onPressed: () => LogIn(context),
                  child: _isloginLoading
                      ? SizedBox(
                          height: 15.0,
                          width: 15.0,
                          child: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              strokeWidth: 2.0,
                            ),
                          ),
                        )
                      : new Text(
                          "LogIn",
                          style: new TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                  color: Colors.red[400],
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 230.0),
                child: GestureDetector(
                  child: new Text(
                    "Forgot Password?",
                    style: new TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.0,
                        color: Colors.red[700]),
                  ),
                ),
              ),
              SizedBox(
                height: 35.0,
              ),
              Divider(
                color: Colors.white,
                thickness: 1.0,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      "Don't have an account?",
                      style: new TextStyle(fontWeight: FontWeight.w900),
                    ),
                    new SizedBox(
                      width: 3.0,
                    ),
                    new InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => SignupScreen(_isLoading),
                        ),
                      ),
                      child: new Text(
                        "SignUp",
                        style: new TextStyle(
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.wavy,
                            decorationColor: Colors.red[300],
                            color: Colors.red[700],
                            fontWeight: FontWeight.w800),
                      ),
                    )
                  ],
                ),
              )

              /* new Text(
                "Don't have an account?",
                style: new TextStyle(fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: 20.0,
              ),
              new Container(
                padding: EdgeInsets.all(10.0),
                width: double.infinity,
                decoration: new BoxDecoration(
                  border: Border.all(color: Colors.red[600], width: 3.0),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : new FlatButton(
                        onPressed: () => SignUp(context),
                        child: new Text(
                          "SignUp",
                          style: new TextStyle(
                              fontSize: 30.0, color: Colors.white),
                        )),
              ) */
            ],
          )),
    );
  }
}
