import 'package:flutter/material.dart';

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Служба поддержки"),
        Text("Справка"),
        Text("Уведомления"),
        Text("Оценить приложение"),
      ],
    );
  }
}
