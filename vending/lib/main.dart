import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'login.dart';
import 'vending.dart';

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

  Future<String> login(String login, String password) async {
    print('login $login pass $password');
    var url =
        Uri.parse('https://app.tseh85.com/service/api/AuthenticateVending');

    final prefs = await SharedPreferences.getInstance();

    var response = await post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'Login': login, 'Password': password}));

    print('Status: ${response.statusCode}');
    print('Name: ${jsonDecode(response.body)["Name"]}');
    userName = jsonDecode(response.body)["Name"];
    prefs.setString('username', userName);
    print('Token: ${response.headers["token"]}');
    token = response.headers["token"]!;
    prefs.setString('token', token);
    notifyListeners();
    return token;
  }

  Future<String> logout() async {
    final prefs = await SharedPreferences.getInstance();
    userName = "";
    prefs.setString('username', "");
    token = "";
    prefs.setString('token', "");
    notifyListeners();
    return token;
  }

  Future<String> startup() async {
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('username') ?? "";
    token = prefs.getString('token') ?? "";
    await Permission.location.request();
    return token;
  }
}

class VendingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.read<AppModel>();
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: FutureBuilder<String>(
          future: appState.startup(),
          builder: (buildContext, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == "") {
                return LoginPage(title: 'Цехомат');
              } else {
                return VendingPage();
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
