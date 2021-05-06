import 'package:flutter/material.dart';

class VendingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hello"),
      ),
      body: SafeArea(
        child: Center(
          child: Text(
            'Hello, world!',
            textDirection: TextDirection.ltr,
          ),
        ),
      ),
    );
  }
}
