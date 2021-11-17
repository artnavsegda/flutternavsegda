import 'package:flutter/material.dart';

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          onTap: () {},
          title: const Text("Служба поддержки"),
          leading: const Image(
              image: AssetImage('assets/ic-24/icon-24-support.png')),
        ),
        ListTile(
          onTap: () {},
          title: const Text("Справка"),
          leading:
              const Image(image: AssetImage('assets/ic-24/icon-24-info.png')),
        ),
        ListTile(
          onTap: () async {},
          title: const Text("Уведомления"),
          leading: const Image(
              image: AssetImage('assets/ic-24/icon-24-support.png')),
        ),
        ListTile(
          onTap: () async {},
          title: const Text("Оценить приложение"),
          leading: const Image(
              image: AssetImage('assets/ic-24/icon-24-feedback.png')),
        ),
      ],
    );
  }
}
