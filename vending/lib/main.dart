import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(VendingApp());
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
                    print('user ${_usernameController.text}');
                    print('pass ${_passwordController.text}');

                    var url = Uri.parse(
                        'app.tseh85.com/DemoService/api/AuthenticateVending');
                    post(url, body: {
                      'Login': _usernameController.text,
                      'Password': _passwordController.text
                    }).then((response) {
                      print('Response status: ${response.statusCode}');
                      print('Response body: ${response.body}');
                    });

                    //Navigator.pop(context);
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
