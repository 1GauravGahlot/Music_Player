import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './error_handling.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthCheck with ChangeNotifier {
  String _userId;
  /* DateTime _expiryDate; */
  String _email;
  String _useremail;
  String _userToken;
  String _refreshToken;
  bool get isAuth {
    return Token != null;
  }

  String get Token {
    if (_userToken != null || _useremail == _email
        /* _expiryDate.isAfter(DateTime.now()) ||
        _expiryDate != 0 */
        ) {
      return _userToken;
    }
  }

  Future<void> LogIn(String _userEmail, String _userPassword) async {
    _useremail = _userEmail;
    try {
      /* var url =
          "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCUSgNoi2_FGDpxINZfge14glYwhv4F9d0" */ /* dotenv.env['URL1'] */;
      final response = await http.post(FlutterConfig.get('URL1'),
          body: json.encode({
            'email': _userEmail,
            'password': _userPassword,
            'returnSecureToken': true
          }));
      final _userData = json.decode(response.body);
      _userId = _userData['idToken'];
      _userToken = _userData['localId'];
      /* _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse((_userData['expiresIn'])))); */
      _refreshToken = (_userData['refreshToken']);
      _email = _userData['email'];
    } catch (error) {
      print(error);
    }
  }

  Future<void> Signup(
    String _userEmail,
    String _userPassword,
  ) async {
    try {
      /* var url =
          "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCUSgNoi2_FGDpxINZfge14glYwhv4F9d0"  */ /* dotenv.env['URL2'] */;
      final signupresponse = await http.post(FlutterConfig.get('URL2'),
          body: json.encode({
            'email': _userEmail,
            'password': _userPassword,
            'returnSecureToken': true
          }));
      final resp = (json.decode(signupresponse.body));
      if (resp['error'] != null) {
        throw ErrorHandling(resp['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> SignOut(BuildContext context) async {
    Navigator.of(context).pop(context);
  }

  getData() {
    return _userId;
  }
}
