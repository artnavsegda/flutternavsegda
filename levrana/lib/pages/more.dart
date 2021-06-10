import 'package:flutter/material.dart';

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(title: Text("Служба поддержки")),
        ListTile(title: Text("Справка")),
        ListTile(title: Text("Уведомления")),
        ListTile(title: Text("Оценить приложение")),
      ],
    );
  }
}
