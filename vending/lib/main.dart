import 'package:flutter/material.dart';
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

  void login(String login, String password) {
    print('login $login pass $password');
    var url =
        Uri.parse('https://app.tseh85.com/DemoService/api/AuthenticateVending');
    post(url,
            headers: {"Content-Type": "application/json"},
            body: json.encode({'Login': login, 'Password': password}))
        .then((response) {
      print('Status: ${response.statusCode}');
      print('Name: ${jsonDecode(response.body)["Name"]}');
      print('Token: ${response.headers["token"]}');
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
