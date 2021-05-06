import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'vending.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Image.asset('assets/splash.png'),
            SizedBox(height: 40.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Логин',
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Пароль',
              ),
              obscureText: true,
            ),
            ButtonBar(
              children: <Widget>[
                TextButton(
                  child: Text('ОЧИСТИТЬ'),
                  onPressed: () {
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                ),
                TextButton(
                  child: Text('ВХОД'),
                  onPressed: () {
                    var url = Uri.parse(
                        'https://app.tseh85.com/DemoService/api/AuthenticateVending');
                    post(url,
                        headers: {"Content-Type": "application/json"},
                        body: json.encode({
                          'Login': _usernameController.text,
                          'Password': _passwordController.text
                        })).then((response) {
                      print('Status: ${response.statusCode}');
                      print('Name: ${jsonDecode(response.body)["Name"]}');
                      print('Token: ${response.headers["token"]}');
                    });
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => VendingPage()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
