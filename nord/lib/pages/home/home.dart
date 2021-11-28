import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading:
                Image.asset('assets/Illustration Colored Delivery Options.png'),
            title: Text("Адрес доставки или кафе"),
          ),
          Text("Акции"),
        ],
      ),
    );
  }
}
