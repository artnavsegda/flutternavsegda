import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
        child: Text('OK'),
        onPressed: () {
          //Navigator.popUntil(context, ModalRoute.withName("/main"));
          context.go('/main');
        },
      ),
    ));
  }
}
