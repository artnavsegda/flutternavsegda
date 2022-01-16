import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: Text('Enter'),
        ),
      ),
    );
  }
}
