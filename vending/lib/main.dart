import 'package:flutter/material.dart';
import 'login.dart';

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
