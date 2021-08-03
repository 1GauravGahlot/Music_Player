import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:player/screens/songs_list.dart';
import './loginpage.dart';
import '../providers/error_handling.dart';
import 'package:provider/provider.dart';
import '../providers/auth_check.dart';

class SignupScreen extends StatefulWidget {
  bool _isLoading;

  SignupScreen(this._isLoading);
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _userpasswordVerify = TextEditingController();
  TextEditingController _userConfirmemailVerify = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();
  String _userEmail, _userPassword, _userPhoneNumber;

  Future<void> SignUp(BuildContext ctext) async {
    setState(() {
      FocusScope.of(ctext).unfocus();
    });
    try {
      final _val = _formKey.currentState.validate();
      if (_val) {
        _formKey.currentState.save();
        widget._isLoading = true;
        await Provider.of<AuthCheck>(context, listen: false)
            .Signup(_userEmail, _userPassword);
        setState(() {
          widget._isLoading = false;
          createData();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => SongsList()),
          );
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

  Future<void> createData() async {
    var userDetails = {
      "UserEmail": _userEmail,
      "UserPassword": _userPassword,
      "UserPhoneNumber": _userPhoneNumber,
    };
    await Firestore.instance
        .collection("UserDetails")
        .document()
        .setData(userDetails);
  }

  void handle(BuildContext cntext, String errorMessage) {
    setState(() {
      widget._isLoading = false;
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
        content: new Text(errorMessage),
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
              gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.grey[700],
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
          )),
          child: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: new Form(
                    key: _formKey,
                    child: new Column(
                      children: <Widget>[
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Image.asset(
                              "images/music.png",
                              width: 60.0,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            new Text(
                              "My Player",
                              style: new TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20.0),
                            ),
                          ],
                        ),
                        new SizedBox(
                          height: 20.0,
                        ),
                        new Text("Tell us about yourself!!",
                            style: new TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 25.0,
                                color: Colors.black54)),
                        new SizedBox(
                          height: 30.0,
                        ),
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            new Text(
                              "Enter Your Email?",
                              style: new TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 15.0),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            new Container(
                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(
                                        color: Colors.black, width: 2.0)),
                                child: new Padding(
                                  padding:
                                      EdgeInsets.only(left: 5.0, right: 5.0),
                                  child: new TextFormField(
                                    onSaved: (value) => _userEmail = value,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(color: Colors.white),
                                    cursorColor: Colors.white,
                                    validator: (values) {
                                      if (values.isEmpty) {
                                        return "Enter Email";
                                      }
                                      return null;
                                    },
                                    decoration: new InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        hintText: "Email",
                                        hintStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ))
                          ],
                        ),
                        new SizedBox(
                          height: 30.0,
                        ),
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            new Text(
                              "Enter Password?",
                              style: new TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 15.0),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            new Container(
                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(
                                        color: Colors.black, width: 2.0)),
                                child: new Padding(
                                  padding:
                                      EdgeInsets.only(left: 5.0, right: 5.0),
                                  child: new TextFormField(
                                    onSaved: (value) => _userPassword = value,
                                    controller: _userpasswordVerify,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(color: Colors.white),
                                    cursorColor: Colors.white,
                                    decoration: new InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        hintText: "Password",
                                        hintStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400)),
                                    validator: (value) {
                                      if (value.length < 6) {
                                        return "Password Must Be 6 in length";
                                      }
                                      return null;
                                    },
                                  ),
                                ))
                          ],
                        ),
                        new SizedBox(
                          height: 30.0,
                        ),
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            new Text(
                              "Confirm Password?",
                              style: new TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 15.0),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            new Container(
                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(
                                        color: Colors.black, width: 2.0)),
                                child: new Padding(
                                  padding:
                                      EdgeInsets.only(left: 5.0, right: 5.0),
                                  child: new TextFormField(
                                    controller: _userConfirmemailVerify,
                                    validator: (value) {
                                      if (_userpasswordVerify.text !=
                                          _userConfirmemailVerify.text) {
                                        return "Password does not match!";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) =>
                                        _userPhoneNumber = value,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(color: Colors.white),
                                    cursorColor: Colors.white,
                                    decoration: new InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        hintText: "Confirm Password",
                                        hintStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ))
                          ],
                        ),
                        new SizedBox(
                          height: 30.0,
                        ),
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            new Text(
                              "Enter Mobilenumber?",
                              style: new TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 15.0),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            new Container(
                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(
                                        color: Colors.black, width: 2.0)),
                                child: new Padding(
                                  padding:
                                      EdgeInsets.only(left: 5.0, right: 5.0),
                                  child: new TextFormField(
                                    onSaved: (value) =>
                                        _userPhoneNumber = value,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Enter Mobile Number";
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(color: Colors.white),
                                    cursorColor: Colors.white,
                                    decoration: new InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        hintText:
                                            "Phone Number(*also include your std code)",
                                        hintStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        new Container(
                          width: double.infinity,
                          decoration: new BoxDecoration(
                              border: Border.all(
                                  color: Colors.red[400], width: 5.0),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: new FlatButton(
                              onPressed: () => SignUp(context),
                              child: widget._isLoading
                                  ? Center(
                                      child: new CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                      ),
                                    )
                                  : new Text(
                                      "Signup",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 25.0,
                                          color: Colors.white),
                                    )),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              "Already have an account?",
                              style: new TextStyle(fontWeight: FontWeight.w900),
                            ),
                            new InkWell(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => LoginPage(),
                                ),
                              ),
                              child: new Text(
                                "Login",
                                style: new TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.wavy,
                                    decorationColor: Colors.red[300],
                                    color: Colors.red[700],
                                    fontWeight: FontWeight.w800),
                              ),
                            )
                          ],
                        )
                      ],
                    )),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
