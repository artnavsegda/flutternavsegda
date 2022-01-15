import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginState extends ChangeNotifier {
  final SharedPreferences prefs;
  bool _loggedIn = false;

  LoginState(this.prefs) {
    loggedIn = prefs.getBool('LoggedIn') ?? false;
  }

  bool get loggedIn => _loggedIn;
  set loggedIn(bool value) {
    _loggedIn = value;
    prefs.setBool('LoggedIn', value);
    notifyListeners();
  }

  void checkLoggedIn() {
    loggedIn = prefs.getBool('LoggedIn') ?? false;
  }
}
