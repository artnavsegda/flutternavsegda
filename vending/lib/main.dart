import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'login.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppModel(),
      child: VendingApp(),
    ),
  );
}

class AppModel with ChangeNotifier {
  String token = "";
  String userName = "";

  Future login(String login, String password) {
    print('login $login pass $password');
    var url =
        Uri.parse('https://app.tseh85.com/service/api/AuthenticateVending');
    return post(url,
            headers: {"Content-Type": "application/json"},
            body: json.encode({'Login': login, 'Password': password}))
        .then((response) {
      print('Status: ${response.statusCode}');
      print('Name: ${jsonDecode(response.body)["Name"]}');
      userName = jsonDecode(response.body)["Name"];

      print('Token: ${response.headers["token"]}');
      token = response.headers["token"]!;

      notifyListeners();
      return token;
    });
  }

  Future startup() {
    return SharedPreferences.getInstance().then((prefs) {
      userName = prefs.getString('username') ?? "";
      token = prefs.getString('token') ?? "";
      return token;
    });
  }
}

class VendingApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: LoginPage(title: 'Цехомат'),
    );
  }
}
