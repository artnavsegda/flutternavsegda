import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginState extends ChangeNotifier {
  final SharedPreferences prefs;
  bool _loggedIn = false;
  String _token = '';

  LoginState(this.prefs) {
    loggedIn = prefs.getBool('LoggedIn') ?? false;
    token = prefs.getString('token') ?? "";
  }

  bool get loggedIn => _loggedIn;
  set loggedIn(bool value) {
    _loggedIn = value;
    prefs.setBool('LoggedIn', value);
    notifyListeners();
  }

  String get token => _token;
  set token(String newToken) {
    _token = newToken;
    print(newToken);
    prefs.setString('token', newToken);
    notifyListeners();
  }

  void checkLoggedIn() {
    loggedIn = prefs.getBool('LoggedIn') ?? false;
  }
}
