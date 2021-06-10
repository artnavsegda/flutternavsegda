import 'package:flutter/material.dart';

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text("Служба поддержки"),
          trailing: Image(image: AssetImage('assets/ic-24/icons-home.png')),
        ),
        ListTile(
          title: Text("Справка"),
          trailing: Image(image: AssetImage('assets/ic-24/icons-home.png')),
        ),
        ListTile(
          title: Text("Уведомления"),
          trailing: Image(image: AssetImage('assets/ic-24/icons-home.png')),
        ),
        ListTile(
          title: Text("Оценить приложение"),
          trailing: Image(image: AssetImage('assets/ic-24/icons-home.png')),
        ),
      ],
    );
  }
}
