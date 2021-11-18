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
          leading:
              const Image(image: AssetImage('assets/Icon Question Answer.png')),
        ),
        ListTile(
          onTap: () {},
          title: const Text("Справка"),
          leading:
              const Image(image: AssetImage('assets/Icon Contact Support.png')),
        ),
        ListTile(
          onTap: () async {},
          title: const Text("Оценить приложение"),
          leading: const Image(
              image: AssetImage('assets/Icon Star Rate Outlined.png')),
        ),
        ListTile(
          onTap: () async {},
          title: const Text("О приложении"),
          leading: const Image(image: AssetImage('assets/Icon Info.png')),
        ),
      ],
    );
  }
}
